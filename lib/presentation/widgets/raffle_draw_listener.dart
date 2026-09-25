import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/injection.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/l10n/raffle_texts.dart';
import '../../domain/entities/draw_assignment.dart';
import '../../domain/entities/raffle.dart';
import '../../domain/entities/raffle_rules.dart';
import '../../domain/usecases/schedule_reminder.dart';
import '../cubit/raffle_draw/raffle_draw_cubit.dart';
import '../screens/raffle_result/raffle_result_screen.dart';
import 'app_dialogs.dart';
import 'draw_animation.dart';

/// Opens the result screen once [RaffleDrawCubit] has drawn the raffle, or
/// explains why it could not be drawn. Shared by the last step of each flow.
class RaffleDrawListener extends StatelessWidget {
  const RaffleDrawListener({super.key, required this.child});

  final Widget child;

  /// Sets up the gift day reminder in the background, if one was asked for.
  static void _scheduleReminder(BuildContext context, Raffle raffle) {
    final DateTime? day = raffle.eventDate;
    if (day == null || !raffle.config.remind) return;
    unawaited(
      sl<ScheduleReminder>()(
        raffle,
        title: raffle.title,
        body: context.l10n.reminderBody(giftDayLabel(context.l10n, day)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RaffleDrawCubit, RaffleDrawState>(
      listener: (BuildContext context, RaffleDrawState state) async {
        if (state.status == RaffleDrawStatus.success) {
          final Raffle raffle = state.raffle!;
          _scheduleReminder(context, raffle);
          await showDrawAnimation(
            context,
            names: <String>[
              for (final DrawAssignment a in raffle.assignments)
                a.participant.name,
            ],
          );
          if (context.mounted) {
            RaffleResultScreen.openAfterDraw(context, raffle);
          }
        } else if (state.status == RaffleDrawStatus.failure) {
          final RaffleRuleViolation? violation = state.violation;
          showWarningDialog(
            context,
            violation == null
                ? context.l10n.genericError
                : ruleViolationMessage(context.l10n, violation),
          );
        }
      },
      child: child,
    );
  }
}
