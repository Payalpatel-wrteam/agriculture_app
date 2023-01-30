import 'package:agriculture_app/helper/constant.dart';

class UserProfile {
  final String? name;
  final int? userId;
  final String? firebaseId;
  final String? email;
  final String? userType;
  final String? status;

  UserProfile(
      {this.email,
      this.firebaseId,
      this.name,
      this.userId,
      this.userType,
      this.status});

  static UserProfile fromJson(Map<String, dynamic> jsonData) {
    print('==in json ===$jsonData');
    //torefer keys go profileMan.remoteRepo
    return UserProfile(
      name: jsonData[Constants.name] ?? '',
      email: jsonData[Constants.email] ?? '',
      firebaseId: jsonData[Constants.firebaseId] ?? '',
      userId: jsonData['id'],
      status: jsonData['status'] ?? '1',
      userType: jsonData['type'] != null
          ? jsonData['type'].toString()
          : Constants.supervisorType,
    );
  }
}
