import 'package:agriculture_app/helper/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/auth_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../main.dart';

enum AuthProvider { gmail, fb, email, apple, mobile }

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthProgress extends AuthState {}

class Unauthenticated extends AuthState {}

class Authenticated extends AuthState {
  final AuthModel authModel;

  Authenticated(this.authModel);
}

class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure(this.errorMessage);
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository = AuthRepository();
  AuthCubit() : super(AuthInitial()) {
    checkIsAuthenticated();
  }

  void checkIsAuthenticated() {
    if (session.getBoolData(Constants.isUserLoggedInSessionKey) ?? false) {
      emit(Authenticated(AuthModel(
        authProvider: authRepository.getAuthProviderFromString(
            session.getStringData(Constants.authProviderSessionKey)),
        userId: session.getStringData(Constants.userIdSessionKey),
        firebaseId: session.getStringData(Constants.firebaseIdSessionKey),
      )));
    } else {
      emit(Unauthenticated());
    }
  }

  void authenticateUser(
      {required String userId,
      required String firebaseId,
      required AuthProvider authProvider}) {
    //
    session.saveData(Constants.isUserLoggedInSessionKey, true);
    session.saveData(Constants.firebaseIdSessionKey, firebaseId);

    session.saveData(Constants.authProviderSessionKey,
        authRepository.getAuthTypeString(authProvider));

    print('---auth---$state');
    //emit new state
    emit(Authenticated(AuthModel(
        userId: userId, firebaseId: firebaseId, authProvider: authProvider)));
  }

  String getUserFirebaseId() {
    if (state is Authenticated) {
      return (state as Authenticated).authModel.firebaseId;
    }
    return "";
  }

  String getUserId() {
    if (state is Authenticated) {
      return session.getStringData(Constants.userIdSessionKey);
    }
    return '0';
  }

  void signOut() async {
    AuthProvider authProvider = (state as Authenticated).authModel.authProvider;
    if (state is Authenticated) {
      // emit(AuthInitial());
      await authRepository
          .signOutUser(authProvider)
          .catchError((e) => emit(AuthFailure(e.toString())));
      emit(Unauthenticated());
    }
  }
}
