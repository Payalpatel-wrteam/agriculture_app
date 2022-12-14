import 'package:agriculture_app/data/models/farm_details.dart';

import '../../helper/api_constant.dart';
import '../../helper/constant.dart';
import '../../helper/strings.dart';
import '../../main.dart';
import '../../screens/screen_widgets.dart/custom_exception.dart';

class FarmerRepository {
  addNewApplication(
      {required Map<String, dynamic> farmDetails,
      required bool isEditPage}) async {
    var getdata = await apiBaseHelper.postAPICall(
        param: farmDetails,
        apiMethodUrl: isEditPage
            ? ApiConstants.editFarmDetailsApiKey
            : ApiConstants.addFarmDetailsApiKey);
    if (getdata != null) {
      bool error = getdata[Constants.error];

      if (!error) {
        return {
          Constants.data: FarmDetails.fromJson(getdata[Constants.data]),
          Constants.message: getdata[Constants.message]
        };
      } else {
        throw CustomException(getdata[Constants.message]);
      }
    } else {
      throw CustomException(StringRes.defaultErrorMessage);
    }
  }

  Future<Map<String, dynamic>> getFarmDetails({
    required Map<String, String> parameter,
  }) async {
    List<FarmDetails> farmList;

    var getdata = await apiBaseHelper.postAPICall(
        param: parameter, apiMethodUrl: ApiConstants.getFarmDetailsApiKey);
    if (getdata != null) {
      bool error = getdata[Constants.error];

      if (!error) {
        var list = getdata[Constants.data] as List<dynamic>;

        farmList = list.map((model) => FarmDetails.fromJson(model)).toList();
        return Map.from(getdata);
      } else {
        throw CustomException(getdata[Constants.message]);
      }
    } else {
      throw CustomException(StringRes.defaultErrorMessage);
    }
  }

  deleteFarmDetails({
    required String id,
  }) async {
    var getdata = await apiBaseHelper.postAPICall(
        param: {ApiConstants.idAPiKey: id},
        apiMethodUrl: ApiConstants.deleteFarmDetailsApiKey);
    if (getdata != null) {
      bool error = getdata[Constants.error];

      if (!error) {
        return getdata[Constants.message];
      } else {
        throw CustomException(getdata[Constants.message]);
      }
    } else {
      throw CustomException(StringRes.defaultErrorMessage);
    }
  }
}
