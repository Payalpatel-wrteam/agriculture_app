import 'dart:async';

import 'package:agriculture_app/cubits/farmerApplications/get_farm_details_cubit.dart';
import 'package:agriculture_app/cubits/farmerApplications/new_application_cubit.dart';
import 'package:agriculture_app/data/models/disctricts.dart';
import 'package:agriculture_app/data/models/districts_list.dart';
import 'package:agriculture_app/data/models/farm_details.dart';
import 'package:agriculture_app/helper/api_constant.dart';
import 'package:agriculture_app/helper/colors.dart';
import 'package:agriculture_app/helper/constant.dart';
import 'package:agriculture_app/helper/strings.dart';
import 'package:agriculture_app/helper/validator.dart';
import 'package:agriculture_app/helper/widgets.dart';
import 'package:agriculture_app/main.dart';
import 'package:agriculture_app/screens/animated_textformfield.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/app_text.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/responsive_button.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/user_details_cubit.dart';

class NewApplicationScreen extends StatefulWidget {
  final FarmDetails? farmDetails;
  final bool? isEditPage;
  const NewApplicationScreen({Key? key, this.farmDetails, this.isEditPage})
      : super(key: key);

  @override
  _NewApplicationScreenState createState() => _NewApplicationScreenState();
  static route(Map? map) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddNewApplicationCubit>(
            create: (context) => AddNewApplicationCubit()),
      ],
      child: NewApplicationScreen(
        farmDetails: map != null ? map['farmDetails'] : null,
        isEditPage: map != null ? map['isEditPage'] : false,
      ),
    );
  }
}

class _NewApplicationScreenState extends State<NewApplicationScreen> {
  TextEditingController farmnerNameTxtController = TextEditingController();
  TextEditingController villageTxtController = TextEditingController();
  TextEditingController talukaTxtController = TextEditingController();
  TextEditingController mobileTxtController = TextEditingController();
  TextEditingController allocatedLandAreaTxtController =
      TextEditingController();
  TextEditingController locationOfFarmTxtController = TextEditingController();
  TextEditingController noOfTreesOnRidgeTxtController = TextEditingController();
  TextEditingController grownCropsTxtController = TextEditingController();
  TextEditingController plantedCropsTxtController = TextEditingController();
  TextEditingController typeOfSeedTxtController = TextEditingController();
  TextEditingController amountOfSeedTxtController = TextEditingController();
  TextEditingController dateOfPlantingTxtController = TextEditingController();
  TextEditingController amountOfCompostTxtController = TextEditingController();
  TextEditingController dateOfGivenWaterTxtController = TextEditingController();
  TextEditingController detailsOfFertilizerTxtController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _autoValidate = false;
  DateTime? plantingDate, givenWaterDate;
  String defaultSelectedVillage = 'Select Village',
      defaultSelectedDistrict = 'Select District';
  String formattedDate = '', selectedTaluko = '', selectedVillage = '';

  List<Districts> districtList = [];
  List<String> villageList = [];
  String? _currentAddress;
  Position? _currentPosition;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static CameraPosition? _kGooglePlex;
  List<Placemark>? placemarks;
  void initializeControllers() {
    print('is Edit Page==${widget.isEditPage}');
    if (widget.isEditPage == true) {
      farmnerNameTxtController.text = widget.farmDetails!.farmerName!;
      villageTxtController.text = widget.farmDetails!.village!;
      talukaTxtController.text = widget.farmDetails!.taluka!;
      mobileTxtController.text = widget.farmDetails!.mobile!;
      allocatedLandAreaTxtController.text =
          widget.farmDetails!.allocatedLandArea!;
      noOfTreesOnRidgeTxtController.text =
          widget.farmDetails!.noOfTreesOnRidge!;
      grownCropsTxtController.text =
          widget.farmDetails!.cropsGrownInTheSurroundingFarm!;
      locationOfFarmTxtController.text = widget.farmDetails!.locationOfFarm!;
      plantedCropsTxtController.text =
          widget.farmDetails!.theCropPlantedInTheScheme!;
      typeOfSeedTxtController.text = widget.farmDetails!.typeOfSeed!;
      amountOfSeedTxtController.text = widget.farmDetails!.amountOfSeed!;
      dateOfPlantingTxtController.text =
          widget.farmDetails!.dateOrDateOfPlanting!;
      amountOfCompostTxtController.text = widget.farmDetails!.amountOfCompost!;
      dateOfGivenWaterTxtController.text =
          widget.farmDetails!.dateOfGivenWater!;
      detailsOfFertilizerTxtController.text =
          widget.farmDetails!.detailsOfFertilizer!;
    }
  }

