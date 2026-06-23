import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/utils/url_launcher_helper.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_logo_header.dart';

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
    title: 'IOS Developer',
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
  List<_Developer> get _mobileDevelopers =>
      Platform.isIOS ? <_Developer>[_eda, _muhammed] : <_Developer>[_muhammed, _eda];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(),
        body: AppBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const AppLogoHeader(),
                  Image.asset(AppAssets.logo, height: 200),
                  Padding(
                    padding: const EdgeInsets.all(AppConstants.pagePadding),
                    child: Text(
                      context.l10n.aboutText,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  TabBar(
                    tabs: <Widget>[
                      Tab(
                        icon: const Icon(Icons.phone_android),
                        text: context.l10n.mobileDevelopers,
                      ),
                      Tab(
                        icon: const Icon(Icons.developer_mode),
                        text: context.l10n.backendDevelopers,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 320,
                    child: TabBarView(
                      children: <Widget>[
                        ListView(
                          children: _mobileDevelopers
                              .map((_Developer d) => _DeveloperCard(d))
                              .toList(),
                        ),
                        ListView(
                          children: const <Widget>[_DeveloperCard(_kursat)],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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

  final _Developer developer;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color onContainer = scheme.onPrimaryContainer;
    return Card(
      color: scheme.primaryContainer,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            ClipOval(
              child: Image.network(
                developer.image,
                height: 72,
                width: 72,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.person, size: 72, color: onContainer),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    developer.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: onContainer),
                  ),
                  Text(
                    developer.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: onContainer),
                  ),
                  Row(
                    children: <Widget>[
                      _SocialButton(
                        icon: FontAwesomeIcons.linkedin,
                        url: developer.linkedIn,
                        color: onContainer,
                      ),
                      _SocialButton(
                        icon: FontAwesomeIcons.github,
                        url: developer.github,
                        color: onContainer,
                      ),
                      _SocialButton(
                        icon: FontAwesomeIcons.at,
                        url: developer.mail,
                        color: onContainer,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.url,
    required this.color,
  });

  final FaIconData icon;
  final String url;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: FaIcon(icon, color: color, size: 20),
      onPressed: () => UrlLauncherHelper.open(url),
    );
  }
}
