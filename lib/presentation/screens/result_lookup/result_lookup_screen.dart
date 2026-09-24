import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/di/injection.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/theme_context.dart';
import '../../../domain/entities/shared_result.dart';
import '../../cubit/result_lookup/result_lookup_cubit.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/icon_badge.dart';
import '../../widgets/info_banner.dart';
import '../../widgets/page_scaffold.dart';
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
    final ColorScheme colors = context.colors;
    return PageScaffold(
      title: context.l10n.viewMyResult,
      body: BlocBuilder<ResultLookupCubit, ResultLookupState>(
        builder: (BuildContext context, ResultLookupState state) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.page,
              AppSpacing.lg,
              AppSpacing.page,
              AppSpacing.xl,
            ),
            children: <Widget>[
              Center(
                child: IconBadge(
                  icon: Icons.key_rounded,
                  size: 64,
                  circle: true,
                  background: colors.tertiaryContainer,
                  foreground: colors.onTertiaryContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                context.l10n.lookupInfo,
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(
                controller: _codeController,
                label: context.l10n.codeHint,
                icon: Icons.password_rounded,
                maxLength: AppConstants.maxCodeLength,
                textCapitalization: TextCapitalization.characters,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _lookup(),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: context.l10n.showResult,
                icon: Icons.search_rounded,
                loading: state.isLoading,
                onPressed: _lookup,
              ),
              const SizedBox(height: AppSpacing.xl),
              AnimatedSwitcher(
                duration: AppMotion.medium,
                child: _LookupOutcome(
                  key: ValueKey<ResultLookupStatus>(state.status),
                  state: state,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LookupOutcome extends StatelessWidget {
  const _LookupOutcome({super.key, required this.state});

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
      return InfoBanner(tone: BannerTone.error, message: error);
    }

    final SharedResult? result = state.result;
    if (result == null) return const SizedBox.shrink();
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            result.title,
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium
                ?.copyWith(color: context.colors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.lg),
          ResultCard(
            type: result.type,
            participantName: result.participantName,
            match: result.match,
            matchWish: result.matchWish,
            note: result.note,
            eventDate: result.eventDate,
          ),
        ],
      ),
    );
  }
}
