import 'package:equatable/equatable.dart';

import 'raffle_type.dart';

/// The setup data captured before participants are added: the raffle title and
/// the numeric group/sector codes expected by the backend.
class RaffleConfig extends Equatable {
  const RaffleConfig({
    required this.title,
    required this.type,
    required this.group,
    required this.sector,
  });

  final String title;
  final RaffleType type;
  final int group;
  final int sector;

  @override
  List<Object?> get props => <Object?>[title, type, group, sector];
}
