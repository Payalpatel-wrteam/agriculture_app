import 'package:agriculture_app/helper/api_constant.dart';

class FarmDetails {
  String? farmerName;
  String? village;
  String? taluka;
  String? mobile;
  String? allocatedLandArea;
  String? locationOfFarm;
  String? noOfTreesOnRidge;
  String? cropsGrownInTheSurroundingFarm;
  String? theCropPlantedInTheScheme;
  String? typeOfSeed;
  String? amountOfSeed;
  String? dateOrDateOfPlanting;
  String? dateOfGivenWater;
  String? detailsOfFertilizer;
  String? amountOfCompost;
  String? updatedAt;
  String? createdAt;
  int? id;

  FarmDetails(
      {farmerName,
      village,
      taluka,
      mobile,
      allocatedLandArea,
      locationOfFarm,
      noOfTreesOnRidge,
      cropsGrownInTheSurroundingFarm,
      theCropPlantedInTheScheme,
      typeOfSeed,
      amountOfSeed,
      dateOrDateOfPlanting,
      dateOfGivenWater,
      detailsOfFertilizer,
      amountOfCompost,
      updatedAt,
      createdAt,
      id});

  FarmDetails.fromJson(Map<String, dynamic> json) {
    farmerName = json[ApiConstants.farmerNameApiKey];
    village = json[ApiConstants.villageApiKey];
    taluka = json[ApiConstants.talukaApiKey];
    mobile = json[ApiConstants.mobileApiKey];
    allocatedLandArea = json[ApiConstants.allocatedLandAreaApiKey];
    locationOfFarm = json[ApiConstants.locationOfFarmApiKey];
    noOfTreesOnRidge = json[ApiConstants.noOfTreesOnRidgeApiKey];
    cropsGrownInTheSurroundingFarm = json[ApiConstants.grownCropsApiKey];
    theCropPlantedInTheScheme = json[ApiConstants.plantedCropsApiKey];
    typeOfSeed = json[ApiConstants.typeOfSeedApiKey];
    amountOfSeed = json[ApiConstants.amountOfSeedApiKey];
    dateOrDateOfPlanting = json[ApiConstants.dateOfPlantingApiKey];
    dateOfGivenWater = json[ApiConstants.dateOfGivenWaterApiKey];
    detailsOfFertilizer = json[ApiConstants.detailsOfFertilizerApiKey];
    amountOfCompost = json[ApiConstants.amountOfCompostApiKey];
    updatedAt = json[ApiConstants.updatedAtApiKey] ?? '';
    createdAt = json[ApiConstants.createdAtApiKey] ?? '';
    id = json[ApiConstants.idAPiKey];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['farmer_name'] = farmerName;
    data['village'] = village;
    data['taluka'] = taluka;
    data['mobile'] = mobile;
    data['allocated_land_area'] = allocatedLandArea;
    data['location_of_farm'] = locationOfFarm;
    data['no_of_trees_on_ridge'] = noOfTreesOnRidge;
    data['crops_grown_in_the_surrounding_farm'] =
        cropsGrownInTheSurroundingFarm;
    data['the_crop_planted_in_the_scheme'] = theCropPlantedInTheScheme;
    data['type_of_seed'] = typeOfSeed;
    data['amount_of_seed'] = amountOfSeed;
    data['date_or_date_of_planting'] = dateOrDateOfPlanting;
    data['date_of_given_water'] = dateOfGivenWater;
    data['details_of_fertilizer'] = detailsOfFertilizer;
    data['amount_of_compost'] = amountOfCompost;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
