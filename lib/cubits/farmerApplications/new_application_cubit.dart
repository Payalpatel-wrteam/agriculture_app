import 'package:agriculture_app/data/models/farm_details.dart';
import 'package:agriculture_app/data/repositories/farmer_repository.dart';
import 'package:agriculture_app/helper/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AddNewApplicationState {}

class AddNewApplicationInitial extends AddNewApplicationState {}

class AddNewApplicationInProgress extends AddNewApplicationState {}

class AddNewApplicationSuccess extends AddNewApplicationState {
  final FarmDetails farmDetails;
  final String successMessage;
  AddNewApplicationSuccess(this.farmDetails, this.successMessage);
}

class AddNewApplicationFailure extends AddNewApplicationState {
  final String errorMessage;
  AddNewApplicationFailure(this.errorMessage);
}

class AddNewApplicationCubit extends Cubit<AddNewApplicationState> {
  FarmerRepository farmerRepository = FarmerRepository();
  AddNewApplicationCubit() : super(AddNewApplicationInitial());

  void addNewApplication({
    required Map<String, dynamic> farmDetails,
    required bool isEditPage,
    required Map<String, String> filepath,
  }) {
    emit(AddNewApplicationInProgress());
    farmerRepository
        .addNewApplication(
            farmDetails: farmDetails, isEditPage: isEditPage, files: filepath)
        .then((value) {
      emit(AddNewApplicationSuccess(
          value[Constants.data], value[Constants.message]));
    }).catchError((e) {
      emit(AddNewApplicationFailure(e.toString()));
    });
  }

  resetState() {
    emit(AddNewApplicationInitial());
  }
}
