import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/di/injection.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/l10n/raffle_texts.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/raffle_type_style.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/raffle.dart';
import '../../../domain/entities/raffle_config.dart';
import '../../../domain/entities/raffle_draft.dart';
import '../../../domain/entities/raffle_type.dart';
import '../../../domain/usecases/schedule_reminder.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/illustration.dart';
import '../../widgets/note_line.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/step_header.dart';
import '../../widgets/tile_group.dart';
import '../participants/participants_screen.dart';

/// First step of both flows: the raffle title, an optional note for the
/// participants and an optional gift day with a reminder.
class RaffleSetupScreen extends StatefulWidget {
  const RaffleSetupScreen({super.key, required this.type}) : template = null;

  /// Starts a new raffle for the same group as [raffle]: its title, note,
  /// people, gifts and rules are filled in and can still be changed. Its gift
  /// day is kept only while it is still ahead.
  RaffleSetupScreen.again(Raffle raffle, {super.key})
      : type = raffle.type,
        template = raffle;

  final RaffleType type;
  final Raffle? template;

  @override
  State<RaffleSetupScreen> createState() => _RaffleSetupScreenState();
}

class _RaffleSetupScreenState extends State<RaffleSetupScreen> {
  late final TextEditingController _titleController =
      TextEditingController(text: widget.template?.title);
  late final TextEditingController _noteController =
      TextEditingController(text: widget.template?.note);
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _noteFocus = FocusNode();
  late DateTime? _eventDate = _upcoming(widget.template?.eventDate);
  late bool _remind =
      _eventDate != null && (widget.template?.config.remind ?? false);

  /// Shown under the title field after a submit without a title.
  String? _titleError;

  /// Set when the user turned the reminder on but notifications are denied.
  bool _notificationsOff = false;

  static DateTime get _today => DateUtils.dateOnly(DateTime.now());

  static DateTime? _upcoming(DateTime? day) =>
      day == null || day.isBefore(_today) ? null : day;

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _titleFocus.dispose();
    _noteFocus.dispose();
    super.dispose();
  }

  void _onTitleChanged(String _) {
    if (_titleError != null) setState(() => _titleError = null);
  }

  Future<void> _pickDate() async {
    final DateTime today = _today;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _eventDate ?? DateTime(today.year, today.month, today.day + 7),
      firstDate: today,
      lastDate: DateTime(today.year + 2, today.month, today.day),
      helpText: context.l10n.giftDay,
    );
    if (picked != null) setState(() => _eventDate = DateUtils.dateOnly(picked));
  }

  void _clearDate() => setState(() {
        _eventDate = null;
        _remind = false;
        _notificationsOff = false;
      });

  Future<void> _setRemind(bool value) async {
    final bool allowed =
        value && await sl<ScheduleReminder>().requestPermission();
    if (!mounted) return;
    setState(() {
      _remind = allowed;
      _notificationsOff = value && !allowed;
    });
  }

  void _submit() {
    if (!Validators.isNotBlank(_titleController.text)) {
      setState(() => _titleError = context.l10n.enterTitle);
      _titleFocus.requestFocus();
      return;
    }
    final RaffleConfig config = RaffleConfig(
      title: _titleController.text.trim(),
      note: _noteController.text.trim(),
      type: widget.type,
      eventDate: _eventDate,
      remind: _eventDate != null && _remind,
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ParticipantsScreen(
          config: config,
          draft: switch (widget.template) {
            final Raffle raffle => RaffleDraft.from(raffle),
            null => RaffleDraft.empty,
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: raffleTypeLabel(context.l10n, widget.type),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.sm,
          AppSpacing.page,
          AppSpacing.xl,
        ),
        children: <Widget>[
          StepHeader(
            type: widget.type,
            step: 1,
            title: context.l10n.raffleDetails,
            subtitle: context.l10n.raffleDetailsInfo,
            trailing: Illustration(widget.type.illustration, size: 64),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppTextField(
            controller: _titleController,
            focusNode: _titleFocus,
            label: context.l10n.raffleTitleHint,
            icon: Icons.edit_outlined,
            errorText: _titleError,
            maxLength: AppConstants.maxTitleLength,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            onChanged: _onTitleChanged,
            onSubmitted: (_) => _noteFocus.requestFocus(),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: _noteController,
            focusNode: _noteFocus,
            label: context.l10n.raffleNoteHint,
            icon: Icons.notes_rounded,
            maxLength: AppConstants.maxNoteLength,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: AppSpacing.sm),
          _GiftDay(
            day: _eventDate,
            remind: _remind,
            notificationsOff: _notificationsOff,
            onPick: _pickDate,
            onClear: _clearDate,
            onRemindChanged: _setRemind,
          ),
        ],
      ),
      bottomBar: AppButton(label: context.l10n.next, onPressed: _submit),
    );
  }
}

/// The optional gift day and the reminder switch.
class _GiftDay extends StatelessWidget {
  const _GiftDay({
    required this.day,
    required this.remind,
    required this.notificationsOff,
    required this.onPick,
    required this.onClear,
    required this.onRemindChanged,
  });

  final DateTime? day;
  final bool remind;
  final bool notificationsOff;
  final VoidCallback onPick;
  final VoidCallback onClear;
  final ValueChanged<bool> onRemindChanged;

  @override
  Widget build(BuildContext context) {
    final DateTime? day = this.day;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TileGroup(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.event_rounded),
              title: Text(
                day == null
                    ? context.l10n.giftDayOptional
                    : giftDayLabel(context.l10n, day),
              ),
              subtitle: Text(
                day == null ? context.l10n.giftDayHint : context.l10n.giftDay,
              ),
              trailing: day == null
                  ? null
                  : IconButton(
                      tooltip: context.l10n.clearDate,
                      icon: const Icon(Icons.close_rounded),
                      onPressed: onClear,
                    ),
              onTap: onPick,
            ),
            if (day != null)
              SwitchListTile(
                value: remind,
                onChanged: onRemindChanged,
                secondary: const Icon(Icons.notifications_outlined),
                title: Text(context.l10n.remindMe),
                subtitle: Text(context.l10n.remindMeInfo),
              ),
          ],
        ),
        if (notificationsOff) ...<Widget>[
          const SizedBox(height: AppSpacing.sm),
          NoteLine(
            context.l10n.notificationsOff,
            icon: Icons.notifications_off_outlined,
          ),
        ],
      ],
    );
  }
}
