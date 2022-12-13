import 'package:agriculture_app/data/models/farm_details.dart';
import 'package:agriculture_app/data/repositories/farmer_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AddNewApplicationState {}

class AddNewApplicationInitial extends AddNewApplicationState {}

class AddNewApplicationInProgress extends AddNewApplicationState {}

class AddNewApplicationSuccess extends AddNewApplicationState {
  final FarmDetails farmDetails;
  AddNewApplicationSuccess(this.farmDetails);
}

class AddNewApplicationFailure extends AddNewApplicationState {
  final String errorMessage;
  AddNewApplicationFailure(this.errorMessage);
}

class AddNewApplicationCubit extends Cubit<AddNewApplicationState> {
  FarmerRepository farmerRepository = FarmerRepository();
  AddNewApplicationCubit() : super(AddNewApplicationInitial());

  void addNewApplication({
    required String farmerName,
    required String village,
    required String taluka,
    required String mobile,
    required String allocatedLandArea,
    required String locationOfFarm,
    required String noOfTreesOnRidge,
    required String grownCrops,
    required String plantedCrops,
    required String typeOfSeed,
    required String amountOfSeed,
    required String dateOfPlanting,
    required String dateOfGivenWater,
    required String detailsOfFertilizer,
    required String amountOfCompost,
    required String userId,
  }) {
    emit(AddNewApplicationInProgress());
    farmerRepository
        .addNewApplication(
      farmerName: farmerName,
      village: village,
      taluka: taluka,
      mobile: mobile,
      allocatedLandArea: allocatedLandArea,
      locationOfFarm: locationOfFarm,
      noOfTreesOnRidge: noOfTreesOnRidge,
      grownCrops: grownCrops,
      plantedCrops: plantedCrops,
      typeOfSeed: typeOfSeed,
      amountOfSeed: amountOfSeed,
      dateOfPlanting: dateOfPlanting,
      dateOfGivenWater: dateOfGivenWater,
      detailsOfFertilizer: detailsOfFertilizer,
      amountOfCompost: amountOfCompost,
      userId: userId,
    )
        .then((value) {
      emit(AddNewApplicationSuccess(value));
    }).catchError((e) {
      emit(AddNewApplicationFailure(e.toString()));
    });
  }
}
