import 'package:agriculture_app/helper/colors.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/glassmorphism_container.dart';
import 'package:flutter/material.dart';

import '../../data/repositories/auth_repository.dart';
import '../../helper/strings.dart';
import '../../helper/validator.dart';
import '../../helper/widgets.dart';
import '../screen_widgets.dart/app_large_text.dart';
import '../screen_widgets.dart/app_text.dart';
import '../screen_widgets.dart/responsive_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: GlassmorphismContainer(
          child: _buildBodyFields(),
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

  Widget _buildBodyFields() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // const SizedBox(height: 10),
            const AppLargeText(
              text: StringRes.forgotPasswordTitle,
              maxLines: 2,
              textAlign: TextAlign.left,
            ),
            defaultSizedBox(),
            AppText(
              text: StringRes.forgotPasswordDesc,
              color: AppColors.captionColor,
              fontWeight: FontWeight.w300,
              textAlign: TextAlign.left,
              overflow: TextOverflow.visible,
              lineSpacing: 1.7,
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            buildTextField(
                controller: _emailTextController,
                hintText: StringRes.enterEmail,
                textAlign: TextAlign.center,
                validator: Validator.validateEmail),
            SizedBox(
              height: size.height * 0.05,
            ),
            ResponsiveButton(
                height: 45,
                radius: 50,
                width: double.maxFinite,
                child: const AppText(
                  text: StringRes.submitLbl,
                  color: AppColors.whiteColor,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String response = await AuthRepository()
                        .resetPassword(_emailTextController.text.trim());
                    //When a BuildContext is used, its mounted property must be checked after an asynchronous gap.
                    if (!mounted) return;
                    showSnackBar(context, response);
                  }
                })
          ],
        ),
      ),
    );
  }
}
