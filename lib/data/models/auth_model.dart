import '../../cubits/auth/auth_cubit.dart';

class AuthModel {
  final AuthProvider authProvider;
  final String firebaseId;
  final String token;
  final int userId;
  // final bool isNewUser;

  AuthModel({
    required this.token,
    required this.firebaseId,
    required this.authProvider,
    required this.userId,
    // required this.isNewUser
  });

  static AuthModel fromJson(var authJson) {
    return AuthModel(
      token: authJson['token'],
      firebaseId: authJson['firebaseId'],
      authProvider: authJson['authProvider'],
      userId: authJson['userId'],
      // isNewUser: false,
    );
  }
}
