import 'package:equatable/equatable.dart';

import 'raffle_type.dart';

/// The setup data captured before participants are added.
class RaffleConfig extends Equatable {
  const RaffleConfig({
    required this.title,
    required this.type,
    this.note = '',
  });

  final String title;
  final RaffleType type;

  /// Optional message shown to every participant with their result
  /// (e.g. the gift budget or when the gifts are exchanged).
  final String note;

  @override
  List<Object?> get props => <Object?>[title, type, note];
}
