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
import 'package:agriculture_app/screens/screen_widgets.dart/app_text.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/responsive_button.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        inputWidget(
          attribute: ApiConstants.locationOfFarmApiKey,
          textEditingController: locationOfFarmTxtController,
          textInputAction: TextInputType.name,
          hint: StringRes.locationOfFarm,
          title: StringRes.locationOfFarm,
        ),
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
}
