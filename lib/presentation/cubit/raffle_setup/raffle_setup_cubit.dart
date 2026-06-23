import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';

part 'raffle_setup_state.dart';

/// Tracks the group/sector dropdown selections on the raffle setup screen.
class RaffleSetupCubit extends Cubit<RaffleSetupState> {
  RaffleSetupCubit() : super(const RaffleSetupState());

  void selectGroup(int? code) => emit(state.copyWith(groupCode: code));

  void selectSector(int? code) => emit(state.copyWith(sectorCode: code));
}
