import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/di/injection.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../domain/entities/shared_result.dart';
import '../../cubit/result_lookup/result_lookup_cubit.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_logo_header.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/result_card.dart';

/// Lets a participant see their own result with the personal code the
/// organizer sent them. Only shown when Firebase is configured.
class ResultLookupScreen extends StatelessWidget {
  const ResultLookupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ResultLookupCubit>(
      create: (_) => sl<ResultLookupCubit>(),
      child: const _ResultLookupView(),
    );
  }
}

class _ResultLookupView extends StatefulWidget {
  const _ResultLookupView();

  @override
  State<_ResultLookupView> createState() => _ResultLookupViewState();
}

class _ResultLookupViewState extends State<_ResultLookupView> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _lookup() {
    FocusScope.of(context).unfocus();
    context.read<ResultLookupCubit>().lookup(_codeController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.pagePadding),
            child: BlocBuilder<ResultLookupCubit, ResultLookupState>(
              builder: (BuildContext context, ResultLookupState state) {
                return Column(
                  children: <Widget>[
                    const AppLogoHeader(),
                    GlassCard(
                      child: Column(
                        children: <Widget>[
                          Text(
                            context.l10n.lookupInfo,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            controller: _codeController,
                            label: context.l10n.codeHint,
                            maxLength: 12,
                            textCapitalization: TextCapitalization.characters,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (_) => _lookup(),
                          ),
                          const SizedBox(height: 16),
                          PrimaryButton(
                            label: context.l10n.showResult,
                            icon: Icons.search_rounded,
                            loading: state.isLoading,
                            onPressed: _lookup,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _LookupOutcome(state: state),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _LookupOutcome extends StatelessWidget {
  const _LookupOutcome({required this.state});

  final ResultLookupState state;

  @override
  Widget build(BuildContext context) {
    final String? error = switch (state.status) {
      ResultLookupStatus.invalidCode => context.l10n.invalidCode,
      ResultLookupStatus.notFound => context.l10n.resultNotFound,
      ResultLookupStatus.failure => context.l10n.lookupFailed,
      _ => null,
    };
    if (error != null) {
      return GlassCard(
        child: Text(
          error,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
      );
    }

    final SharedResult? result = state.result;
    if (result == null) return const SizedBox.shrink();
    return GlassCard(
      child: Column(
        children: <Widget>[
          Text(
            result.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ResultCard(
            type: result.type,
            participantName: result.participantName,
            match: result.match,
            note: result.note,
          ),
        ],
      ),
    );
  }
}
