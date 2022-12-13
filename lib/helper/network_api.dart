import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:agriculture_app/helper/api_constant.dart';
import 'package:agriculture_app/helper/strings.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../main.dart';
import '../screens/screen_widgets.dart/check_internet.dart';
import '../screens/screen_widgets.dart/custom_exception.dart';
import 'constant.dart';

class ApiBaseHelper {
  Future<dynamic> postAPICall({
    required Map<String, dynamic> param,
    required String apiMethodUrl,
    bool? headers,
    String requestType = 'post',
  }) async {
    String token = session.getStringData(Constants.tokenSessionKey);

    // param[ApiConstants.userIdApiKey] =
    //     session.getStringData(Constants.userIdSessionKey) ?? '';
    Map<String, String> defaultHeaders = {
      'accept': 'application/json',
    };

    if (token.trim().isNotEmpty) {
      defaultHeaders.addAll({
        'Authorization': 'Bearer $token',
      });
    }
    var responseJson, response;
    print('---param---$param---');
    try {
      if (await InternetConnectivity.isUserOffline()) {
        throw const SocketException(StringRes.noInternetErrorMessage);
      }
      if (requestType == 'post') {
        var url = Uri.parse('${ApiConstants.apiBaseUrl}$apiMethodUrl');
        response = await http
            .post(url,
                headers: defaultHeaders, body: param.isNotEmpty ? param : {})
            .onError((error, stackTrace) async {
          return Future.value();
        }).timeout(const Duration(minutes: Constants.apiTimeOut));
      } else {
        // response = await http.get(
        //   Uri.parse(apiUrl!),
        //   headers: {'Authorization': 'Bearer ****'},
        // ).timeout(const Duration(minutes: Constants.apiTimeOut));
      }
      responseJson = getJsonResponse(response);
      print('---api response---$responseJson');
    } on SocketException {
      throw FetchDataException(StringRes.noInternetErrorMessage);
    } on TimeoutException {
      throw FetchDataException(StringRes.defaultErrorMessage);
    } on Exception catch (e) {
      throw Exception(StringRes.defaultErrorMessage);
    }

    return responseJson;
  }

  dynamic getJsonResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }
}
