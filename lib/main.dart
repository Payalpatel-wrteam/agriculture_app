import 'package:agriculture_app/cubits/farmerApplications/get_farm_details_cubit.dart';
import 'package:agriculture_app/helper/constant.dart';
import 'package:agriculture_app/screens/main_screen.dart';
import 'package:agriculture_app/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/routes.dart';
import 'cubits/auth/auth_cubit.dart';
import 'cubits/auth/user_details_cubit.dart';
import 'data/models/farm_details.dart';
import 'helper/network_api.dart';
import 'helper/session.dart';

late FirebaseAuth firebaseAuth;
late SharedPreferences pref;
late Session session;
ApiBaseHelper apiBaseHelper = ApiBaseHelper();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  firebaseAuth = FirebaseAuth.instance;
  pref = await SharedPreferences.getInstance();
  session = Session(pref);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<UserDetailsCubit>(create: (_) => UserDetailsCubit()),
        BlocProvider<GetFarmDetailsCubit>(create: (_) => GetFarmDetailsCubit()),
      ],
      child: MaterialApp(
        title: Constants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: Routes.onGenerateRouted,
      ),
    );
  }
}
