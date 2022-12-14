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

  String getUserFcmId() {
    if (state is UserDetailsFetchSuccess) {
      return (state as UserDetailsFetchSuccess).userProfile.fcmToken!;
    }
    return "";
  }

  String getUserStatus() {
    if (state is UserDetailsFetchSuccess) {
      return (state as UserDetailsFetchSuccess).userProfile.status!;
    }
    return "0";
  }

  String? getUserEmail() {
    if (state is UserDetailsFetchSuccess) {
      return (state as UserDetailsFetchSuccess).userProfile.email;
    }
    return "";
  }

  String getUserProfilePicture() {
    if (state is UserDetailsFetchSuccess) {
      return (state as UserDetailsFetchSuccess).userProfile.profileUrl ?? '';
    }
    return "";
  }

  String? getFcmToken() {
    if (state is UserDetailsFetchSuccess) {
      return (state as UserDetailsFetchSuccess).userProfile.fcmToken;
    }
    return "";
  }

  int getIsSubscibe() {
    if (state is UserDetailsFetchSuccess) {
      // return 1;
      return int.parse(
          (state as UserDetailsFetchSuccess).userProfile.isSubscribe!);
      //uncommnent this
    }
    return 0;
  }

  String getInAppExpDate() {
    if (state is UserDetailsFetchSuccess) {
      return (state as UserDetailsFetchSuccess).userProfile.inappExpDate ?? '';
    }
    return "";
  }

  void updateUserProfileUrl(String profileUrl) {
    if (state is UserDetailsFetchSuccess) {
      final oldUserDetails = (state as UserDetailsFetchSuccess).userProfile;

      emit((UserDetailsFetchSuccess(
          oldUserDetails.copyWith(profileUrl: profileUrl))));
    }
  }

  void updateUserProfile(
      {String? name, String? status, String? mobile, String? email}) {
    //
    if (state is UserDetailsFetchSuccess) {
      final oldUserDetails = (state as UserDetailsFetchSuccess).userProfile;
      final userDetails = oldUserDetails.copyWith(
        email: email,
        mobile: mobile,
        name: name,
        status: status,
      );

      emit((UserDetailsFetchSuccess(userDetails)));
    }
  }

  UserProfile getUserProfile() {
    if (state is UserDetailsFetchSuccess) {
      return (state as UserDetailsFetchSuccess).userProfile;
    }
    return UserProfile();
  }

  resetUserDetailsState() {
    print('resetting user details');
    emit(UserDetailsInitial());
    final userDetails = UserProfile(
        userId: 0,
        fcmToken: '0',
        email: 'guest@gmail.com',
        name: 'Guest',
        profileUrl: '',
        status: '0',
        isSubscribe: '0');

    print(userDetails);
    emit(UserDetailsFetchSuccess(userDetails));
    print('success state emited');
  }
}
