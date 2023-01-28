import 'package:agriculture_app/data/models/farm_details.dart';
import 'package:agriculture_app/data/repositories/farmer_repository.dart';
import 'package:agriculture_app/helper/api_constant.dart';
import 'package:agriculture_app/helper/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class GetFarmDetailsState {}

class GetFarmDetailsInitial extends GetFarmDetailsState {}

class GetFarmDetailsInProgress extends GetFarmDetailsState {}

class GetMoreFarmDetailsInProgress extends GetFarmDetailsState {}

class GetFarmDetailsSuccess extends GetFarmDetailsState {
  final List<FarmDetails> farmDetails;
  final int totalData;
  final bool hasMore;
  final List<Map<String, List<String>>> talukaAndVillages;
  GetFarmDetailsSuccess(
      this.farmDetails, this.totalData, this.hasMore, this.talukaAndVillages);
}

class GetFarmDetailsFailure extends GetFarmDetailsState {
  final String errorMessage;
  GetFarmDetailsFailure(this.errorMessage);
}

class GetFarmDetailsCubit extends Cubit<GetFarmDetailsState> {
  FarmerRepository farmerRepository = FarmerRepository();
  GetFarmDetailsCubit() : super(GetFarmDetailsInitial());

  void getFarmDetails({
    required Map<String, String> params,
  }) {
    emit(GetFarmDetailsInProgress());
    farmerRepository.getFarmDetails(parameter: params).then((value) {
      print('==value==$value');

      var list = value[Constants.data] as List<dynamic>;

      final data = list.map((model) => FarmDetails.fromJson(model)).toList();

      final total = int.parse(value[Constants.total].toString());
      List<Map<String, List<String>>> talukaList = [];

      (value[ApiConstants.talukaAndVillages] as Map).forEach(
          (k, v) => talukaList.add({k as String: List<String>.from(v)}));
      print('total==$total==hasmore==${total > data.length}');
      emit(GetFarmDetailsSuccess(data, total, total > data.length, talukaList));
    }).catchError((e) {
      emit(GetFarmDetailsFailure(e.toString()));
    });
  }

  resetState() {
    emit(GetFarmDetailsInitial());
  }

  emitSuccessState(
      {required List<FarmDetails> farmDetails,
      required int totalData,
      required bool hasMore,
      required List<Map<String, List<String>>> talukaAndVillages}) {
    print('in success state==${farmDetails.length}==$totalData==$hasMore');
    emit(GetFarmDetailsSuccess(
        farmDetails, totalData, hasMore, talukaAndVillages));
  }
}
