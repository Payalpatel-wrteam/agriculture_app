import 'dart:convert';
import 'dart:io';

import 'package:agriculture_app/helper/api_constant.dart';
import 'package:agriculture_app/helper/constant.dart';

import '../../helper/strings.dart';
import '../../main.dart';
import '../../screens/screen_widgets.dart/custom_exception.dart';

class ProfileRepository {
  Future<dynamic> getUserDetailsById(int userId) async {
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

  Future updateUserDetails(
      {required String userId,
      required String email,
      required String name,
      required String mobile}) async {
    // Map<String, String> parameter = {};

    // var getdata = await apiBaseHelper.postAPICall(
    //   param: parameter,
    //   headers: false,
    // );
    // if (getdata != null) {
    //   String error = getdata["error"];
    //   if (error == 'true') {
    //     throw CustomException(getdata['message']);
    //   }
    // } else {
    //   throw CustomException(StringRes.defaultErrorMessage);
    // }
  }

  Future<dynamic> uploadProfilePicture(
      {required File file, required String userId}) async {
    // Map<String, String> parameter = {};
    // String token = session.getStringData(tokenSessionKey);
    // Map<String, String> headers = {'Authorization': 'Bearer $token'};
    // try {
    //   var request;

    //   request = http.MultipartRequest('POST', Uri.parse(apiBaseUrl))
    //     ..fields.addAll(parameter)
    //     ..headers.addAll(headers)
    //     ..files.add(await http.MultipartFile.fromPath('image', file.path));

    //   var res = await request.send();
    //   //Get the response from the server
    //   var responseData = await res.stream.toBytes();

    //   var responseString = String.fromCharCodes(responseData);
    //   print('---file res---$responseString');
    //   if (res.statusCode == 200) {
    //     final responseBody = jsonDecode(responseString);

    //     // print('---file res---${responseBody[0]['file_path']}');
    //     if (responseBody["error"]) {
    //       throw CustomException(responseBody["message"]);
    //     } else {
    //       return responseBody["file_path"];
    //     }
    //   } else {
    //     throw CustomException('error');
    //   }
    // } on SocketException catch (_) {
    //   throw CustomException(StringRes.noInternetErrorMessage);
    // } on Exception catch (e) {
    //   throw CustomException(e);
    // }
  }
}
