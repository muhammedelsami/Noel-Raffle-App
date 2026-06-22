part of 'raffle_setup_cubit.dart';

class RaffleSetupState extends Equatable {
  const RaffleSetupState({this.groupLabel, this.sectorLabel});

  final String? groupLabel;
  final String? sectorLabel;

  /// Backend code for the chosen group, or the legacy default when none.
  int get group =>
      AppConstants.groupOptions[groupLabel] ?? AppConstants.unspecifiedCode;

  /// Backend code for the chosen sector, or the legacy default when none.
  int get sector =>
      AppConstants.sectorOptions[sectorLabel] ?? AppConstants.unspecifiedCode;

  RaffleSetupState copyWith({String? groupLabel, String? sectorLabel}) {
    return RaffleSetupState(
      groupLabel: groupLabel ?? this.groupLabel,
      sectorLabel: sectorLabel ?? this.sectorLabel,
    );
  }

  @override
  List<Object?> get props => <Object?>[groupLabel, sectorLabel];
}
