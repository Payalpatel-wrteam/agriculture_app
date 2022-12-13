import 'package:agriculture_app/cubits/farmerApplications/new_application_cubit.dart';
import 'package:agriculture_app/helper/strings.dart';
import 'package:agriculture_app/helper/validator.dart';
import 'package:agriculture_app/helper/widgets.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/app_text.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/responsive_button.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/user_details_cubit.dart';

class NewApplicationScreen extends StatefulWidget {
  const NewApplicationScreen({Key? key}) : super(key: key);

  @override
  _NewApplicationScreenState createState() => _NewApplicationScreenState();
  static route() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddNewApplicationCubit>(
            create: (context) => AddNewApplicationCubit()),
      ],
      child: const NewApplicationScreen(),
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
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(context, StringRes.addNewFarmerDetails),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                inputWidget(
                  textEditingController: farmnerNameTxtController,
                  textInputAction: TextInputType.name,
                  hint: StringRes.farmerName,
                  title: StringRes.farmerName,
                ),
                inputWidget(
                  textEditingController: villageTxtController,
                  textInputAction: TextInputType.name,
                  hint: StringRes.village,
                  title: StringRes.village,
                ),
                inputWidget(
                  textEditingController: talukaTxtController,
                  textInputAction: TextInputType.name,
                  hint: StringRes.taluka,
                  title: StringRes.taluka,
                ),
                inputWidget(
                    textEditingController: mobileTxtController,
                    textInputAction: TextInputType.number,
                    hint: StringRes.mobile,
                    title: StringRes.mobile,
                    validator: (value) => Validator.validatePhoneNumber(value)),
                inputWidget(
                  textEditingController: allocatedLandAreaTxtController,
                  textInputAction: TextInputType.number,
                  hint: StringRes.allocatedLandArea,
                  title: StringRes.allocatedLandArea,
                ),
                inputWidget(
                  textEditingController: locationOfFarmTxtController,
                  textInputAction: TextInputType.name,
                  hint: StringRes.locationOfFarm,
                  title: StringRes.locationOfFarm,
                ),
                inputWidget(
                  textEditingController: noOfTreesOnRidgeTxtController,
                  textInputAction: TextInputType.number,
                  hint: StringRes.noOfTreesOnRidge,
                  title: StringRes.noOfTreesOnRidge,
                ),
                inputWidget(
                  textEditingController: grownCropsTxtController,
                  textInputAction: TextInputType.name,
                  hint: StringRes.grownCrops,
                  title: StringRes.grownCrops,
                ),
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
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2100));

                    if (pickedDate != null) {
                      print(
                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                      print(
                          formattedDate); //formatted date output using intl package =>  2021-03-16
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
                defaultSizedBox(),
                _buildSubmitButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildSubmitButton() {
    return BlocConsumer<AddNewApplicationCubit, AddNewApplicationState>(
      listener: (context, state) {
        if (state is AddNewApplicationFailure) {
          showSnackBar(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is AddNewApplicationInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ResponsiveButton(
            child: const AppText(text: StringRes.submitLbl),
            onPressed: () {
              if (context.read<AuthCubit>().state is Authenticated) {
                if (state is AddNewApplicationInProgress) {
                  return;
                } else {
                  if (_formKey.currentState!.validate()) {
                    {
                      // context.read<AddNewApplicationCubit>().addNewApplication(
                      //     userId: context.read<UserDetailsCubit>().getUserId(),
                      //     farmerName: farmnerNameTxtController.text.trim(),
                      //     mobile: mobileTxtController.text.trim(),
                      //     1);
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
}
