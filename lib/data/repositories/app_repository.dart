import '../../helper/constant.dart';

class AppRepository {
  Future<String> fetchAppDetails(String type) async {
    String response = '';
    // Map<String, String> parameter = {
    //   getSettingsApiKey: '1',
    //   typeAPiKey: type,
    // };

    // var getdata = await apiBaseHelper.postAPICall(
    //   param: parameter,
    //   headers: false,
    // );
    // if (getdata != null) {
    //   String error = getdata["error"];

    //   if (error != 'true') {
    //     response = getdata['data'];
    //   } else {
    //     throw CustomException(getdata['message']);
    //   }
    // } else {
    //   throw CustomException(StringRes.defaultErrorMessage);
    // }
    return response;
  }
}
