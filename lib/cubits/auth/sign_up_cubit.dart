import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/auth_repository.dart';
import 'auth_cubit.dart';

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpProgress extends SignUpState {
  final AuthProvider authProvider;
  SignUpProgress(this.authProvider);
}

class SignUpSuccess extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String errorMessage;
  final AuthProvider authProvider;
  SignUpFailure(this.errorMessage, this.authProvider);
}

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository authRepository = AuthRepository();

  SignUpCubit() : super(SignUpInitial()); //cubit initialization

  void signUpUser(
    AuthProvider authProvider,
    String name,
    String email,
    String password,
  ) {
    emit(SignUpProgress(authProvider));
    print('---authProvider---$authProvider');
    print('---name---$name');

    authRepository.signUpUser(name, email, password).then((value) =>
        //success
        emit(SignUpSuccess())).catchError((e) {
      //failure
      emit(SignUpFailure(e.toString(), authProvider));
    });
  }
}
