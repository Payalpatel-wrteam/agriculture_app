import 'package:agriculture_app/cubits/auth/auth_cubit.dart';
import 'package:agriculture_app/helper/constant.dart';
import 'package:agriculture_app/helper/strings.dart';
import 'package:agriculture_app/screens/auth/resendOtpTimerContainer.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/glassmorphism_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/routes.dart';
import '../../cubits/auth/sign_in_cubit.dart';
import '../../cubits/auth/sign_up_cubit.dart';
import '../../cubits/auth/user_details_cubit.dart';
import '../../helper/colors.dart';
import '../../helper/validator.dart';
import '../../helper/widgets.dart';
import '../screen_widgets.dart/app_large_text.dart';
import '../screen_widgets.dart/app_text.dart';
import '../screen_widgets.dart/responsive_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
  static route(Map? map) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignInCubit>(create: (context) => SignInCubit()),
      ],
      child: const OtpScreen(),
    );
  }
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool codeSent = false;
  bool hasError = false;
  String errorMessage = "";
  bool isLoading = false;
  String userVerificationId = "";

  TextEditingController phoneNumberController = TextEditingController();
  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];

  final GlobalKey<ResendOtpTimerContainerState> resendOtpTimerContainerKey =
      GlobalKey<ResendOtpTimerContainerState>();
  final TextEditingController smsCodeEditingController =
      TextEditingController();

  bool enableResendOtpButton = false;
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      controllers.add(controller);
      focusNodes.add(focusNode);
    }
  }

