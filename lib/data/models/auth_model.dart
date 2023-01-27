import '../../cubits/auth/auth_cubit.dart';

class AuthModel {
  final AuthProvider authProvider;
  final String firebaseId;

  final String userId;
  // final bool isNewUser;

  AuthModel({
    required this.firebaseId,
    required this.authProvider,
    required this.userId,
    // required this.isNewUser
  });

  static AuthModel fromJson(var authJson) {
    return AuthModel(
      firebaseId: authJson['firebaseId'],
      authProvider: authJson['authProvider'],
      userId: authJson['userId'],
      // isNewUser: false,
    );
  }
}
