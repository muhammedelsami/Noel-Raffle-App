import 'package:equatable/equatable.dart';

import 'raffle_type.dart';

/// The setup data captured before participants are added.
class RaffleConfig extends Equatable {
  const RaffleConfig({
    required this.title,
    required this.type,
    this.note = '',
    this.eventDate,
    this.remind = false,
  });

  final String title;
  final RaffleType type;

  /// Optional message shown to every participant with their result
  /// (e.g. the gift budget or when the gifts are exchanged).
  final String note;

  /// The day the gifts are handed out, as a local date without a time.
  final DateTime? eventDate;

  /// Whether this device reminds about [eventDate] with a notification.
  final bool remind;

  @override
  List<Object?> get props => <Object?>[title, type, note, eventDate, remind];
}
