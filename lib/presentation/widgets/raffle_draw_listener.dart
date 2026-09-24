import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/l10n/raffle_texts.dart';
import '../../domain/entities/raffle_rules.dart';
import '../cubit/raffle_draw/raffle_draw_cubit.dart';
import '../screens/raffle_result/raffle_result_screen.dart';
import 'app_dialogs.dart';

/// Opens the result screen once [RaffleDrawCubit] has drawn the raffle, or
/// explains why it could not be drawn. Shared by the last step of each flow.
class RaffleDrawListener extends StatelessWidget {
  const RaffleDrawListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RaffleDrawCubit, RaffleDrawState>(
      listener: (BuildContext context, RaffleDrawState state) {
        if (state.status == RaffleDrawStatus.success) {
          RaffleResultScreen.openAfterDraw(context, state.raffle!);
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
