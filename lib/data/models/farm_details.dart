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
    farmerName = json['farmer_name'];
    village = json['village'];
    taluka = json['taluka'];
    mobile = json['mobile'];
    allocatedLandArea = json['allocated_land_area'];
    locationOfFarm = json['location_of_farm'];
    noOfTreesOnRidge = json['no_of_trees_on_ridge'];
    cropsGrownInTheSurroundingFarm =
        json['crops_grown_in_the_surrounding_farm'];
    theCropPlantedInTheScheme = json['the_crop_planted_in_the_scheme'];
    typeOfSeed = json['type_of_seed'];
    amountOfSeed = json['amount_of_seed'];
    dateOrDateOfPlanting = json['date_or_date_of_planting'];
    dateOfGivenWater = json['date_of_given_water'];
    detailsOfFertilizer = json['details_of_fertilizer'];
    amountOfCompost = json['amount_of_compost'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
