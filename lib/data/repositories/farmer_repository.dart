import '../../helper/api_constant.dart';
import '../../helper/constant.dart';
import '../../helper/strings.dart';
import '../../main.dart';
import '../../screens/screen_widgets.dart/custom_exception.dart';

class FarmerRepository {
  addNewApplication({
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
  }) async {
    Map<String, String> parameter = {
      ApiConstants.farmerNameApiKey: farmerName,
      ApiConstants.villageApiKey: village,
      ApiConstants.talukaApiKey: taluka,
      ApiConstants.mobileApiKey: mobile,
      ApiConstants.allocatedLandAreaApiKey: allocatedLandArea,
      ApiConstants.locationOfFarmApiKey: locationOfFarm,
      ApiConstants.noOfTreesOnRidgeApiKey: noOfTreesOnRidge,
      ApiConstants.grownCropsApiKey: grownCrops,
      ApiConstants.plantedCropsApiKey: plantedCrops,
      ApiConstants.typeOfSeedApiKey: typeOfSeed,
      ApiConstants.amountOfSeedApiKey: amountOfSeed,
      ApiConstants.dateOfPlantingApiKey: dateOfPlanting,
      ApiConstants.dateOfGivenWaterApiKey: dateOfGivenWater,
      ApiConstants.detailsOfFertilizerApiKey: detailsOfFertilizer,
      ApiConstants.amountOfCompostApiKey: amountOfCompost,
      ApiConstants.userIdApiKey: userId,
    };
    var getdata = await apiBaseHelper.postAPICall(
        param: parameter, apiMethodUrl: ApiConstants.addFarmDetailsApiKey);
    if (getdata != null) {
      bool error = getdata[Constants.error];

      if (!error) {
        return getdata[Constants.data];
      } else {
        throw CustomException(getdata[Constants.message]);
      }
    } else {
      throw CustomException(StringRes.defaultErrorMessage);
    }
  }
}
