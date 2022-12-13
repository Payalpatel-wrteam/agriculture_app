import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/auth_repository.dart';

abstract class DeleteAccountState {}

class DeleteAccountInitial extends DeleteAccountState {}

class DeleteAccountProgress extends DeleteAccountState {}

class DeleteAccountFailure extends DeleteAccountState {
  final String errorMessage;
  DeleteAccountFailure(this.errorMessage);
}

class AccountDeleted extends DeleteAccountState {
  final String successMessage;
  AccountDeleted({required this.successMessage});
}

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  final AuthRepository authRepository = AuthRepository();
  DeleteAccountCubit() : super(DeleteAccountInitial());
  void deleteUserAccount(String userId) {
    emit(DeleteAccountProgress());
    authRepository
        .deleteAccount(userId)
        .then((value) => emit(AccountDeleted(successMessage: value)))
        .catchError((e) => emit(DeleteAccountFailure(e.toString())));
  }
}
