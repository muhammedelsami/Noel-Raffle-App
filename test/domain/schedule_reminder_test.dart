import 'package:flutter_test/flutter_test.dart';
import 'package:noel_raffle/core/notifications/local_reminder_scheduler.dart';
import 'package:noel_raffle/data/repositories/online_raffle_repository_impl.dart';
import 'package:noel_raffle/domain/entities/draw_assignment.dart';
import 'package:noel_raffle/domain/entities/raffle.dart';
import 'package:noel_raffle/domain/entities/raffle_config.dart';
import 'package:noel_raffle/domain/entities/raffle_type.dart';
import 'package:noel_raffle/domain/usecases/delete_raffle.dart';
import 'package:noel_raffle/domain/usecases/schedule_reminder.dart';

import '../fakes/recording_reminders.dart';
import '../presentation/raffle_draw_cubit_test.dart' show InMemoryHistory;

void main() {
  final DateTime giftDay = DateTime(2026, 12, 24);

  Raffle raffle({bool remind = true, DateTime? day}) => Raffle(
        id: 'r1',
        config: RaffleConfig(
          title: 'Office',
          type: RaffleType.newYear,
          eventDate: day ?? giftDay,
          remind: remind,
        ),
        createdAt: DateTime(2026, 12, 1),
        assignments: const <DrawAssignment>[],
      );

  group('ScheduleReminder.reminderTime', () {
    test('is 10:00 the day before', () {
      expect(
        ScheduleReminder.reminderTime(giftDay, DateTime(2026, 12, 20)),
        DateTime(2026, 12, 23, 10),
      );
    });

    test('falls back to 9:00 on the day itself', () {
      expect(
        ScheduleReminder.reminderTime(giftDay, DateTime(2026, 12, 23, 18)),
        DateTime(2026, 12, 24, 9),
      );
    });

    test('is null once the gift day has begun', () {
      expect(
        ScheduleReminder.reminderTime(giftDay, DateTime(2026, 12, 24, 9, 1)),
        isNull,
      );
    });

    test('handles the first of the month', () {
      expect(
        ScheduleReminder.reminderTime(
          DateTime(2027, 1, 1),
          DateTime(2026, 12, 1),
        ),
        DateTime(2026, 12, 31, 10),
      );
    });
  });

  group('ScheduleReminder', () {
    late RecordingReminders reminders;
    late ScheduleReminder schedule;

    setUp(() {
      reminders = RecordingReminders();
      schedule = ScheduleReminder(
        reminders,
        clock: () => DateTime(2026, 12, 20),
      );
    });

    test('schedules the reminder of a raffle that asks for one', () async {
      final DateTime? at =
          await schedule(raffle(), title: 'Office', body: 'Tomorrow!');
      expect(at, DateTime(2026, 12, 23, 10));
      expect(reminders.scheduled['r1']?.at, at);
      expect(reminders.scheduled['r1']?.body, 'Tomorrow!');
    });

    test('does nothing when the reminder is off or too late', () async {
      expect(
        await schedule(raffle(remind: false), title: 't', body: 'b'),
        isNull,
      );
      expect(
        await schedule(raffle(day: DateTime(2026, 12, 19)),
            title: 't', body: 'b'),
        isNull,
      );
      expect(reminders.scheduled, isEmpty);
    });

    test('never throws when notifications fail', () async {
      reminders.failing = true;
      expect(await schedule(raffle(), title: 't', body: 'b'), isNull);
    });
  });

  test('deleting a raffle cancels its reminder', () async {
    final RecordingReminders reminders = RecordingReminders();
    final InMemoryHistory history = InMemoryHistory();
    final Raffle saved = raffle();
    await history.save(saved);
    await ScheduleReminder(reminders, clock: () => DateTime(2026, 12, 20))(
      saved,
      title: 't',
      body: 'b',
    );

    await DeleteRaffle(
        history, const OnlineRaffleRepositoryImpl(null), reminders)(
      saved,
    );
    expect(reminders.scheduled, isEmpty);
    expect(history.saved, isEmpty);
  });

  test('notification ids are stable positive 32-bit integers', () {
    final int id = LocalReminderScheduler.notificationId('m0x1abc');
    expect(id, LocalReminderScheduler.notificationId('m0x1abc'));
    expect(id, isNot(LocalReminderScheduler.notificationId('m0x1abd')));
    expect(id, inInclusiveRange(0, 0x7fffffff));
  });
}