  @override
  void initState() {
    super.initState();
    initializeControllers();
    var list = DistrictsList().districts;
    districtList = list.map((model) => Districts.fromJson(model)).toList();
    selectedTaluko = districtList.first.subDistrict!;
    selectedVillage = districtList.first.villages!.first;
    Future.delayed(Duration.zero, () {
      context.read<AddNewApplicationCubit>().resetState();
    });
  }

  @override
  void dispose() {
    changeStatusBarBrightnesss(Constants.lightTheme);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppbar(context, StringRes.addNewFarmerDetails),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Form(
            key: _formKey,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: _buildInputWidgets(context),
          ),
        ),
      ),
    );
  }

  Column _buildInputWidgets(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        inputWidget(
          attribute: ApiConstants.farmerNameApiKey,
          textEditingController: farmnerNameTxtController,
          textInputAction: TextInputType.name,
          hint: StringRes.farmerName,
          title: StringRes.farmerName,
        ),
        // AnimatedTextField(
        //   title: StringRes.allocatedLandArea,
        // ),
        dropwdownWidget(
            hintText: StringRes.taluka,
            text: StringRes.taluka,
            selectedValue: selectedTaluko,
            onChanged: (value) {
              print('change of district==$selectedTaluko');
              setState(() {
                selectedTaluko = value.toString();
                selectedVillage = defaultSelectedVillage;
              });
            },
            items: districtList.map((item) {
              return DropdownMenuItem(
                  value: item.subDistrict, child: Text(item.subDistrict!));
            }).toList()),
        dropwdownWidget(
            hintText: StringRes.village,
            text: StringRes.village,
            selectedValue: selectedVillage,
            onChanged: (value) {
              print('change of village==$selectedVillage');
              setState(() {
                selectedVillage = value.toString();
              });
            },
            items: selectedTaluko.isNotEmpty
                ? districtList
                    .firstWhere(
                        (element) => element.subDistrict == selectedTaluko)
                    .villages!
                    .map((item) {
                    return DropdownMenuItem(value: item, child: Text(item));
                  }).toList()
                : null),
        inputWidget(
            attribute: ApiConstants.mobileApiKey,
            textEditingController: mobileTxtController,
            textInputAction: TextInputType.number,
            hint: StringRes.mobile,
            title: StringRes.mobile,
            isPhoneNumber: true,
            validator: (value) => Validator.validatePhoneNumber(value)),
        inputWidget(
          attribute: ApiConstants.allocatedLandAreaApiKey,
          textEditingController: allocatedLandAreaTxtController,
          textInputAction: TextInputType.number,
          hint: StringRes.allocatedLandArea,
          title: StringRes.allocatedLandArea,
        ),
        GestureDetector(
          onTap: _getCurrentPosition,
          child: inputWidget(
              attribute: ApiConstants.locationOfFarmApiKey,
              textEditingController: locationOfFarmTxtController,
              textInputAction: TextInputType.name,
              hint: StringRes.locationOfFarm,
              title: StringRes.locationOfFarm,
              isReadOnly: true),
        ),
        if (_kGooglePlex != null && _currentPosition != null) _buildGoogleMap(),
        inputWidget(
          attribute: ApiConstants.noOfTreesOnRidgeApiKey,
          textEditingController: noOfTreesOnRidgeTxtController,
          textInputAction: TextInputType.number,
          hint: StringRes.noOfTreesOnRidge,
          title: StringRes.noOfTreesOnRidge,
        ),
        inputWidget(
            attribute: ApiConstants.grownCropsApiKey,
            textEditingController: grownCropsTxtController,
            textInputAction: TextInputType.multiline,
            hint: StringRes.grownCrops,
            title: StringRes.grownCrops,
            maxLines: 5),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: AppText(
            text: StringRes.detailsOfPlantation,
            size: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
            textDecoration: TextDecoration.underline,
          ),
        ),
        inputWidget(
          attribute: ApiConstants.plantedCropsApiKey,
          textEditingController: plantedCropsTxtController,
          textInputAction: TextInputType.name,
          hint: StringRes.plantedCrops,
          title: StringRes.plantedCrops,
        ),
        inputWidget(
          attribute: ApiConstants.typeOfSeedApiKey,
          textEditingController: typeOfSeedTxtController,
          textInputAction: TextInputType.name,
          hint: StringRes.typeOfSeed,
          title: StringRes.typeOfSeed,
        ),
        inputWidget(
          attribute: ApiConstants.amountOfSeedApiKey,
          textEditingController: amountOfSeedTxtController,
          textInputAction: TextInputType.number,
          hint: StringRes.amountOfSeed,
          title: StringRes.amountOfSeed,
        ),
        GestureDetector(
          onTap: () async {
            plantingDate = await openDatePicker(context);

            if (plantingDate != null) {
              formattedDate = DateFormat('dd-MM-yyyy').format(plantingDate!);

              setState(() {
                dateOfPlantingTxtController.text =
                    formattedDate; //set output date to TextField value.
              });
            } else {}
          },
          child: inputWidget(
              attribute: ApiConstants.dateOfPlantingApiKey,
              textEditingController: dateOfPlantingTxtController,
              textInputAction: TextInputType.name,
              hint: StringRes.dateOfPlanting,
              title: StringRes.dateOfPlanting,
              isReadOnly: true),
        ),
        GestureDetector(
          onTap: () async {
            givenWaterDate = await openDatePicker(context);

            if (givenWaterDate != null) {
              formattedDate = DateFormat('dd-MM-yyyy').format(givenWaterDate!);

              setState(() {
                dateOfGivenWaterTxtController.text =
                    formattedDate; //set output date to TextField value.
              });
            } else {}
          },
          child: inputWidget(
              attribute: ApiConstants.dateOfGivenWaterApiKey,
              textEditingController: dateOfGivenWaterTxtController,
              textInputAction: TextInputType.name,
              hint: StringRes.dateOfGivenWater,
              title: StringRes.dateOfGivenWater,
              isReadOnly: true),
        ),
        inputWidget(
            attribute: ApiConstants.detailsOfFertilizerApiKey,
            textEditingController: detailsOfFertilizerTxtController,
            textInputAction: TextInputType.multiline,
            hint: StringRes.detailsOfFertilizer,
            title: StringRes.detailsOfFertilizer,
            maxLines: 5),
        inputWidget(
          attribute: ApiConstants.amountOfCompostApiKey,
          textEditingController: amountOfCompostTxtController,
          textInputAction: TextInputType.number,
          hint: StringRes.amountOfCompost,
          title: StringRes.amountOfCompost,
        ),
        defaultSizedBox(),
        _buildSubmitButton(context)
      ],
    );
  }

  _buildSubmitButton(BuildContext context) {
    return BlocConsumer<AddNewApplicationCubit, AddNewApplicationState>(
      listener: (context, state) {
        print('add new detail state--$state');
        if (state is AddNewApplicationFailure) {
          showSnackBar(_scaffoldKey.currentContext!, state.errorMessage);
        }
        if (state is AddNewApplicationSuccess) {
          if (context.read<GetFarmDetailsCubit>().state
              is GetFarmDetailsSuccess) {
            List<FarmDetails> farmDetails = (context
                    .read<GetFarmDetailsCubit>()
                    .state as GetFarmDetailsSuccess)
                .farmDetails;
            final index = farmDetails
                .indexWhere((element) => element.id == state.farmDetails.id);
            if (index != -1) {
              farmDetails[index] = state.farmDetails;
            } else {
              farmDetails.insert(0, state.farmDetails);
            }
            context.read<GetFarmDetailsCubit>().emitSuccessState(
                farmDetails: farmDetails,
                totalData: (context.read<GetFarmDetailsCubit>().state
                        as GetFarmDetailsSuccess)
                    .totalData,
                hasMore: (context.read<GetFarmDetailsCubit>().state
                        as GetFarmDetailsSuccess)
                    .hasMore);
          }
          showSnackBar(_scaffoldKey.currentContext!, state.successMessage);
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is AddNewApplicationInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ResponsiveButton(
            child: const AppText(
              text: StringRes.submitLbl,
              color: AppColors.whiteColor,
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              if (context.read<AuthCubit>().state is Authenticated) {
                if (state is AddNewApplicationInProgress) {
                  return;
                } else {
                  if (_validateInput()) {
                    Map<String, dynamic> map = {
                      ApiConstants.userIdApiKey:
                          context.read<UserDetailsCubit>().getUserId(),
                      ApiConstants.farmerNameApiKey:
                          farmnerNameTxtController.text.trim(),
                      ApiConstants.villageApiKey: selectedVillage,
                      ApiConstants.talukaApiKey: selectedTaluko,
                      ApiConstants.mobileApiKey:
                          mobileTxtController.text.trim(),
                      ApiConstants.allocatedLandAreaApiKey:
                          allocatedLandAreaTxtController.text.trim(),
                      ApiConstants.locationOfFarmApiKey:
                          locationOfFarmTxtController.text.trim(),
                      ApiConstants.noOfTreesOnRidgeApiKey:
                          noOfTreesOnRidgeTxtController.text.trim(),
                      ApiConstants.grownCropsApiKey:
                          grownCropsTxtController.text.trim(),
                      ApiConstants.plantedCropsApiKey:
                          plantedCropsTxtController.text.trim(),
                      ApiConstants.typeOfSeedApiKey:
                          typeOfSeedTxtController.text.trim(),
                      ApiConstants.amountOfSeedApiKey:
                          amountOfSeedTxtController.text.trim(),
                      ApiConstants.dateOfPlantingApiKey:
                          dateOfPlantingTxtController.text.trim(),
                      ApiConstants.dateOfGivenWaterApiKey:
                          dateOfGivenWaterTxtController.text.trim(),
                      ApiConstants.detailsOfFertilizerApiKey:
                          detailsOfFertilizerTxtController.text.trim(),
                      ApiConstants.amountOfCompostApiKey:
                          amountOfCompostTxtController.text.trim(),
                    };

                    if (widget.isEditPage == true) {
                      map[Constants.id] = widget.farmDetails!.id.toString();
                    }
                    print('--map--$map');

                    context.read<AddNewApplicationCubit>().addNewApplication(
                        farmDetails: map,
                        isEditPage: widget.isEditPage ?? false);
                  }
                }
              } else {
                showSnackBar(context, StringRes.pleaseLogin);
              }
            });
      },
    );
  }

  bool _validateInput() {
    if (_formKey.currentState!.validate()) {
      // If all data are correct then save data to out variables
      _formKey.currentState!.save();
      setState(() {});
      return true;
    } else {
      // If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
      return false;
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled && mounted) {
      showSnackBar(context,
          'Location services are disabled. Please enable the services');

      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied && mounted) {
        showSnackBar(context, 'Location permissions are denied');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever && mounted) {
      showSnackBar(context,
          'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    print('has permission--$hasPermission');
    if (!hasPermission) return;
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        print('position--$position');
        _kGooglePlex = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 17.4746,
        );
        _getAddressFromLatLng(position);
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  _buildGoogleMap() {
    return SizedBox(
      width: double.maxFinite,
      height: 200,
      child: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex!,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        locationOfFarmTxtController.text =
            '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
