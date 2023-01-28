import 'dart:async';

import 'package:agriculture_app/cubits/farmerApplications/get_farm_details_cubit.dart';

import 'package:agriculture_app/helper/colors.dart';
import 'package:agriculture_app/helper/constant.dart';
import 'package:agriculture_app/helper/design_config.dart';
import 'package:agriculture_app/helper/strings.dart';
import 'package:agriculture_app/main.dart';
import 'package:agriculture_app/screens/home/build_farmer_list.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/app_large_text.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/app_text.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/responsive_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/routes.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/user_details_cubit.dart';
import '../../data/models/disctricts.dart';
import '../../helper/api_constant.dart';
import '../../helper/widgets.dart';
import '../screen_widgets.dart/error_screen.dart';
import 'new_application_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

late Map<String, String> params;

class _HomeScreenState extends State<HomeScreen> {
  Timer? apitimer;
  late Size size;
  bool _isLoading = false;
  GetFarmDetailsSuccess? getBlocState;

  @override
  void initState() {
    super.initState();
    // initializeParameters();
    // getFarmerData();
    getUserData();
    // selectedTaluko = districtList.first.subDistrict!;
    // selectedVillage = districtList.first.villages!.first;
  }

  @override
  void dispose() {
    if (apitimer != null) {
      apitimer!.cancel();
    }
    super.dispose();
  }

  initializeParameters() {
    params = {
      ApiConstants.userIdApiKey: context.read<UserDetailsCubit>().getUserId(),
      ApiConstants.limitAPiKey: Constants.paginationLimit.toString()
    };
  }

  getUserData() {
    Future.delayed(Duration.zero).then((value) {
      if (context.read<AuthCubit>().state is Authenticated) {
        /// in case of api failure, we will call userDetails api in period of some seconds, until we get success
        if (context.read<UserDetailsCubit>().state is UserDetailsFetchFailure) {
          callRetryApi();
          apitimer = Timer.periodic(
              const Duration(seconds: Constants.apiRetryDuration), (Timer t) {
            callRetryApi();
          });
        }
      }
    });
  }

  getFarmerData() {
    context.read<GetFarmDetailsCubit>().getFarmDetails(params: params);
  }

  callRetryApi() {
    context
        .read<UserDetailsCubit>()
        .fetchUserDetails(context.read<AuthCubit>().getUserId());
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    print('==is farmer==${context.read<UserDetailsCubit>().isFarmer()}');
    return Scaffold(
      body: BlocConsumer<UserDetailsCubit, UserDetailsState>(
          listener: (context, state) async {
        print('user state-$state');

        if (state is UserDetailsFetchSuccess) {
          /// stop api call timer when we get success
          if (apitimer != null) {
            apitimer!.cancel();
          }
          initializeParameters();
          getFarmerData();
        }
        if (state is UserDetailsFetchFailure) {
          print(state.errorMessage);
          if (state.errorMessage == StringRes.unauthorizedError) {
            pushNewPage(context, Routes.login, replaceAll: true);
          }
        }
      }, builder: (context, state) {
        if (state is UserDetailsFetchFailure) {
          return ErrorScreen(
            onPressed: () {
              callRetryApi();
              setState(() {
                _isLoading = true;
              });
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  _isLoading = false;
                });
              });
            },
            child: _isLoading ? const CircularProgressIndicator() : null,
          );
        } else if (state is UserDetailsFetchInProgress) {
          return const Center(child: CircularProgressIndicator());
        }

        return _buildHomeScreen();
      }),
    );
  }

  _buildHomeScreen() {
    return Stack(
      children: [
        Container(
          height: context.read<UserDetailsCubit>().isFarmer()
              ? size.height * 0.15
              : size.height * 0.22,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25)),
          ),
        ),
        SafeArea(
            child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: size.height * 0.015,
              ),
              _buildNameRow(),
              SizedBox(
                height: size.height * 0.04,
              ),
              if (!context.read<UserDetailsCubit>().isFarmer())
                GestureDetector(
                  onTap: () => pushNewPage(context, Routes.newApplication),
                  child: Container(
                    height: 80,
                    width: double.maxFinite,
                    alignment: Alignment.centerLeft,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                    decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: borderRadius(10, 10, 10, 10),
                        boxShadow: [appShadow]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppLargeText(
                          text: StringRes.addNewFarmerDetails,
                          size: 20,
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 30,
                          color: Theme.of(context).primaryColor,
                        )
                      ],
                    ),
                  ),
                ),
              // defaultSizedBox(),
              // // _builfFilter(),
              // const AppLargeText(
              //   text: 'Application list',
              //   color: Color(0xFF1e232a),
              //   size: 20,
              // ),
              // smallSizedBox(),
              const Expanded(child: BuildFarmerList())
            ],
          ),
        )),
      ],
    );
  }

  Row _buildNameRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                text: '${StringRes.hello},',
                color: AppColors.whiteColor,
              ),
              smallSizedBox(),
              AppLargeText(
                text: context.read<UserDetailsCubit>().getUserName(),
                color: AppColors.whiteColor,
                size: 22,
              ),
            ],
          ),
        ),
        _buildLogoutButton()
      ],
    );
  }

  IconButton _buildLogoutButton() {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const AppText(
                      text: 'Are you sure you want to logout of the app?',
                      overflow: TextOverflow.visible,
                      color: AppColors.blackColor,
                      lineSpacing: 1.5,
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: AppText(
                          text: StringRes.no,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();

                          context.read<AuthCubit>().signOut();
                        },
                        child: AppText(
                          text: StringRes.yes,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ));
        },
        icon: const Icon(
          Icons.logout,
          color: AppColors.whiteColor,
        ));
  }
}
