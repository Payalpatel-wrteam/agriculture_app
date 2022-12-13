import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/routes.dart';
import '../cubits/auth/auth_cubit.dart';
import '../cubits/auth/user_details_cubit.dart';
import '../helper/constant.dart';
import '../helper/widgets.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values); // to re-show bars
    super.dispose();
  }

  startTimer() async {
    var duration = const Duration(seconds: 1);
    return Timer(duration, () {
      ///for web app, we open main screen even if user is not logged in as a guest user

      // if (session.getBoolData(Constants.showIntroSliderSessionKey) ?? true) {
      //   pushNewPage(context, Routes.onboarding, null, replacePrevious: true);
      // } else {
      print('user api called');
      if (context.read<AuthCubit>().state is Authenticated) {
        context
            .read<UserDetailsCubit>()
            .fetchUserDetails(context.read<AuthCubit>().getUserId());
        pushNewPage(context, Routes.main, replaceAll: true);
      } else {
        pushNewPage(context, Routes.login, replaceAll: true);
      }
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }
}
