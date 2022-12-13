import 'package:agriculture_app/data/models/farm_details.dart';
import 'package:agriculture_app/data/repositories/farmer_repository.dart';
import 'package:agriculture_app/helper/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class GetFarmDetailsState {}

class GetFarmDetailsInitial extends GetFarmDetailsState {}

class GetFarmDetailsInProgress extends GetFarmDetailsState {}

class GetFarmDetailsSuccess extends GetFarmDetailsState {
  final List<FarmDetails> farmDetails;

  GetFarmDetailsSuccess(this.farmDetails);
}

class GetFarmDetailsFailure extends GetFarmDetailsState {
  final String errorMessage;
  GetFarmDetailsFailure(this.errorMessage);
}

class GetFarmDetailsCubit extends Cubit<GetFarmDetailsState> {
  FarmerRepository farmerRepository = FarmerRepository();
  GetFarmDetailsCubit() : super(GetFarmDetailsInitial());

  void getFarmDetails({
    required String userId,
  }) {
    emit(GetFarmDetailsInProgress());
    farmerRepository.getFarmDetails(userId: userId).then((value) {
      emit(GetFarmDetailsSuccess(value));
    }).catchError((e) {
      emit(GetFarmDetailsFailure(e.toString()));
    });
  }

  resetState() {
    emit(GetFarmDetailsInitial());
  }

  emitSuccessState(List<FarmDetails> farmDetails) {
    emit(GetFarmDetailsSuccess(farmDetails));
  }
}
