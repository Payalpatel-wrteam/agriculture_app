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

Map<String, String> defaultHeaders = {
  'accept': 'application/json',
};

class ApiBaseHelper {
  Future<dynamic> postAPICall({
    required Map<String, dynamic> param,
    required String apiMethodUrl,
    bool? headers,
    String requestType = 'post',
  }) async {
    String token = '';

    token = session.getStringData(Constants.tokenSessionKey);
    defaultHeaders.addAll({
      'Authorization': 'Bearer $token',
    });
    print('token==$token');


    var responseJson, response;
    print('---param---$param---$apiMethodUrl');
    try {
      if (await InternetConnectivity.isUserOffline()) {
        throw const SocketException(StringRes.noInternetErrorMessage);
      }
      if (requestType == 'post') {
        var url = Uri.parse('${ApiConstants.apiBaseUrl}$apiMethodUrl');
        print('url=> $url');
        response = await http
            .post(url,
                headers: defaultHeaders, body: param.isNotEmpty ? param : {})
            .onError((error, stackTrace) async {
          print('---api response---$response--$url--$error');
          return Future.value();
        }).timeout(const Duration(minutes: Constants.apiTimeOut));
      } else {
        // response = await http.get(
        //   Uri.parse(apiUrl!),
        //   headers: {'Authorization': 'Bearer ****'},
        // ).timeout(const Duration(minutes: Constants.apiTimeOut));
      }
      print('---api response---$response');
      if (response != null) {
        responseJson = getJsonResponse(response: response);
      } else {
        throw CustomException(StringRes.defaultErrorMessage);
      }
    } on SocketException {
      throw FetchDataException(StringRes.noInternetErrorMessage);
    } on TimeoutException {
      throw FetchDataException(StringRes.defaultErrorMessage);
    } on Exception catch (e) {
      throw CustomException(StringRes.defaultErrorMessage);
    }

    return responseJson;
  }

  Future postApiFile(
      {required String url,
      required Map<String, String> filelist,
      required Map<String, dynamic> body}) async {
    var request =
        MultipartRequest('POST', Uri.parse('${ApiConstants.apiBaseUrl}$url'));
    String token = '';

    token = session.getStringData(Constants.tokenSessionKey);
    defaultHeaders.addAll({
      'Authorization': 'Bearer $token',
    });
    request.headers.addAll(defaultHeaders);

    body.forEach((key, value) {
      request.fields[key] = value;
    });
    if (filelist.isNotEmpty) {
      filelist.forEach((key, value) async {
        var pic = await MultipartFile.fromPath(key, value);
        request.files.add(pic);
      });
    }

    try {
      if (await InternetConnectivity.isUserOffline()) {
        throw const SocketException(StringRes.noInternetErrorMessage);
      }
      var res = await request.send();

      return getJsonResponse(isfromfile: true, streamedResponse: res);
    } on SocketException {
      throw FetchDataException(StringRes.noInternetErrorMessage);
    } on TimeoutException {
      throw FetchDataException(StringRes.dataNotFoundErrorMessage);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  dynamic getJsonResponse({
    Response? response,
    bool isfromfile = false,
    StreamedResponse? streamedResponse,
  }) async {
    int code;
    if (isfromfile) {
      code = streamedResponse!.statusCode;
    } else {
      code = response!.statusCode;
    }
    switch (code) {
      case 200:
        if (isfromfile) {
          var responseData = await streamedResponse!.stream.toBytes();

          return json.decode(String.fromCharCodes(responseData));
        } else {
          print('res==${json.decode(response!.body)}');
          return json.decode(response.body);
        }

      default:
        throw FetchDataException(
            'Error occurred while Communication with Server');
    }
  }
}
