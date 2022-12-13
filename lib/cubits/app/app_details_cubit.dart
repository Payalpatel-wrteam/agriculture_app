import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/app_repository.dart';

abstract class AppDetailsState {}

class AppDetailsIntial extends AppDetailsState {}

class AppDetailsFetchInProgress extends AppDetailsState {}

class AppDetailsFetchSuccess extends AppDetailsState {
  final String details;

  AppDetailsFetchSuccess(this.details);
}

class AppDetailsFetchFailure extends AppDetailsState {
  final String errorMessage;

  AppDetailsFetchFailure(this.errorMessage);
}

class AppDetailsCubit extends Cubit<AppDetailsState> {
  final AppRepository _appDetailsRepository = AppRepository();

  AppDetailsCubit() : super(AppDetailsIntial());

  void getAppDetails(String type) {
    emit(AppDetailsFetchInProgress());
    _appDetailsRepository
        .fetchAppDetails(type)
        .then((value) => emit(AppDetailsFetchSuccess(value)))
        .catchError((e) {
      emit(AppDetailsFetchFailure(e.toString()));
    });
  }
}
