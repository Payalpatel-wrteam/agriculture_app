import 'package:agriculture_app/helper/constant.dart';

class UserProfile {
  final String? name;
  final String? userId;
  final String? firebaseId;
  final String? profileUrl;
  final String? email;
  final String? status;
  final String? authType;
  final String? points;
  final String? ipAddress;
  final String? fcmToken;
  final String? registeredDate;
  final String? isSubscribe;
  final String? inappExpDate;

  UserProfile(
      {this.email,
      this.fcmToken,
      this.firebaseId,
      this.authType,
      this.points,
      this.name,
      this.profileUrl,
      this.userId,
      this.ipAddress,
      this.registeredDate,
      this.isSubscribe,
      this.inappExpDate,
      this.status});

  static UserProfile fromJson(Map<String, dynamic> jsonData) {
    //torefer keys go profileMan.remoteRepo
    return UserProfile(
      name: jsonData[Constants.name] ?? '',
      email: jsonData[Constants.email] ?? '',
      firebaseId: jsonData[Constants.firebaseId] ?? '',
      // profileUrl: jsonData['profile'],
      // authType: jsonData['type'],
      // status: jsonData['status'],
      // userId: jsonData['id'],
      // points: jsonData['points'],
      // ipAddress: jsonData['ip_address'],
      // fcmToken: jsonData['fcm_id'],
      // registeredDate: jsonData['date_registered'],
      // isSubscribe: jsonData['is_subscribe'],
      // inappExpDate: jsonData['inapp_exp_date'],
    );
  }

  UserProfile copyWith({
    String? fcmToken,
    String? userId,
    String? profileUrl,
    String? name,
    String? mobile,
    String? status,
    String? email,
    String? isSubscribe,
    String? inappExpDate,
  }) {
    return UserProfile(
        fcmToken: fcmToken ?? this.fcmToken,
        userId: userId ?? this.userId,
        profileUrl: profileUrl ?? this.profileUrl,
        email: email ?? this.email,
        name: name ?? this.name,
        registeredDate: registeredDate,
        status: status ?? this.status,
        isSubscribe: isSubscribe ?? this.isSubscribe,
        inappExpDate: inappExpDate ?? this.inappExpDate);
  }
}