// Focus nodes need to be disposed.
  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }

    for (final fNode in focusNodes) {
      fNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          if (isLoading) {
            print("Is loading is true");
            return Future.value(false);
          }
          if (context.read<SignInCubit>().state is SignInProgress) {
            return Future.value(false);
          }

          return Future.value(true);
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: _buildAppBar(),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: GlassmorphismContainer(
              child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppLargeText(
                    text: 'Phone Authentication',
                    maxLines: 2,
                    textAlign: TextAlign.left,
                  ),
                  defaultSizedBox(),
                  _buildOTPSentToPhoneNumber(),
                  const SizedBox(
                    height: 40,
                  ),
                  codeSent
                      ? _buildSmsCodeContainer()
                      : _buildMobileNumberWithCountryCode(),
                  const SizedBox(
                    height: 40,
                  ),
                  codeSent
                      ? _buildSubmitOtpContainer()
                      : _buildRequestOtpContainer(),
                  defaultSizedBox(),
                  codeSent ? _buildResendText() : Container(),
                ],
              ),
            ),
          )),
        ));
  }

  _buildAppBar() {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.whiteShade,
            ),
            onPressed: () => Navigator.of(context).pop()));
  }

  Widget _buildOTPSentToPhoneNumber() {
    if (codeSent) {
      return Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            //
            const Text(
              'OTP has been sent to',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors
                    .whiteColor, // Theme.of(context).secondaryHeaderColor,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              '${Constants.countryCode}${phoneNumberController.text.trim()}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors
                    .whiteColor, //Theme.of(context).secondaryHeaderColor,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      );
    }
    return AppText(
      text: 'Please use phone number which is used in form application',
      color: AppColors.captionColor,
      fontWeight: FontWeight.w300,
      textAlign: TextAlign.left,
      overflow: TextOverflow.visible,
      lineSpacing: 1.7,
    );
  }

  _buildMobileNumberWithCountryCode() {
    return buildTextField(
      controller: phoneNumberController,
      hintText: 'Enter Phone Number',
      textInputAction: TextInputAction.next,
      prefixText: Constants.countryCode,
      validator: Validator.validatePhoneNumber,
      textInputType: TextInputType.number,
    );
  }

  _buildSmsCodeContainer() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(6, (index) => createTextField(index)));
  }

  Widget createTextField(int index) {
    final textStyle = TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    );
    return Container(
        width: 40,
        height: 45,
        margin: const EdgeInsets.only(right: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x29000000),
                  offset: Offset(0, 0),
                  blurRadius: 10,
                  spreadRadius: 0)
            ],
            color: Theme.of(context).secondaryHeaderColor),
        child: TextFormField(
          controller: controllers[index],
          focusNode: focusNodes[index],
          maxLength: 1,
          textInputAction: TextInputAction.done,
          style: textStyle,
          keyboardType: TextInputType.number,
          autofocus: index == 0 ? true : false,
          textAlign: TextAlign.center,
          cursorColor: Theme.of(context).primaryColor,
          decoration: InputDecoration(
              counterText: '',
              contentPadding: const EdgeInsets.only(bottom: 5),
              border: InputBorder.none,
              hintText: null,
              hintStyle: textStyle),
          onChanged: (val) {
            focusNodes[index].unfocus();
            if (val.isNotEmpty && index < 5) {
              FocusScope.of(context).requestFocus(focusNodes[index + 1]);
            }
            if (val == '' && index > 0) {
              FocusScope.of(context).requestFocus(focusNodes[index - 1]);
            }
          },
        ));
  }

  _buildRequestOtpContainer() {
    return ResponsiveButton(
      height: 45,
      radius: 50,
      width: double.maxFinite,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          {
            setState(() {
              isLoading = true;
            });
            signInWithPhoneNumber(
                phoneNumber: phoneNumberController.text.trim());
          }
        }
      },
      child: isLoading
          ? const CircularProgressIndicator(
              color: AppColors.whiteColor,
            )
          : const AppText(
              text: 'Request OTP',
              color: AppColors.whiteColor,
            ),
    );
  }

  _buildSubmitOtpContainer() {
    return BlocConsumer<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          context
              .read<UserDetailsCubit>()
              .fetchUserDetails(state.userId.toString());
          context.read<AuthCubit>().authenticateUser(
              userId: state.userId.toString(),
              firebaseId: state.user.uid,
              authProvider: state.authProvider);
          redirectToMainScreen(context);
        }
        if (state is SignInFailure) {
          showSnackBar(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return ResponsiveButton(
          height: 45,
          radius: 50,
          width: double.maxFinite,
          onPressed: state is SignInProgress
              ? () {}
              : () {
                  List list = [];

                  for (int i = 0; i < 6; i++) {
                    list.add(controllers[i].text.trim());
                  }

                  String code = list.join('');
                  if (code.isNotEmpty && code.length == 6) {
                    //
                    context.read<SignInCubit>().signInUser(
                          AuthProvider.mobile,
                          smsCode: code,
                          verificationId: userVerificationId,
                        );
                  }
                },
          child: state is SignInProgress
              ? const CircularProgressIndicator(
                  color: AppColors.whiteColor,
                )
              : const AppText(
                  text: 'Submit OTP',
                  color: AppColors.whiteColor,
                ),
        );
      },
    );
  }

  void signInWithPhoneNumber({required String phoneNumber}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: '${Constants.countryCode}$phoneNumber',
      verificationCompleted: (PhoneAuthCredential credential) {
        print("Phone number verified");
      },
      verificationFailed: (FirebaseAuthException e) {
        //if otp code does not verify
        print("Firebase Auth error------------");
        print(e.message);
        print("---------------------");
        showSnackBar(context, StringRes.defaultErrorMessage);

        setState(() {
          isLoading = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        print("Code sent successfully");
        setState(() {
          codeSent = true;
          userVerificationId = verificationId;
          isLoading = false;
        });

        Future.delayed(const Duration(milliseconds: 75)).then((value) {
          resendOtpTimerContainerKey.currentState?.setResendOtpTimer();
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Widget _buildResendText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ResendOtpTimerContainer(
            key: resendOtpTimerContainerKey,
            enableResendOtpButton: () {
              setState(() {
                enableResendOtpButton = true;
              });
            }),
        enableResendOtpButton
            ? TextButton(
                onPressed: enableResendOtpButton
                    ? () async {
                        print("Resend otp ");
                        setState(() {
                          isLoading = false;
                          enableResendOtpButton = false;
                        });
                        resendOtpTimerContainerKey.currentState
                            ?.cancelOtpTimer();
                        signInWithPhoneNumber(
                            phoneNumber: phoneNumberController.text.trim());
                      }
                    : null,
                child: Text(
                  'Resend OTP',
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).secondaryHeaderColor,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.normal),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
