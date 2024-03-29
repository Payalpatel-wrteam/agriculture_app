import 'package:agriculture_app/helper/widgets.dart';
import 'package:agriculture_app/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/routes.dart';
import '../cubits/auth/auth_cubit.dart';

import '../data/models/disctricts.dart';
import '../data/models/districts_list.dart';
import '../helper/strings.dart';
import 'home/new_application_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
  static route() {
    return const MainScreen();
  }
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    var list = DistrictsList().districts;
    districtList = list.map((model) => Districts.fromJson(model)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return navigateBack(context, StringRes.extAppMessage, exitApp: true);
      },
      child: Scaffold(body: _buildBody()),
    );
  }

  BlocConsumer<AuthCubit, AuthState> _buildBody() {
    return BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
      if (state is Unauthenticated) {
        /// neeed to change main screen's cubit to initial state, so that guest user cant access users data
        // resetAllStates();
        pushNewPage(context, Routes.login, replaceAll: true);
      }
    }, builder: (context, state) {
      return const HomeScreen();
    });
  }
}
