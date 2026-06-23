part of 'raffle_setup_cubit.dart';

class RaffleSetupState extends Equatable {
  const RaffleSetupState({this.groupCode, this.sectorCode});

  final int? groupCode;
  final int? sectorCode;

  /// Backend code for the chosen group, or the legacy default when none.
  int get group => groupCode ?? AppConstants.unspecifiedCode;

  /// Backend code for the chosen sector, or the legacy default when none.
  int get sector => sectorCode ?? AppConstants.unspecifiedCode;

  RaffleSetupState copyWith({int? groupCode, int? sectorCode}) {
    return RaffleSetupState(
      groupCode: groupCode ?? this.groupCode,
      sectorCode: sectorCode ?? this.sectorCode,
    );
  }

  @override
  List<Object?> get props => <Object?>[groupCode, sectorCode];
}
