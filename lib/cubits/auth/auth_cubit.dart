import 'package:agriculture_app/helper/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/auth_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../main.dart';

enum AuthProvider { gmail, fb, email, apple }

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
          userId: session.getIntData(Constants.userIdSessionKey),
          firebaseId: session.getStringData(Constants.firebaseIdSessionKey),
          token: session.getStringData(Constants.tokenSessionKey))));
    } else {
      emit(Unauthenticated());
    }
  }

  void authenticateUser(
      {required int userId,
      required String firebaseId,
      required String token,
      required AuthProvider authProvider}) {
    //
    session.saveData(Constants.isUserLoggedInSessionKey, true);
    session.saveData(Constants.firebaseIdSessionKey, firebaseId);
    session.saveData(Constants.tokenSessionKey, token);
    session.saveData(Constants.authProviderSessionKey,
        authRepository.getAuthTypeString(authProvider));

    print('---auth---$state');
    //emit new state
    emit(Authenticated(AuthModel(
        userId: userId,
        firebaseId: firebaseId,
        token: token,
        authProvider: authProvider)));
  }

  String getUserFirebaseId() {
    if (state is Authenticated) {
      return (state as Authenticated).authModel.firebaseId;
    }
    return "";
  }

  int getUserId() {
    if (state is Authenticated) {
      return (state as Authenticated).authModel.userId;
    }
    return 0;
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
