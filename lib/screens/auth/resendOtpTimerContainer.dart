import 'dart:async';

import 'package:agriculture_app/helper/constant.dart';
import 'package:flutter/material.dart';

class ResendOtpTimerContainer extends StatefulWidget {
  final Function enableResendOtpButton;
  ResendOtpTimerContainer({Key? key, required this.enableResendOtpButton})
      : super(key: key);

  @override
  ResendOtpTimerContainerState createState() => ResendOtpTimerContainerState();
}

class ResendOtpTimerContainerState extends State<ResendOtpTimerContainer> {
  Timer? resendOtpTimer;
  int resendOtpTimeInSeconds = Constants.otpTimeOutSeconds - 1;

  //
  void setResendOtpTimer() {
    print("Start resend otp timer");
    print("------------------------------------");
    setState(() {
      resendOtpTimeInSeconds = Constants.otpTimeOutSeconds - 1;
    });
    resendOtpTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendOtpTimeInSeconds == 0) {
        timer.cancel();
        widget.enableResendOtpButton();
      } else {
        resendOtpTimeInSeconds--;
        setState(() {});
      }
    });
  }

  void cancelOtpTimer() {
    resendOtpTimer?.cancel();
  }

  @override
  void dispose() {
    cancelOtpTimer();
    super.dispose();
  }

//to get time to display in text widget
  String getTime() {
    String secondsAsString = resendOtpTimeInSeconds < 10
        ? " 0$resendOtpTimeInSeconds"
        : resendOtpTimeInSeconds.toString();
    return " $secondsAsString";
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Resend OTP in' + getTime(),
      style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).secondaryHeaderColor,
          fontWeight: FontWeight.normal),
    );
  }
}
