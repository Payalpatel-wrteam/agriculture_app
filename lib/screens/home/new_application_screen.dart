import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
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

List<Districts> districtList = [];

class _NewApplicationScreenState extends State<NewApplicationScreen> {
  TextEditingController farmnerNameTxtController = TextEditingController();
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
  TextEditingController villageTextController = TextEditingController();

  final List<TextEditingController> dateOfGivenWaterTxtController = [];
  final List<TextEditingController> nameOfFetrtilizerController = [];
  final List<TextEditingController> quanityOfFetrtilizerController = [];
  int numberOfTextFields = 1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _autoValidate = false;
  DateTime? plantingDate, givenWaterDate;
  String defaultSelectedVillage = 'Select Village',
      defaultSelectedDistrict = 'Select District';
  String formattedDate = '', selectedTaluko = '', selectedVillage = '';

  List<String> villageList = [];
  String? _currentAddress;
  double? _currentLatitude;
  double? _currentLongitude;
  Position? _currentPosition;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static CameraPosition? _kGooglePlex;
  List<Placemark>? placemarks;
  bool _isLaoding = true;
  FertilizerDetail? fertilizerDetail;
  final picker = ImagePicker();
  File? selectedImage;
  String profileUrl = '';
  @override
  void initState() {
    super.initState();
    _kGooglePlex = null;
    selectedImage = null;
    if (widget.isEditPage == false) createControllers();

    selectedTaluko = districtList.first.subDistrict!;
    villageList = districtList
        .firstWhere((element) => element.subDistrict == selectedTaluko)
        .villages!
        .toList();
    // selectedVillage = districtList.first.villages!.first;
    Future.delayed(Duration.zero, () {
      context.read<AddNewApplicationCubit>().resetState();
    });
    initializeControllers();
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
    super.dispose();
  }

  createControllers() {
    for (var i = 0; i < numberOfTextFields; i++) {
      dateOfGivenWaterTxtController.add(TextEditingController());
      nameOfFetrtilizerController.add(TextEditingController());
      quanityOfFetrtilizerController.add(TextEditingController());
    }
  }

