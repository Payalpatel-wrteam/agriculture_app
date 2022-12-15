import 'dart:async';

import 'package:agriculture_app/cubits/farmerApplications/delete_farm_details_cubit.dart';
import 'package:agriculture_app/cubits/farmerApplications/get_farm_details_cubit.dart';
import 'package:agriculture_app/data/models/farm_details.dart';
import 'package:agriculture_app/helper/api_constant.dart';
import 'package:agriculture_app/helper/colors.dart';
import 'package:agriculture_app/helper/constant.dart';
import 'package:agriculture_app/helper/design_config.dart';
import 'package:agriculture_app/helper/strings.dart';
import 'package:agriculture_app/main.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/app_text.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/responsive_button.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/retry_button.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/scroll_behavior.dart';
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
  GetFarmDetailsSuccess? getBlocState;
  late ScrollController _scrollController;
  int _offset = 0;
  // There is next page or not
  bool _hasNextPage = true;
  late Map<String, dynamic> param;
  List<FarmDetails> farmDetails = [];

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_loadMore);
    param = {
      ApiConstants.userIdApiKey: context.read<UserDetailsCubit>().getUserId(),
      ApiConstants.limitAPiKey: Constants.paginationLimit.toString()
    };
    getUserData();
  }

  @override
  void dispose() {
    if (apitimer != null) {
      apitimer!.cancel();
    }
    _scrollController.removeListener(_loadMore);
    super.dispose();
  }

// This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void _loadMore() async {
    if (_hasNextPage == true &&
        _isLoadMoreRunning == false &&
        _scrollController.position.pixels <
            _scrollController.position.maxScrollExtent) {
      _offset += Constants.paginationLimit; // Increase _page by 1

      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });

      try {
        param[ApiConstants.offsetAPiKey] = _offset.toString();

        var response = await apiBaseHelper.postAPICall(
            param: param, apiMethodUrl: ApiConstants.getFarmDetailsApiKey);

        if (!response[Constants.error]) {
          var list = response[Constants.data] as List<dynamic>;
          final fetchedData =
              list.map((model) => FarmDetails.fromJson(model)).toList();

          if (fetchedData.isNotEmpty) {
            setState(() {
              farmDetails.addAll(fetchedData);
            });
          }
          if (farmDetails.length == response[Constants.total]) {
            setState(() {
              _hasNextPage = false;
            });
          }
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        // print('Something went wrong!');
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
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
    context
        .read<GetFarmDetailsCubit>()
        .getFarmDetails(userId: context.read<UserDetailsCubit>().getUserId());
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
          getFarmerData();
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
          _buildNewApplicationButton(),
          Expanded(child: _buildFarmDetailList())
        ],
      ),
    );
  }

  _buildNewApplicationButton() {
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
        if (state is GetFarmDetailsSuccess) {
          farmDetails = state.farmDetails;
        }
      },
      builder: (context, state) {
        if (state is GetFarmDetailsSuccess) {
          getBlocState = context.read<GetFarmDetailsCubit>().state
              as GetFarmDetailsSuccess;
          return RefreshIndicator(
            onRefresh: () async {
              getFarmerData();
            },
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            child: BlocListener<DeleteFarmDetailsCubit, DeleteFarmDetailsState>(
              listener: (context, state) {
                print('delete state==$state');
                if (state is DeleteFarmDetailsSuccess) {
                  showSnackBar(context, state.successMessage);
                  getBlocState!.farmDetails
                      .removeWhere((element) => element.id == state.id);
                  context.read<GetFarmDetailsCubit>().emitSuccessState(
                      farmDetails: getBlocState!.farmDetails,
                      totalData: getBlocState!.totalData,
                      hasMore: getBlocState!.hasMore);
                }

                if (state is DeleteFarmDetailsFailure) {
                  getBlocState!.farmDetails
                      .firstWhere((element) => element.id == state.id)
                      .deleteInProgress = false;
                  showSnackBar(context, state.errorMessage);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(child: _buildListView(state)),
                  if (_isLoadMoreRunning == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 40),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          );
        }
        if (state is GetFarmDetailsInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GetFarmDetailsFailure) {
          print('get detail error==${state.errorMessage}');
          _offset = 0;
          return RetryButton(onPressed: getFarmerData);
        } else {
          return Container();
        }
      },
    );
  }

  ScrollConfiguration _buildListView(GetFarmDetailsSuccess state) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: farmDetails.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _buildListTile(farmDetails, index);
        },
      ),
    );
  }

  Widget _buildListTile(List<FarmDetails> farmDetails, int index) {
    return ListTile(
      onTap: () => pushNewPage(context, Routes.newApplication,
          params: {'farmDetails': farmDetails[index], 'isEditPage': true}),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: AppColors.backColor),
      ),
      tileColor: AppColors.whiteColor,
      title: AppText(
        text: '${StringRes.farmerName} : ${farmDetails[index].farmerName!}',
        textAlign: TextAlign.left,
      ),
      subtitle: AppText(
        text: '${StringRes.village} : ${farmDetails[index].village!}',
        textAlign: TextAlign.left,
      ),
      trailing: _buildDeleteIcon(farmDetails, index),
    );
  }

  BlocBuilder<DeleteFarmDetailsCubit, DeleteFarmDetailsState> _buildDeleteIcon(
      List<FarmDetails> farmDetails, int index) {
    return BlocBuilder<DeleteFarmDetailsCubit, DeleteFarmDetailsState>(
      builder: (context, state) {
        if (state is DeleteFarmDetailsInProgress &&
            state.farmDetails
                    .firstWhere(
                        (element) => element.id == farmDetails[index].id)
                    .deleteInProgress ==
                true) {
          return const CircularProgressIndicator();
        }
        return IconButton(
            onPressed: () {
              context.read<DeleteFarmDetailsCubit>().deleteFarmDetails(
                  id: farmDetails[index].id!, farmDetails: farmDetails);
            },
            icon: const Icon(
              Icons.delete,
              color: AppColors.redColor,
            ));
      },
    );
  }
}
