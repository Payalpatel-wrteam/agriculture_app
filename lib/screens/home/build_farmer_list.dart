import 'package:agriculture_app/cubits/farmerApplications/delete_farm_details_cubit.dart';
import 'package:agriculture_app/cubits/farmerApplications/get_farm_details_cubit.dart';
import 'package:agriculture_app/data/models/farm_details.dart';
import 'package:agriculture_app/helper/api_constant.dart';
import 'package:agriculture_app/helper/colors.dart';
import 'package:agriculture_app/helper/constant.dart';
import 'package:agriculture_app/helper/design_config.dart';
import 'package:agriculture_app/helper/strings.dart';
import 'package:agriculture_app/main.dart';
import 'package:agriculture_app/screens/home/home_screen.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/app_text.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/retry_button.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/routes.dart';
import '../../cubits/auth/user_details_cubit.dart';
import '../../helper/widgets.dart';
import '../screen_widgets.dart/app_large_text.dart';

class BuildFarmerList extends StatefulWidget {
  const BuildFarmerList({Key? key}) : super(key: key);

  @override
  _BuildFarmerListState createState() => _BuildFarmerListState();
}

class _BuildFarmerListState extends State<BuildFarmerList> {
  late Size size;
  GetFarmDetailsSuccess? getBlocState;
  late ScrollController _scrollController;
  int _offset = 0;
  // There is next page or not
  bool _hasNextPage = true;
  late Map<String, dynamic> param;
  List<FarmDetails> farmDetails = [];
  String selectedTaluko = '', selectedVillage = '';
  List<String> villageList = [];
  List<Map<String, List<String>>> filteredTalukaList = [];

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
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMore);
    super.dispose();
  }

// This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void _loadMore() async {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.offset) {
      if (_hasNextPage == true &&
          (context.read<GetFarmDetailsCubit>().state as GetFarmDetailsSuccess)
              .hasMore &&
          _isLoadMoreRunning == false) {
        _offset += Constants.paginationLimit; // Increase _page by 1

        setState(() {
          _isLoadMoreRunning =
              true; // Display a progress indicator at the bottom
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
  }

  getFarmerData() {
    context.read<GetFarmDetailsCubit>().getFarmDetails(params: params);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    print('=filter list ===$filteredTalukaList');
    return BlocConsumer<GetFarmDetailsCubit, GetFarmDetailsState>(
      listener: (context, state) {
        if (state is GetFarmDetailsSuccess) {
          filteredTalukaList = state.talukaAndVillages;
          farmDetails = state.farmDetails;
          print('==list===$filteredTalukaList');
        }
        if (state is GetFarmDetailsFailure) {
          showSnackBar(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        print('get build state==$state');
        if (state is GetFarmDetailsSuccess) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              defaultSizedBox(),
              if (!context.read<UserDetailsCubit>().isFarmer()) _builfFilter(),
              const AppLargeText(
                text: 'Application list',
                color: Color(0xFF1e232a),
                size: 20,
              ),
              smallSizedBox(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    getFarmerData();
                    _hasNextPage = true;
                    _offset = 0;
                    _isLoadMoreRunning = false;
                  },
                  triggerMode: RefreshIndicatorTriggerMode.anywhere,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(child: _buildListView(state)),
                      if (_isLoadMoreRunning == true)
                        const Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
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
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
          height: 15,
        ),
        physics: const AlwaysScrollableScrollPhysics(),
        // clipBehavior: Clip.none,
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
    return GestureDetector(
      onTap: () => pushNewPage(context, Routes.newApplication, params: {
        'farmDetails': farmDetails[index],
        'isEditPage': true,
      }),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10), /* \: [appShadow] */
        ),
        padding: const EdgeInsets.only(right: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 5,
              height: 80,
              decoration: BoxDecoration(
                  color:
                      AppColors.tileColors[index % AppColors.tileColors.length],
                  borderRadius: borderRadius(8, 0, 8, 0)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      text:
                          '${StringRes.farmerName} : ${farmDetails[index].farmerName!}',
                      textAlign: TextAlign.left,
                      color: const Color(0xFF1a242f),
                      overflow: TextOverflow.visible,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppText(
                      text:
                          '${StringRes.village} : ${farmDetails[index].village!}',
                      textAlign: TextAlign.left,
                      color: AppColors.captionColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _builfFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const AppText(text: '${StringRes.filterBy}:'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SizedBox(
                width: size.width * 0.3,
                child: dropwdownWidget(
                  hintText: StringRes.taluka,
                  text: '',
                  selectedValue: selectedTaluko,
                  onChanged: (value) {
                    setState(() {
                      selectedTaluko = value.toString();
                      selectedVillage = '';
                      print(
                          '****${filteredTalukaList.firstWhere((element) => element.containsKey(selectedTaluko)).values.first}');
                      villageList = filteredTalukaList
                          .firstWhere(
                              (element) => element.containsKey(selectedTaluko))
                          .values
                          .first;
                    });
                    print('change of district==$selectedTaluko==$villageList');
                  },
                  items: (filteredTalukaList.map((e) => e.keys).toList())
                      .map<DropdownMenuItem<String>>(
                        (e) => DropdownMenuItem(
                          value: e.first,
                          child: Text(e.first),
                          alignment: Alignment.center,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: SizedBox(
                width: size.width * 0.3,
                child: dropwdownWidget(
                  hintText: StringRes.village,
                  text: '',
                  selectedValue: selectedVillage,
                  onChanged: (value) {
                    setState(() {
                      selectedVillage = value.toString();
                    });

                    print('change of village==$selectedVillage');
                  },
                  items: selectedTaluko.isNotEmpty
                      ? villageList
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList()
                      : null,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTextButton(
                    const AppText(
                        text: 'Filter',
                        textDecoration: TextDecoration.underline), () {
                  params.remove(ApiConstants.talukaApiKey);
                  params.remove(ApiConstants.villageApiKey);
                  if (selectedTaluko != '') {
                    params.addAll({ApiConstants.talukaApiKey: selectedTaluko});
                  }
                  if (selectedVillage != '') {
                    params
                        .addAll({ApiConstants.villageApiKey: selectedVillage});
                  }
                  getFarmerData();
                }),
                defaultSizedBox(),
                buildTextButton(
                    const AppText(
                        text: 'All',
                        textDecoration: TextDecoration.underline), () {
                  params.remove(ApiConstants.talukaApiKey);
                  params.remove(ApiConstants.villageApiKey);
                  selectedTaluko = '';
                  selectedVillage = '';
                  setState(() {});
                  getFarmerData();
                }),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
