import 'package:agriculture_app/helper/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/auth_repository.dart';
import 'auth_cubit.dart';

abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInProgress extends SignInState {
  final AuthProvider authProvider;
  SignInProgress(this.authProvider);
}

class SignInSuccess extends SignInState {
  final User user;
  final AuthProvider authProvider;
  final int userId;
  final String token;
  final bool isNewUser;
  final String status;

  SignInSuccess(
      {required this.user,
      required this.userId,
      required this.token,
      required this.authProvider,
      required this.status,
      required this.isNewUser});
}

class SignInFailure extends SignInState {
  final AuthProvider authProvider;
  final String errorMessage;

  SignInFailure(this.authProvider, this.errorMessage);
}

class SignInCubit extends Cubit<SignInState> {
  final AuthRepository authRepository = AuthRepository();

  SignInCubit() : super(SignInInitial()); //cubit initialization

  void signInUser(
    AuthProvider authProvider, {
    String? email,
    String? password,
    String? verificationId,
    String? smsCode,
  }) {
    emit(SignInProgress(authProvider));

    authRepository
        .signInUser(
          authProvider,
          email: email ?? '',
          password: password ?? '',
          smsCode: smsCode ?? "",
          verificationId: verificationId ?? "",
        )
        .then((value) => emit(SignInSuccess(
            userId: value[Constants.userId],
            token: value[Constants.token],
            user: value[Constants.user],
            isNewUser: value[Constants.isNewUser],
            status: value[Constants.status],
            authProvider: authProvider)))
        .catchError((e) => emit(SignInFailure(authProvider, e.toString())));
  }
}
