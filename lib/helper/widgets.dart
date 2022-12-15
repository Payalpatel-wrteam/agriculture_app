import 'package:agriculture_app/helper/colors.dart';
import 'package:agriculture_app/helper/constant.dart';
import 'package:agriculture_app/helper/strings.dart';
import 'package:agriculture_app/helper/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';

import '../app/routes.dart';
import '../screens/screen_widgets.dart/app_text.dart';
import '../screens/screen_widgets.dart/caption_text.dart';

showSnackBar(BuildContext context, String message,
    {SnackBarAction? action, Duration? duration}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    action: action,
    duration: duration ?? const Duration(seconds: 2),
  ));
}

AppBar buildAppbar(BuildContext context, String title,
    {List<Widget>? actions}) {
  return AppBar(
    leading: buildBackButton(context, Constants.darkTheme),
    title: Text(title),
    centerTitle: true,
    actions: actions,
  );
}

Widget buildBackButton(BuildContext context, String style,
    {VoidCallback? onPressed}) {
  Color? color = style == Constants.darkTheme
      ? Theme.of(context).primaryColor
      : AppColors.whiteColor;
  return GestureDetector(
    onTap: onPressed ?? () => Navigator.of(context).pop(),
    child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: color,
        )),
  );
}

Html buildHtmlContent(
  String text,
) {
  return Html(
    data: text,
    defaultTextStyle: const TextStyle(
      fontSize: 16,
      color: AppColors.primaryColor,
    ),
  );
}

SizedBox defaultSizedBox() {
  return const SizedBox(
    height: 20,
  );
}

SizedBox smallSizedBox() {
  return const SizedBox(
    height: 5,
  );
}

Widget buildTextButton(Widget child, VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: TextButton(
      child: child,
      onPressed: onPressed,
    ),
  );
}

Widget inputWidget(
    {required String attribute,
    required TextEditingController textEditingController,
    required TextInputType textInputAction,
    required String hint,
    required String title,
    int? maxLines,
    Function? validator,
    bool isPhoneNumber = false,
    bool isReadOnly = false,
    bool isDropDown = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: title,
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.only(top: 0, bottom: 0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: AppColors.greyColor!,
              )),
          child: IgnorePointer(
            ignoring: isReadOnly,
            child: TextFormField(
              validator: (value) {
                {
                  if (value!.isEmpty) {
                    return "Please fill this field";
                  }
                  if (isPhoneNumber) {
                    final pattern = RegExp(
                        r"((\+*)((0[ -]*)*|((91 )*))((\d{12})+|(\d{10})+))|\d{5}([- ]*)\d{6}");
                    if (!pattern.hasMatch(value)) {
                      return StringRes.invalidPhoneMessage;
                    } else {
                      return null;
                    }
                  }
                }
                return null;
              },
              controller: textEditingController,
              keyboardType: textInputAction,
              maxLines: maxLines ?? 1,
              readOnly: isReadOnly,
              style: const TextStyle(color: AppColors.blackColor),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15),
                  hintText: hint,
                  border: InputBorder.none,
                  // suffixIcon: isDropDown ? Image.asset() : null,
                  hintStyle:
                      TextStyle(color: AppColors.greyColor, fontSize: 14)),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget dropwdownWidget(
    {required String hintText,
    required String text,
    required String selectedValue,
    required Function(String?) onChanged,
    required List<DropdownMenuItem<String>>? items}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: text,
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: AppColors.greyColor!,
                )),
            child: DropdownButton(
              isExpanded: true,
              style: const TextStyle(
                  color: AppColors.blackColor), //Dropdown font color
              dropdownColor: Colors.white, //dropdown menu background color
              icon: Icon(Icons.keyboard_arrow_down_sharp,
                  color: AppColors.greyColor), //dropdown indicator icon

              hint: Text(hintText),
              underline: const SizedBox(),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              // decoration: InputDecoration(
              //     contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              //     border: InputBorder.none,
              //     hintStyle:
              //         TextStyle(color: AppColors.greyColor, fontSize: 14)),
              value: selectedValue.isNotEmpty ? selectedValue : null,
              onChanged: onChanged,
              items: items,
            ),
          )
        ]),
  );
}

openDatePicker(BuildContext context) {
  return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2100));
}

TextFormField buildTextField(
    {required TextEditingController controller,
    required String hintText,
    required Function validator,
    Function? onFieldSubmitted,
    bool? readOnly,
    bool? obscure,
    TextAlign? textAlign,
    TextInputType? textInputType,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
    Widget? suffixWidget}) {
  return TextFormField(
    controller: controller,
    focusNode: focusNode,
    readOnly: readOnly ?? false,
    obscureText: obscure ?? false,
    keyboardType: textInputType,
    textAlign: textAlign ?? TextAlign.left,
    textAlignVertical: TextAlignVertical.center,
    textInputAction: textInputAction,
    style: const TextStyle(
      fontSize: 16.0,
      color: AppColors.whiteColor,
    ),
    decoration: InputDecoration(
      fillColor: Colors.transparent,
      filled: true,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.whiteShade),
          borderRadius: BorderRadius.circular(50)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.whiteShade),
          borderRadius: BorderRadius.circular(50)),
      border: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: AppColors.whiteShade),
          borderRadius: BorderRadius.circular(50)),
      contentPadding: const EdgeInsets.all(15),
      hintText: hintText,
      hintStyle: const TextStyle(
        fontSize: 16.0,
      ),
      suffixIcon: suffixWidget,
    ),
    cursorColor: AppColors.primaryColor,
    cursorHeight: 22,
    validator: (val) => validator(val),
    onFieldSubmitted:
        onFieldSubmitted != null ? (val) => onFieldSubmitted(val) : null,
  );
}

TextFormField buildPasswordTextField(
    TextEditingController controller, String hintText, Function validator) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(hintText: hintText),
    validator: (val) => validator(val),
  );
}

void pushNewPage(BuildContext context, String route,
    {dynamic params,
    bool? replacePrevious = false,
    bool? replaceAll = false,
    bool? pushRoute = false}) {
  if (replaceAll == true) {
    Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
  } else if (replacePrevious == true) {
    Navigator.of(context).pushReplacementNamed(route, arguments: params);
  } else {
    Navigator.of(context).pushNamed(route, arguments: params);
  }
}

redirectToMainScreen(BuildContext context) {
  pushNewPage(context, Routes.main, replaceAll: true);
}

void changeStatusBarBrightnesss(String theme) {
  SystemChrome.setSystemUIOverlayStyle(theme == Constants.lightTheme
      ? SystemUiOverlayStyle.light
      : SystemUiOverlayStyle.dark);
}

Widget buildSkip(BuildContext context, VoidCallback onPressed) {
  return GestureDetector(
    onTap: onPressed,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppText(
            text: StringRes.skip,
            size: 16,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          const SizedBox(
            width: 2,
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: Theme.of(context).secondaryHeaderColor,
          )
        ],
      ),
    ),
  );
}

Future<bool> navigateBack(BuildContext context, String message,
    {required bool exitApp}) async {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: AppText(text: message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: AppText(
                  text: StringRes.no,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (exitApp)
                    SystemNavigator.pop();
                  else
                    Navigator.of(context).pop();
                },
                child: AppText(
                  text: StringRes.yes,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ],
          ));

  return Future.value(true);
}
