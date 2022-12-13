import 'dart:async';

import 'package:agriculture_app/cubits/farmerApplications/get_farm_details_cubit.dart';
import 'package:agriculture_app/helper/colors.dart';
import 'package:agriculture_app/helper/constant.dart';
import 'package:agriculture_app/helper/strings.dart';
import 'package:agriculture_app/main.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/app_text.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/responsive_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/routes.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/user_details_cubit.dart';
import '../../helper/widgets.dart';
import '../screen_widgets.dart/error_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? apitimer;
  late Size size;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    if (apitimer != null) {
      apitimer!.cancel();
    }

    super.dispose();
  }

  getData() {
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

  callRetryApi() {
    print('**retry api');

    context
        .read<UserDetailsCubit>()
        .fetchUserDetails(context.read<AuthCubit>().getUserId());
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppbar(context, Constants.appName, actions: [
        IconButton(
            onPressed: () => context.read<AuthCubit>().signOut(),
            icon: const Icon(Icons.exit_to_app))
      ]),
      body: BlocConsumer<UserDetailsCubit, UserDetailsState>(
          listener: (context, state) async {
        print('user state-$state');

        /// if the user is deactivated from backend, then we got its status value 0 ,. in that case redirect him to login screen,
        /// Note: for guest user, the status is 0, so we have to put condition for authenticated also
        if (state is UserDetailsFetchSuccess) {
          // if (state.userProfile.status == '0' &&
          //     context.read<AuthCubit>().state is Authenticated) {
          //   showSnackBar(context, StringRes.deactivatedErrorMessage);
          //   pushNewPage(context, Routes.login, null, replaceAll: true);
          // }

          /// stop api call timer when we get success
          if (apitimer != null) {
            apitimer!.cancel();
          }
        }
        if (state is UserDetailsFetchFailure) {
          showSnackBar(context, state.errorMessage);
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        children: <Widget>[
          _addNewApplication(),
          Expanded(child: _buildFarmDetailList())
        ],
      ),
    );
  }

  _addNewApplication() {
    return ResponsiveButton(
        child: const AppText(
          text: StringRes.addNewFarmerDetails,
          color: AppColors.whiteColor,
        ),
        onPressed: () => pushNewPage(context, Routes.newApplication));
  }

  _buildFarmDetailList() {
    return BlocConsumer<GetFarmDetailsCubit, GetFarmDetailsState>(
      listener: (context, state) {
        print('get farm list state==$state');
      },
      builder: (context, state) {
        if (state is GetFarmDetailsSuccess) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: farmDetails.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () => pushNewPage(context, Routes.newApplication,
                    params: {
                      'farmDetails': farmDetails[index],
                      'isEditPage': true
                    }),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: AppColors.backColor),
                ),
                tileColor: AppColors.greyColor.withOpacity(0.5),
                title: AppText(
                  text:
                      '${StringRes.farmerName} : ${farmDetails[index].farmerName!}',
                  textAlign: TextAlign.left,
                ),
                subtitle: AppText(
                  text: '${StringRes.village} : ${farmDetails[index].village!}',
                  textAlign: TextAlign.left,
                ),
              );
            },
          );
        }
        if (state is GetFarmDetailsInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