  void initializeControllers() {
    print('is Edit Page==${widget.isEditPage}');
    if (widget.isEditPage == true) {
      print('farm details==${widget.farmDetails!.toJson()}');
      print(
          'fertilizer controller lengh==${widget.farmDetails!.detailsOfFertilizer!.length}');
      farmnerNameTxtController.text = widget.farmDetails!.farmerName!;
      profileUrl = widget.farmDetails!.image ?? '';
      selectedVillage = widget.farmDetails!.village!;
      villageTextController.text = widget.farmDetails!.village!;
      selectedTaluko = widget.farmDetails!.taluka!;
      mobileTxtController.text = widget.farmDetails!.mobile!;
      allocatedLandAreaTxtController.text =
          widget.farmDetails!.allocatedLandArea!;
      noOfTreesOnRidgeTxtController.text =
          widget.farmDetails!.noOfTreesOnRidge!;
      grownCropsTxtController.text =
          widget.farmDetails!.cropsGrownInTheSurroundingFarm!;

      plantedCropsTxtController.text =
          widget.farmDetails!.theCropPlantedInTheScheme!;
      typeOfSeedTxtController.text = widget.farmDetails!.typeOfSeed!;
      amountOfSeedTxtController.text = widget.farmDetails!.amountOfSeed!;
      dateOfPlantingTxtController.text =
          widget.farmDetails!.dateOrDateOfPlanting!;
      amountOfCompostTxtController.text = widget.farmDetails!.amountOfCompost!;

      Map position = jsonDecode(widget.farmDetails!.locationOfFarm!);
      _currentLatitude = position[ApiConstants.latitudeApiKey];
      _currentLongitude = position[ApiConstants.longitudeApiKey];
      _kGooglePlex = CameraPosition(
        target: LatLng(_currentLatitude!, _currentLongitude!),
        zoom: 17.4746,
      );
      _getAddressFromLatLng(_currentLatitude!, _currentLongitude!);
      numberOfTextFields = widget.farmDetails!.detailsOfFertilizer!.length;
      if (numberOfTextFields == 0) {
        numberOfTextFields = 1;
        createControllers();
      } else {
        for (var i = 0;
            i < widget.farmDetails!.detailsOfFertilizer!.length;
            i++) {
          fertilizerDetail = widget.farmDetails!.detailsOfFertilizer![i];
          print(
              '${fertilizerDetail!.date}==${fertilizerDetail!.name}==${fertilizerDetail!.quantity}');
          dateOfGivenWaterTxtController
              .add(TextEditingController(text: fertilizerDetail!.date));
          nameOfFetrtilizerController
              .add(TextEditingController(text: fertilizerDetail!.name));
          quanityOfFetrtilizerController
              .add(TextEditingController(text: fertilizerDetail!.quantity));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('profile==$profileUrl==$selectedImage');
    // for (int i = 0; i < districtList.length; i++) {
    //   print('${districtList[i].villages}==${districtList[i].villages}');
    // }
    return WillPopScope(
      onWillPop: () async {
        if (context.read<AddNewApplicationCubit>().state
            is AddNewApplicationInProgress) {
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
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
      ),
    );
  }

  Column _buildInputWidgets(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        uploadFarmerProfile(),
        const SizedBox(
          height: 30,
        ),

        inputWidget(
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
              setState(() {
                selectedTaluko = value.toString();
                // selectedVillage = defaultSelectedVillage;
                villageList = districtList
                    .firstWhere(
                        (element) => element.subDistrict == selectedTaluko)
                    .villages!
                    .toList();
                villageTextController.clear();
              });
              print('change of district==$selectedTaluko');
            },
            items: districtList.map((item) {
              return DropdownMenuItem(
                  value: item.subDistrict, child: Text(item.subDistrict!));
            }).toList()),
        inputWidget(
            textEditingController: villageTextController,
            textInputAction: TextInputType.text,
            hint: StringRes.village,
            title: StringRes.village,
            onTap: () {
              villageList.clear();

              print("controller:${villageTextController.text.toString()}");
              setState(
                () {},
              );
            },
            onChanged: searchVillage),
        villageList.isNotEmpty ? villageNameList() : const SizedBox(),

        inputWidget(
            textEditingController: mobileTxtController,
            textInputAction: TextInputType.number,
            hint: StringRes.mobile,
            title: StringRes.mobile,
            isPhoneNumber: true,
            validator: (value) => Validator.validatePhoneNumber(value)),
        inputWidget(
          textEditingController: allocatedLandAreaTxtController,
          textInputAction: TextInputType.number,
          hint: StringRes.allocatedLandArea,
          title: StringRes.allocatedLandArea,
        ),
        GestureDetector(
          onTap: _getCurrentPosition,
          child: inputWidget(
              textEditingController: locationOfFarmTxtController,
              textInputAction: TextInputType.name,
              hint: StringRes.locationOfFarm,
              title: StringRes.locationOfFarm,
              isReadOnly: true),
        ),
        if (_kGooglePlex != null) _buildGoogleMap(),
        inputWidget(
          textEditingController: noOfTreesOnRidgeTxtController,
          textInputAction: TextInputType.number,
          hint: StringRes.noOfTreesOnRidge,
          title: StringRes.noOfTreesOnRidge,
        ),
        inputWidget(
            textEditingController: grownCropsTxtController,
            textInputAction: TextInputType.multiline,
            hint: StringRes.grownCrops,
            title: StringRes.grownCrops,
            maxLines: 5),
        _buildSectionHeader(StringRes.detailsOfPlantation),
        inputWidget(
          textEditingController: plantedCropsTxtController,
          textInputAction: TextInputType.name,
          hint: StringRes.plantedCrops,
          title: StringRes.plantedCrops,
        ),
        inputWidget(
          textEditingController: typeOfSeedTxtController,
          textInputAction: TextInputType.name,
          hint: StringRes.typeOfSeed,
          title: StringRes.typeOfSeed,
        ),
        inputWidget(
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
              textEditingController: dateOfPlantingTxtController,
              textInputAction: TextInputType.name,
              hint: StringRes.dateOfPlanting,
              title: StringRes.dateOfPlanting,
              isReadOnly: true),
        ),

        inputWidget(
          textEditingController: amountOfCompostTxtController,
          textInputAction: TextInputType.number,
          hint: StringRes.amountOfCompost,
          title: StringRes.amountOfCompost,
        ),
        _buildSectionHeader(StringRes.waterAndFertilizerDetails),
        _buildWaterDetailHeaders(),
        for (int i = 0; i < numberOfTextFields; i++) _buildGivenWaterDetails(i),
        smallSizedBox(),
        _buildAddMore(),
        defaultSizedBox(),
        _buildSubmitButton(context)
      ],
    );
  }

