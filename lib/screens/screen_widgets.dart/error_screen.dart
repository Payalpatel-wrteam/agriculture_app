import 'package:agriculture_app/helper/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../helper/colors.dart';
import '../../helper/strings.dart';
import '../../helper/widgets.dart';
import 'app_large_text.dart';
import 'app_text.dart';

class ErrorScreen extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget? child;
  const ErrorScreen({Key? key, required this.onPressed, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(35),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SvgPicture.asset('${Constants.imagePath}error.svg'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          const AppLargeText(
            text: StringRes.somethingWentWrong,
            size: 28,
            maxLines: 2,
          ),
          defaultSizedBox(),
          // if (!kIsWeb)
          AppText(
            text: StringRes.somethingWentWrongDesc,
            color: AppColors.captionColor,
            overflow: TextOverflow.visible,
            lineSpacing: 1.5,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
          ),
          // child ??
          //     CircularGradientButton(
          //         onPressed: onPressed,
          //         child: const AppText(
          //           text: StringRes.tryAgain,
          //           color: whiteColor,
          //         )),
        ],
      ),
    );
  }
}
