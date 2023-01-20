import 'package:agriculture_app/helper/constant.dart';

class UserProfile {
  final String? name;
  final int? userId;
  final String? firebaseId;
  final String? email;
  final String? userType;

  UserProfile(
      {this.email, this.firebaseId, this.name, this.userId, this.userType});

  static UserProfile fromJson(Map<String, dynamic> jsonData) {
    //torefer keys go profileMan.remoteRepo
    return UserProfile(
      name: jsonData[Constants.name] ?? '',
      email: jsonData[Constants.email] ?? '',
      firebaseId: jsonData[Constants.firebaseId] ?? '',
      userId: jsonData['id'],
      userType: jsonData['type'] ?? '0',
    );
  }
}
