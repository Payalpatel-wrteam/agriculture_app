import 'package:agriculture_app/screens/auth/forgot_password_screen.dart';
import 'package:agriculture_app/screens/auth/login_screen.dart';
import 'package:agriculture_app/screens/auth/signup_screen.dart';
import 'package:agriculture_app/screens/home/new_application_screen.dart';
import 'package:agriculture_app/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';

class Routes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const main = '/main';
  static const home = '/home';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot_password';
  static const newApplication = '/new_application';
  static String currentRoute = splash;
  static Route<dynamic> onGenerateRouted(RouteSettings settings) {
    final Map? map = settings.arguments as Map?;
    currentRoute = settings.name ?? "";
    return CupertinoPageRoute<dynamic>(
        settings: settings,
        builder: (BuildContext context) {
          switch (settings.name) {
            case Routes.splash:
              return const SplashScreen();

            case Routes.login:
              return LoginScreen.route(map);

            case Routes.signup:
              return SignupScreen.route(map);

            case Routes.forgotPassword:
              return const ForgotPasswordScreen();

            case Routes.main:
              return MainScreen.route();

            case Routes.newApplication:
              return NewApplicationScreen.route(map);

            default:
              return const SplashScreen();
          }
        });
  }
}
