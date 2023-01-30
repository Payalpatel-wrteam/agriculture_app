import 'package:agriculture_app/helper/api_constant.dart';

class FarmDetails {
  String? farmerName;
  String? image;
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
  List<FertilizerDetail>? detailsOfFertilizer;
  String? amountOfCompost;
  String? updatedAt;
  String? createdAt;
  bool? deleteInProgress;
  int? id;

  FarmDetails(
      {farmerName,
      image,
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
      detailsOfFertilizer,
      amountOfCompost,
      updatedAt,
      createdAt,
      deleteInProgress,
      id});

  FarmDetails.fromJson(Map<String, dynamic> json) {
    print('from json');
    farmerName = json[ApiConstants.farmerNameApiKey];
    image = json[ApiConstants.imageApiKey] ?? '';
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

    amountOfCompost = json[ApiConstants.amountOfCompostApiKey];
    updatedAt = json[ApiConstants.updatedAtApiKey] ?? '';
    createdAt = json[ApiConstants.createdAtApiKey] ?? '';
    id = json[ApiConstants.idAPiKey];
    deleteInProgress = false;
    print(
        'before fer json==${json[ApiConstants.fertilizerDetailsApiKey].runtimeType}');
    if (json[ApiConstants.fertilizerDetailsApiKey] != null) {
      detailsOfFertilizer = <FertilizerDetail>[];
      json[ApiConstants.fertilizerDetailsApiKey].forEach((v) {
        detailsOfFertilizer!.add(FertilizerDetail.fromJson(v));
      });
    }
    print('end json');
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
    data['details_of_fertilizer'] = detailsOfFertilizer;
    data['amount_of_compost'] = amountOfCompost;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}

class FertilizerDetail {
  int? id;
  String? name;
  String? date;
  String? quantity;

  FertilizerDetail({
    this.id,
    this.name,
    this.date,
    this.quantity,
  });

  FertilizerDetail.fromJson(Map<String, dynamic> json) {
    print('fom1');
    id = json[ApiConstants.idAPiKey];
    name = json[ApiConstants.nameAPiKey];
    date = json[ApiConstants.dateOfAddWaterApiKey];
    quantity = json[ApiConstants.quantityApiKey];
    print('fom3');
  }
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = Map<String, dynamic>();
  //   data['id'] = id;
  //   data['s_id'] = sId;
  //   data['image'] = image;
  //   data['title'] = title;
  //   data['des'] = des;
  //   return data;
  // }
}
