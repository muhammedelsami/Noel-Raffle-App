import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../domain/repositories/reminder_scheduler.dart';
import '../../l10n/app_localizations.dart';

/// Schedules reminders as local notifications on Android and iOS.
///
/// The plugin is set up on first use, so it costs nothing at startup, and
/// permission is only asked for when the user turns a reminder on.
class LocalReminderScheduler implements ReminderScheduler {
  LocalReminderScheduler([FlutterLocalNotificationsPlugin? plugin])
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  /// Drawable in `android/app/src/main/res`, kept from resource shrinking
  /// by `res/raw/keep.xml`.
  static const String androidIcon = 'ic_notification';
  static const String _channelId = 'reminders';

  /// Reminders are one-off instants, so they are scheduled in UTC and need
  /// no time zone database. The device still shows them at the local time
  /// they were set for.
  static final tz.Location _utc = tz.Location(
    'UTC',
    <int>[tz.minTime],
    <int>[0],
    <tz.TimeZone>[tz.TimeZone.UTC],
  );

  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _ready;

  Future<void> _initialize() => _ready ??= _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings(androidIcon),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
      );

  @override
  Future<bool> requestPermission() async {
    await _initialize();
    final bool? granted = switch (defaultTargetPlatform) {
      TargetPlatform.android => await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission(),
      TargetPlatform.iOS => await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, sound: true),
      _ => false,
    };
    return granted ?? false;
  }

  @override
  Future<void> schedule({
    required String raffleId,
    required DateTime at,
    required String title,
    required String body,
  }) async {
    await _initialize();
    final AppLocalizations l10n = _systemLocalizations();
    await _plugin.zonedSchedule(
      id: notificationId(raffleId),
      scheduledDate: tz.TZDateTime.from(at, _utc),
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          l10n.reminderChannel,
          channelDescription: l10n.reminderChannelInfo,
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(body),
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      // Inexact alarms need no special permission; a few minutes late is
      // fine for a reminder a day ahead.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancel(String raffleId) async {
    await _initialize();
    await _plugin.cancel(id: notificationId(raffleId));
  }

  /// A stable id for the raffle's reminder. Notification ids are 32-bit
  /// integers, so the raffle id is hashed (FNV-1a) into a positive one.
  static int notificationId(String raffleId) {
    int hash = 0x811c9dc5;
    for (final int unit in raffleId.codeUnits) {
      hash = ((hash ^ unit) * 0x01000193) & 0xffffffff;
    }
    return hash & 0x7fffffff;
  }

  /// The notification channel shows up in the system settings, so it is named
  /// in the device language.
  static AppLocalizations _systemLocalizations() {
    final String language = PlatformDispatcher.instance.locale.languageCode;
    return lookupAppLocalizations(
      AppLocalizations.supportedLocales.firstWhere(
        (Locale locale) => locale.languageCode == language,
        orElse: () => const Locale('en'),
      ),
    );
  }
}
