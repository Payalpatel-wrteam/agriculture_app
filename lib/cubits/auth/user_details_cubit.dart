import 'package:agriculture_app/helper/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/user_profile.dart';
import '../../data/repositories/profile_repository.dart';
import '../../main.dart';

@immutable
abstract class UserDetailsState {}

class UserDetailsInitial extends UserDetailsState {}

class UserDetailsFetchInProgress extends UserDetailsState {}

class UserDetailsFetchSuccess extends UserDetailsState {
  final UserProfile userProfile;
  UserDetailsFetchSuccess(this.userProfile);
}

class GuestUserDetails extends UserDetailsState {
  final UserProfile userProfile;
  GuestUserDetails(this.userProfile);
}

class UserDetailsFetchFailure extends UserDetailsState {
  final String errorMessage;
  UserDetailsFetchFailure(this.errorMessage);
}

class UserDetailsCubit extends Cubit<UserDetailsState> {
  final ProfileRepository _profileRepository = ProfileRepository();
  UserDetailsCubit() : super(UserDetailsInitial());

  //to fetch user details form remote
  void fetchUserDetails(String userId) async {
    emit(UserDetailsFetchInProgress());

    try {
      var response = await _profileRepository.getUserDetailsById(userId);

      emit(UserDetailsFetchSuccess(UserProfile.fromJson(response)));
    } catch (e) {
      emit(UserDetailsFetchFailure(e.toString()));
    }
  }

  String getUserName() {
    if (state is UserDetailsFetchSuccess) {
      return (state as UserDetailsFetchSuccess).userProfile.name!;
    }
    return "";
  }

  String getUserId() {
    if (state is UserDetailsFetchSuccess) {
      return (state as UserDetailsFetchSuccess).userProfile.userId.toString();
    }
    return '0';
  }

  bool isFarmer() {
    // return true;
    if (state is UserDetailsFetchSuccess) {
      return (state as UserDetailsFetchSuccess).userProfile.userType ==
          Constants.farmerType;
    }
    return false;
  }
}
