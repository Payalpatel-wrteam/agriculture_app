import 'dart:convert';
import 'dart:io';

import 'package:agriculture_app/helper/api_constant.dart';
import 'package:agriculture_app/helper/constant.dart';

import '../../helper/strings.dart';
import '../../main.dart';
import '../../screens/screen_widgets.dart/custom_exception.dart';

class ProfileRepository {
  Future<dynamic> getUserDetailsById(String userId) async {
    Map<String, dynamic> parameter = {ApiConstants.userIdApiKey: userId};
    var getdata = await apiBaseHelper.postAPICall(
        param: parameter, apiMethodUrl: ApiConstants.getUserApiKey);
    if (getdata != null) {
      bool error = getdata[Constants.error];
      if (error) {
        throw CustomException(getdata['message']);
      }
      return getdata['data'];
    } else {
      throw CustomException(StringRes.defaultErrorMessage);
    }
  }




}
