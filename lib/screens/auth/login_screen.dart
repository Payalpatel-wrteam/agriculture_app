import 'dart:ui';

import 'package:agriculture_app/helper/constant.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/glassmorphism_container.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../app/routes.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/sign_in_cubit.dart';
import '../../cubits/auth/user_details_cubit.dart';
import '../../helper/colors.dart';
import '../../helper/strings.dart';
import '../../helper/validator.dart';

import '../../helper/widgets.dart';
import '../screen_widgets.dart/app_large_text.dart';
import '../screen_widgets.dart/app_text.dart';
import '../screen_widgets.dart/responsive_button.dart';
import '../screen_widgets.dart/scroll_behavior.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
  static route(Map? map) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignInCubit>(create: (context) => SignInCubit()),
      ],
      child: const LoginScreen(),
    );
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTextController =
      TextEditingController(/* text: 'payalpatel2791@gmail.com' */);
  final TextEditingController _passwordTextController =
      TextEditingController(/* text: '12345678' */);
  final _formKey = GlobalKey<FormState>();
  late Size size;
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay
            .values); //need to reshow status bar if login call from onboarding
    size = MediaQuery.of(context).size;
    // changeStatusBarBrightnesss(darkTheme);
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: GlassmorphismContainer(child: _buildLoginFields(context)),
        ),
      ),
    );
  }

  Widget _buildLoginFields(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Align(
                  alignment: Alignment.topLeft,
                  child: AppLargeText(text: StringRes.signInLbl)),
              defaultSizedBox(),
              _buildEmailAndPassword(),
              defaultSizedBox(),
              _buildFarmerLoginLink(),
              defaultSizedBox(),
              _buildSignUpButton(),
            ]),
          ),
        )));
  }

  Widget _buildEmailAndPassword() {
    return BlocConsumer<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInFailure &&
            state.authProvider == AuthProvider.email) {
          showSnackBar(context, state.errorMessage);
        }
        if (state is SignInSuccess &&
            state.authProvider == AuthProvider.email) {
          if (state.status == '0') {
            showSnackBar(context, StringRes.deactivatedErrorMessage);
            return;
          }
          print('-signin state--$state===');
          // if (state.isNewUser) {
          context
              .read<UserDetailsCubit>()
              .fetchUserDetails(state.userId.toString());
          // }
          context.read<AuthCubit>().authenticateUser(
              userId: state.userId,
              firebaseId: state.user.uid,
              authProvider: state.authProvider);
          redirectToMainScreen(context);
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              buildTextField(
                  controller: _emailTextController,
                  hintText: StringRes.emailHint,
                  textInputAction: TextInputAction.next,
                  validator: Validator.validateEmail),
              defaultSizedBox(),
              buildTextField(
                controller: _passwordTextController,
                hintText: StringRes.passwordHint,
                validator: Validator.emptyValueValidation,
                obscure: _obscureText,
                textInputAction: TextInputAction.done,
                suffixWidget: _buildObscureIcons,
              ),
              defaultSizedBox(),
              Align(
                alignment: Alignment.centerRight,
                child: buildTextButton(
                    AppText(
                        text: StringRes.forgorPassword,
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).secondaryHeaderColor), () {
                  pushNewPage(context, Routes.forgotPassword);
                }),
              ),
              defaultSizedBox(),
              ResponsiveButton(
                radius: 50,
                height: 45,
                width: double.maxFinite,
                onPressed: state is SignInProgress &&
                        state.authProvider == AuthProvider.email
                    ? () {}
                    : () {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          {
                            context.read<SignInCubit>().signInUser(
                                AuthProvider.email,
                                email: _emailTextController.text.trim(),
                                password: _passwordTextController.text.trim());
                          }
                        }
                      },
                child: state is SignInProgress &&
                        state.authProvider == AuthProvider.email
                    ? const CircularProgressIndicator(
                        color: AppColors.whiteColor,
                      )
                    : const AppText(
                        text: StringRes.signInLbl,
                        color: AppColors.whiteColor,
                      ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget get _buildObscureIcons => _obscureText == true
      ? IconButton(
          color: AppColors.whiteShade,
          splashColor: Colors.transparent,
          onPressed: () {
            setState(() {
              _obscureText = false;
            });
          },
          icon: const Icon(Icons.visibility))
      : IconButton(
          color: AppColors.whiteShade,
          splashColor: Colors.transparent,
          onPressed: () {
            setState(() {
              _obscureText = true;
            });
          },
          icon: const Icon(Icons.visibility_off));

  Widget _buildSignUpButton() {
    return Wrap(
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppText(
          text: StringRes.dontHaveAccount,
          color: Theme.of(context).secondaryHeaderColor,
          fontWeight: FontWeight.w300,
        ),
        buildTextButton(
            const AppText(text: StringRes.signUpLbl),
            () => pushNewPage(
                  context,
                  Routes.signup,
                )),
      ],
    );
  }

  _buildFarmerLoginLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: buildTextButton(
          AppText(
            text: StringRes.farmerLogin,
            fontWeight: FontWeight.w300,
            textDecoration: TextDecoration.underline,
            color: Colors.transparent,
            shadows: [
              Shadow(
                  offset: const Offset(0, -5),
                  color: Theme.of(context).secondaryHeaderColor)
            ],
          ), () {
        pushNewPage(context, Routes.otpScreen);
      }),
    );
  }
}
