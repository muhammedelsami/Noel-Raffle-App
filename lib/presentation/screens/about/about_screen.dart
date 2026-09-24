import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/url_launcher_helper.dart';
import '../../widgets/app_card.dart';
import '../../widgets/brand_mark.dart';
import '../../widgets/initials_avatar.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/section_header.dart';

/// Static team/credits screen.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _Developer _muhammed = _Developer(
    name: 'Muhammed Elşami',
    title: 'Android Developer',
    image: 'https://avatars.githubusercontent.com/u/69201829?v=4',
    linkedIn: 'https://www.linkedin.com/in/muhammed-elsami/',
    github: 'https://github.com/muhammedelsami',
    mail: 'mailto:muhammed97r@hotmail.com',
  );

  static const _Developer _eda = _Developer(
    name: 'Eda Barutçu',
    title: 'iOS Developer',
    image: 'https://avatars.githubusercontent.com/u/91742636?v=4',
    linkedIn: 'https://www.linkedin.com/in/eda-barutcu/',
    github: 'https://github.com/edabarutcu',
    mail: 'mailto:edabarutcu@protonmail.com',
  );

  static const _Developer _kursat = _Developer(
    name: 'Kürşat Şimşek',
    title: 'Full Stack Developer',
    image: 'https://avatars.githubusercontent.com/u/80540635?v=4',
    linkedIn: 'https://www.linkedin.com/in/kursatsmsek/',
    github: 'https://github.com/kursatsmsek',
    mail: 'mailto:kursatsimsek@protonmail.ch',
  );

  /// Mobile developers ordered so the current platform's developer is first.
  static List<_Developer> get _mobileDevelopers =>
      defaultTargetPlatform == TargetPlatform.iOS
          ? const <_Developer>[_eda, _muhammed]
          : const <_Developer>[_muhammed, _eda];

  @override
  Widget build(BuildContext context) {
    final TextTheme text = context.textTheme;
    return PageScaffold(
      title: context.l10n.about,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.lg,
          AppSpacing.page,
          AppSpacing.xl,
        ),
        children: <Widget>[
          const Center(child: BrandMark(size: 88)),
          const SizedBox(height: AppSpacing.lg),
          Text(
            context.l10n.appName,
            textAlign: TextAlign.center,
            style: text.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            context.l10n.aboutText,
            textAlign: TextAlign.center,
            style: text.bodyLarge
                ?.copyWith(color: context.colors.onSurfaceVariant),
          ),
          SectionHeader(context.l10n.mobileDevelopers),
          for (final _Developer developer in _mobileDevelopers) ...<Widget>[
            _DeveloperCard(developer),
            const SizedBox(height: AppSpacing.sm),
          ],
          SectionHeader(context.l10n.backendDevelopers),
          const _DeveloperCard(_kursat),
        ],
      ),
    );
  }
}

class _Developer {
  const _Developer({
    required this.name,
    required this.title,
    required this.image,
    required this.linkedIn,
    required this.github,
    required this.mail,
  });

  final String name;
  final String title;
  final String image;
  final String linkedIn;
  final String github;
  final String mail;
}

class _DeveloperCard extends StatelessWidget {
  const _DeveloperCard(this.developer);

  static const double _avatarSize = 56;

  final _Developer developer;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colors;
    // Decode the avatar at its display size instead of full resolution.
    final int cacheSize =
        (_avatarSize * MediaQuery.devicePixelRatioOf(context)).round();
    return AppCard(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
      ),
      child: Row(
        children: <Widget>[
          ClipOval(
            child: Image.network(
              developer.image,
              width: _avatarSize,
              height: _avatarSize,
              cacheWidth: cacheSize,
              cacheHeight: cacheSize,
              fit: BoxFit.cover,
              excludeFromSemantics: true,
              frameBuilder: (_, Widget child, int? frame, bool synchronous) =>
                  synchronous || frame != null
                      ? child
                      : InitialsAvatar(developer.name, size: _avatarSize),
              errorBuilder: (_, __, ___) =>
                  InitialsAvatar(developer.name, size: _avatarSize),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(developer.name, style: context.textTheme.titleMedium),
                Text(
                  developer.title,
                  style: context.textTheme.bodySmall
                      ?.copyWith(color: colors.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: <Widget>[
                    _SocialButton(
                      icon: FontAwesomeIcons.linkedin,
                      tooltip: 'LinkedIn',
                      url: developer.linkedIn,
                    ),
                    _SocialButton(
                      icon: FontAwesomeIcons.github,
                      tooltip: 'GitHub',
                      url: developer.github,
                    ),
                    _SocialButton(
                      icon: FontAwesomeIcons.envelope,
                      tooltip: 'E-mail',
                      url: developer.mail,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.tooltip,
    required this.url,
  });

  final FaIconData icon;
  final String tooltip;
  final String url;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      icon: FaIcon(icon, size: 18, color: context.colors.onSurfaceVariant),
      onPressed: () => UrlLauncherHelper.open(url),
    );
  }
}
