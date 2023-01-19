import 'package:agriculture_app/data/models/farm_details.dart';
import 'package:agriculture_app/data/repositories/farmer_repository.dart';
import 'package:agriculture_app/helper/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DeleteFarmDetailsState {}

class DeleteFarmDetailsInitial extends DeleteFarmDetailsState {}

class DeleteFarmDetailsInProgress extends DeleteFarmDetailsState {
 
  DeleteFarmDetailsInProgress();
}

class DeleteFarmDetailsSuccess extends DeleteFarmDetailsState {
  final int id;
  final String successMessage;

  DeleteFarmDetailsSuccess({required this.id, required this.successMessage});
}

class DeleteFarmDetailsFailure extends DeleteFarmDetailsState {
  final int id;
  final String errorMessage;
  DeleteFarmDetailsFailure({required this.id, required this.errorMessage});
}

class DeleteFarmDetailsCubit extends Cubit<DeleteFarmDetailsState> {
  FarmerRepository farmerRepository = FarmerRepository();
  DeleteFarmDetailsCubit() : super(DeleteFarmDetailsInitial());

  void deleteFarmDetails(
      {required int id}) {
    print('in delet api==$id');
   
    emit(DeleteFarmDetailsInProgress());
    farmerRepository.deleteFarmDetails(id: id.toString()).then((value) {
      emit(DeleteFarmDetailsSuccess(id: id, successMessage: value));
    }).catchError((e) {
      emit(DeleteFarmDetailsFailure(id: id, errorMessage: e.toString()));
    });
  }

  resetState() {
    emit(DeleteFarmDetailsInitial());
  }
}
