import 'package:agriculture_app/helper/api_constant.dart';
import 'package:agriculture_app/helper/colors.dart';
import 'package:agriculture_app/helper/constant.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/glassmorphism_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/routes.dart';
import '../../cubits/auth/auth_cubit.dart';

import '../../cubits/auth/sign_up_cubit.dart';
import '../../cubits/auth/user_details_cubit.dart';
import '../../helper/strings.dart';
import '../../helper/validator.dart';
import '../../helper/widgets.dart';
import '../screen_widgets.dart/app_large_text.dart';
import '../screen_widgets.dart/app_text.dart';
import '../screen_widgets.dart/responsive_button.dart';
import '../screen_widgets.dart/scroll_behavior.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
  static route(Map? map) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignUpCubit>(create: (context) => SignUpCubit()),
      ],
      child: const SignupScreen(),
    );
  }
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _cnfPasswordTextController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  late Size size;
  bool _obscureText = true;
  bool _cnObscureText = true;
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    // changeStatusBarBrightnesss(darkTheme);
    return WillPopScope(
      onWillPop: () {
        FocusScope.of(context).unfocus();
        return Future.value(true);
      },
      child: Scaffold(
        body: _buildSignupFields(context),
      ),
    );
  }

  Widget _buildSignupFields(BuildContext context) {
    return ScrollConfiguration(
        behavior: MyBehavior(),
        child: GlassmorphismContainer(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    // buildSkip(context, () {
                    //   context.read<AuthCubit>().checkIsAuthenticated();
                    //   context.read<UserDetailsCubit>().resetUserDetailsState();
                    //   redirectToMainScreen(context);
                    // }),
                    // defaultSizedBox(),
                    const Align(
                        alignment: Alignment.topLeft,
                        child: AppLargeText(text: StringRes.signUpLbl)),
                    defaultSizedBox(),
                    buildTextField(
                        controller: _nameTextController,
                        hintText: StringRes.nameHint,
                        focusNode: _nameNode,
                        textInputAction: TextInputAction.next,
                        validator: Validator.validateName,
                        onFieldSubmitted: (value) {
                          _nameNode.unfocus();
                          FocusScope.of(context).requestFocus(_phoneNode);
                        }),
                    const SizedBox(height: 10),

                    buildTextField(
                        controller: _emailTextController,
                        hintText: StringRes.emailHint,
                        textInputAction: TextInputAction.next,
                        validator: Validator.validateEmail),
                    const SizedBox(height: 10),
                    buildTextField(
                      controller: _passwordTextController,
                      hintText: StringRes.passwordHint,
                      textInputAction: TextInputAction.done,
                      validator: Validator.validatePassword,
                      obscure: _obscureText,
                      suffixWidget: _buildObscureIcons,
                    ),
                    const SizedBox(height: 10),
                    buildTextField(
                      controller: _cnfPasswordTextController,
                      hintText: StringRes.confirmPasswordHint,
                      obscure: _cnObscureText,
                      suffixWidget: _buildCnfObscureIcons,
                      validator: (value) {
                        if (value != _passwordTextController.text) {
                          return StringRes.passwordMismatchMessage;
                        } else {
                          return null;
                        }
                      },
                    ),
                    defaultSizedBox(),
                    _buildSignupButton(),

                    // _buildAggreemetStatement(),
                    const SizedBox(height: 10),
                    _buildAlreadyHaveAccountStatement()
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget get _buildObscureIcons => _obscureText == true
      ? _buildVisibleIcon(() {
          setState(() {
            _obscureText = false;
          });
        })
      : _buildInVisibleIcon(() {
          setState(() {
            _obscureText = true;
          });
        });

  Widget get _buildCnfObscureIcons => _cnObscureText == true
      ? _buildVisibleIcon(() {
          setState(() {
            _cnObscureText = false;
          });
        })
      : _buildInVisibleIcon(() {
          setState(() {
            _cnObscureText = true;
          });
        });

  IconButton _buildInVisibleIcon(VoidCallback onTap) {
    return IconButton(
        splashColor: Colors.transparent,
        color: AppColors.whiteShade,
        onPressed: onTap,
        icon: const Icon(Icons.visibility_off));
  }

  IconButton _buildVisibleIcon(VoidCallback onTap) {
    return IconButton(
        splashColor: Colors.transparent,
        color: AppColors.whiteShade,
        onPressed: onTap,
        icon: const Icon(Icons.visibility));
  }

  Widget _buildSignupButton() {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          showSnackBar(context, StringRes.emailVerificationErrorMessage);
          pushNewPage(context, Routes.login, replacePrevious: true);
        }
        if (state is SignUpFailure) {
          showSnackBar(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return ResponsiveButton(
          height: 45,
          radius: 50,
          width: double.maxFinite,
          onPressed: state is SignUpProgress
              ? () {}
              : () {
                  if (_formKey.currentState!.validate()) {
                    {
                      if (_isChecked) {
                        context.read<SignUpCubit>().signUpUser(
                            AuthProvider.email,
                            _nameTextController.text.trim(),
                            _emailTextController.text.trim(),
                            _passwordTextController.text.trim());
                      } else {
                        showSnackBar(context, StringRes.acceptPolicy);
                      }
                    }
                  }
                },
          child: state is SignUpProgress
              ? const CircularProgressIndicator(
                  color: AppColors.whiteColor,
                )
              : const AppText(
                  text: StringRes.signUpLbl,
                  color: AppColors.whiteColor,
                ),
        );
      },
    );
  }

  Widget _buildAggreemetStatement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Wrap(
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Checkbox(
                value: _isChecked,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (newValue) {
                  setState(() {
                    _isChecked = newValue!;
                  });
                }),
            AppText(
              text: StringRes.policyAggreementStatement,
              color: Theme.of(context).secondaryHeaderColor,
              size: 14,
              overflow: TextOverflow.fade,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => pushNewPage(context, Routes.appDetails, params: {
                Constants.title: StringRes.privacyPolicy,
                Constants.type: ApiConstants.privacyPolicyAppApitype
              }),
              child: const AppText(
                text: StringRes.privacyPolicy,
                size: 14,
                textDecoration: TextDecoration.underline,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: AppText(text: '&'),
            ),
            GestureDetector(
              onTap: () => pushNewPage(context, Routes.appDetails, params: {
                Constants.title: StringRes.termsConditions,
                Constants.type: ApiConstants.termsAppApitype
              }),
              child: const AppText(
                text: StringRes.terms,
                size: 14,
                textDecoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlreadyHaveAccountStatement() {
    return Wrap(
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppText(
          text: StringRes.alreadyHaveAccount,
          color: Theme.of(context).secondaryHeaderColor,
          fontWeight: FontWeight.w300,
        ),
        buildTextButton(
            const AppText(
              text: StringRes.signInLbl,
              fontWeight: FontWeight.w500,
            ), () {
          FocusScope.of(context).unfocus();
          Navigator.of(context).pop();
        })
      ],
    );
  }
}