  Row _buildWaterDetailHeaders() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Expanded(
            child: AppText(
          text: StringRes.dateOfGivenWater,
        )),
        SizedBox(
          width: 5,
        ),
        Expanded(
            child: AppText(
          text: StringRes.nameOfFertilizer,
        )),
        SizedBox(
          width: 5,
        ),
        Expanded(
            child: AppText(
          text: StringRes.quantityOfFertilizer,
        ))
      ],
    );
  }

  Padding _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: AppText(
        text: title,
        size: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.blackColor,
        textDecoration: TextDecoration.underline,
        overflow: TextOverflow.visible,
      ),
    );
  }

  _buildSubmitButton(BuildContext context) {
    return BlocConsumer<AddNewApplicationCubit, AddNewApplicationState>(
      listener: (context, state) {
        if (state is AddNewApplicationFailure) {
          print('add new detail state--${state.errorMessage}');
          showSnackBar(_scaffoldKey.currentContext!, state.errorMessage);
        }
        if (state is AddNewApplicationSuccess) {
          List<FarmDetails> farmDetails = [];
          int totalData = 0;
          bool hasMore = false;
          GetFarmDetailsCubit getCubit = context.read<GetFarmDetailsCubit>();
          if (getCubit.state is GetFarmDetailsSuccess) {
            farmDetails = (getCubit.state as GetFarmDetailsSuccess).farmDetails;
            totalData = (getCubit.state as GetFarmDetailsSuccess).totalData;
            hasMore = (getCubit.state as GetFarmDetailsSuccess).hasMore;
          }
          final index = farmDetails
              .indexWhere((element) => element.id == state.farmDetails.id);
          if (index != -1) {
            farmDetails[index] = state.farmDetails;
          } else {
            farmDetails.insert(0, state.farmDetails);
            totalData = totalData + 1;
            hasMore = totalData > farmDetails.length;
          }
          print('farm details==$farmDetails==$totalData==$hasMore');
          getCubit.emitSuccessState(
              farmDetails: farmDetails, totalData: totalData, hasMore: hasMore);

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
              Map<String, dynamic> map = {};
              FocusScope.of(context).unfocus();
              if (context.read<AuthCubit>().state is Authenticated) {
                if (state is AddNewApplicationInProgress) {
                  return;
                } else {
                  final List<Map<String, dynamic>> waterDetailsMap = [];

                  if (_validateInput()) {
                    Map<String, String> apifilelist = {};
                    print('selected==$selectedImage');
                    if (selectedVillage.isEmpty) {
                      showSnackBar(context, 'Please select village from list');
                    } else {
                      if (selectedImage != null) {
                        apifilelist[ApiConstants.imageApiKey] =
                            selectedImage!.path;
                      }
                      map = {
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
                        ApiConstants.locationOfFarmApiKey: jsonEncode({
                          ApiConstants.latitudeApiKey: _currentLatitude,
                          ApiConstants.longitudeApiKey: _currentLongitude
                        }),
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
                        ApiConstants.amountOfCompostApiKey:
                            amountOfCompostTxtController.text.trim(),
                      };
                      for (int i = 0; i < numberOfTextFields; i++) {
                        String key =
                            '${ApiConstants.fertilizerDetailsApiKey}${[i]}';
                        if (dateOfGivenWaterTxtController[i].text.isNotEmpty ||
                            nameOfFetrtilizerController[i].text.isNotEmpty ||
                            quanityOfFetrtilizerController[i].text.isNotEmpty) {
                          if (widget.isEditPage! &&
                              i <
                                  widget.farmDetails!.detailsOfFertilizer!
                                      .length) {
                            map['$key${[ApiConstants.idAPiKey]}'] = widget
                                .farmDetails!.detailsOfFertilizer![i].id
                                .toString();
                          }
                          map['$key${[ApiConstants.dateOfAddWaterApiKey]}'] =
                              dateOfGivenWaterTxtController[i].text.trim();

                          map['$key${[ApiConstants.nameAPiKey]}'] =
                              nameOfFetrtilizerController[i].text.trim();
                          map['$key${[ApiConstants.quantityApiKey]}'] =
                              quanityOfFetrtilizerController[i].text.trim();
                        }
                      }

                      if (widget.isEditPage == true) {
                        map[Constants.id] = widget.farmDetails!.id.toString();
                      }
                      print('--map--$map');

                      context.read<AddNewApplicationCubit>().addNewApplication(
                          farmDetails: map,
                          isEditPage: widget.isEditPage ?? false,
                          filepath: apifilelist);
                    }
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
    print('check null ==${_formKey.currentState == null}');
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
      showSnackBar(context, 'Please fill up required fields.');
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
    fullScreenProgress(context);
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        print('position--$position');
        _kGooglePlex = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 17.4746,
        );
        _currentLatitude = position.latitude;
        _currentLongitude = position.longitude;
        _getAddressFromLatLng(position.latitude, position.longitude);
      });
      dismissProgressDialog(context);
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

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    await placemarkFromCoordinates(latitude, longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        locationOfFarmTxtController.text =
            '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      locationOfFarmTxtController.text = '$latitude $longitude';
    });
  }

  _buildGivenWaterDetails(int i) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(child: _buildWaterDateField(i)),
        const SizedBox(
          width: 5,
        ),
        Expanded(child: _buildNameOfFertilizerField(i)),
        const SizedBox(
          width: 5,
        ),
        Expanded(child: _buildquantityOfFertilizerField(i))
      ],
    );
  }

  _buildWaterDateField(int index) {
    return GestureDetector(
      onTap: () async {
        givenWaterDate = await openDatePicker(context);

        if (givenWaterDate != null) {
          formattedDate = DateFormat('dd-MM-yyyy').format(givenWaterDate!);

          setState(() {
            dateOfGivenWaterTxtController[index].text =
                formattedDate; //set output date to TextField value.
          });
        } else {}
      },
      child: inputWidget(
          textEditingController: dateOfGivenWaterTxtController[index],
          textInputAction: TextInputType.name,
          hint: StringRes.dateOfGivenWater,
          title: '',
          isReadOnly: true,
          useValidator: false,
          contentPadiing: 5),
    );
  }

  _buildNameOfFertilizerField(int index) {
    return inputWidget(
        textEditingController: nameOfFetrtilizerController[index],
        textInputAction: TextInputType.name,
        hint: StringRes.nameOfFertilizer,
        title: '',
        maxLines: 2,
        useValidator: false,
        contentPadiing: 5);
  }

  _buildquantityOfFertilizerField(int index) {
    return inputWidget(
        textEditingController: quanityOfFetrtilizerController[index],
        textInputAction: TextInputType.number,
        hint: StringRes.quantityOfFertilizer,
        title: '',
        useValidator: false,
        contentPadiing: 5);
  }

  Widget _buildAddMore() => ElevatedButton(
        onPressed: () {
          setState(() {
            numberOfTextFields++;
            createControllers();
          });
        },
        child: const Text('Add new detail'),
      );

  uploadFarmerProfile() {
    return Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: Stack(
          children: [
            ClipOval(child: buildProfilePicture()),
            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: _showSelectionDialog,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(width: 2, color: AppColors.whiteColor)),
                  child: const CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(0xFFbebec7),
                    child: Icon(
                      Icons.mode_edit_outline_outlined,
                      size: 15,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

// Selection dialog that prompts the user to select an existing photo or take a new one
  Future _showSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text(StringRes.selectPhoto),
        children: <Widget>[
          SimpleDialogOption(
            child: const Text(StringRes.fromGallery),
            onPressed: () {
              selectOrTakePhoto(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
          SimpleDialogOption(
            child: const Text(StringRes.takePhoto),
            onPressed: () {
              selectOrTakePhoto(ImageSource.camera);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  /// Method for sending a selected or taken photo to the EditPage
  Future selectOrTakePhoto(ImageSource imageSource) async {
    XFile? pickedFile;
    try {
      pickedFile = await picker.pickImage(
        source: imageSource,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    if (pickedFile != null) {
      File? file = File(pickedFile.path);
      setState(() {
        selectedImage = File(file.path);
      });
    } else {
      showSnackBar(context, StringRes.noPhotoSelected);
    }
  }

  buildProfilePicture() {
    return Container(
      height: 90,
      width: 90,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      child: Container(
        height: 85,
        width: 85,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.whiteColor,
            image: profileUrl != '' || selectedImage != null
                ? DecorationImage(
                    image: selectedImage != null
                        ? FileImage(selectedImage!) as ImageProvider
                        : NetworkImage(profileUrl),
                    fit: BoxFit.cover)
                : null),
        child: profileUrl == '' && selectedImage == null
            ? Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
                size: 50,
              )
            : null,
      ),
    );
  }

  villageNameList() {
    return Container(
      // width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppColors.whiteColor,
        border: Border.all(color: AppColors.blackColor),
      ),
      height: 250,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsetsDirectional.only(
                  bottom: 5, start: 10, end: 10),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: villageList.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        selectedVillage = villageList[index];

                        villageTextController.text = selectedVillage;
                        villageList.clear();
                        setState(
                          () {},
                        );
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.60,
                        child: Text(
                          villageList[index],
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    ); //,Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children:List.generate(categoryList.length, (index) => Text(categoryList[index].name.toString())));
  }

  List<String> temp = [];
  void searchVillage(String query) {
    print('search village calle');
    print('==villages==${villageList.length}== $query');
    if (query.isEmpty) {
      temp = districtList
          .firstWhere((element) => element.subDistrict == selectedTaluko)
          .villages!
          .toList();
    } else {
      temp = districtList
          .firstWhere((element) => element.subDistrict == selectedTaluko)
          .villages!
          .where((village) {
        final nameLower = village.toString().toLowerCase();

        final searchLower = query.toLowerCase();

        return nameLower.contains(searchLower);
      }).toList();
    }
    print('==temp==${temp.length}==$temp');
    setState(() {
      query = query;
      villageList = temp;
    });
  }
}
