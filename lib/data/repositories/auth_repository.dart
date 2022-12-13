import 'dart:io';

import 'package:agriculture_app/helper/api_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../../cubits/auth/auth_cubit.dart';
import '../../helper/constant.dart';
import '../../helper/strings.dart';
import '../../main.dart';
import '../../screens/screen_widgets.dart/check_internet.dart';
import '../../screens/screen_widgets.dart/custom_exception.dart';

final _firebaseAuth = FirebaseAuth.instance;

class AuthRepository {
  Future<void> signOutUser(AuthProvider authProvider) async {
    print('-signout');

    await FirebaseAuth.instance
        .signOut()
        .then((value) => print('signout success'));

    session.removeCurrentUserData();
  }

  Future<Map<String, dynamic>> signInUser(AuthProvider authProvider,
      {String? email, String? password}) async {
    if (await InternetConnectivity.isUserOffline()) {
      throw CustomException(StringRes.noInternetErrorMessage);
    }
    try {
      Map<String, dynamic> result =
          await checkSingInType(authProvider, email: email, password: password);
      if (result.isNotEmpty) {
        print('---result--$result');

        final user = result[Constants.user] as User;
        bool isNewUser = result[Constants.isNewUser] as bool;
        print('---user--$user');
        print('---isNewUser----$isNewUser');
        // if (isNewUser && authProvider != AuthProvider.email) {
        var response = await addUser(null, user, authProvider);

        if (response != null) {
          session.saveData(
              Constants.userIdSessionKey, response[Constants.id].toString());
          // session.saveData(Constants.tokenSessionKey, response['api_token']);
          // session.saveData(Constants.fcmTokenSessionKey, response['fcm_id']);
          result[Constants.userId] = response[Constants.id].toString();
          result[Constants.token] = '';
          result[Constants.status] = '1';
        }
      } else {
        throw CustomException(StringRes.defaultErrorMessage);
      }

      return result;
    } on SocketException {
      throw FetchDataException(StringRes.noInternetErrorMessage);
    }
    //  catch (e) {
    //   print(e.toString());
    //   throw CustomException(StringRes.defaultErrorMessage);
    // }
  }

  //to signUp user
  Future<void> signUpUser(String name, String email, String password) async {
    if (await InternetConnectivity.isUserOffline()) {
      throw CustomException(StringRes.noInternetErrorMessage);
    }
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      print('---user cradential---$userCredential');
      //verify email address
      await userCredential.user!.sendEmailVerification();
      if (userCredential.user != null) {
        var response =
            await addUser(name, userCredential.user!, AuthProvider.email);

        if (response != null) {
          print('signup res===$response');
        }
      }
    } on FirebaseAuthException catch (e) {
      throw CustomException(e.message);
    } on SocketException catch (_) {
      throw FetchDataException(StringRes.noInternetErrorMessage);
    } on PlatformException catch (e) {
      throw CustomException(StringRes.noInternetErrorMessage);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> checkSingInType(AuthProvider authProvider,
      {String? email, String? password}) async {
    Map<String, dynamic> result = {};
    try {
      if (authProvider == AuthProvider.email) {
        UserCredential userCredential =
            await signInWithEmail(email!, password!);
        result['user'] = userCredential.user!;
        result['isNewUser'] = userCredential.additionalUserInfo!.isNewUser;
      }
      return result;
    } on SocketException catch (_) {
      throw FetchDataException(StringRes.noInternetErrorMessage);
    } on PlatformException catch (e) {
      throw CustomException(StringRes.noInternetErrorMessage);
    }
    //firebase auht errors
    on FirebaseAuthException catch (e) {
      throw CustomException(e.message);
    } catch (e) {
      print(e.toString());
      throw CustomException(e.toString());
    }
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user!.emailVerified) {
        return userCredential;
      } else {
        throw CustomException(StringRes.emailVerificationErrorMessage);
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'invalid-email') {
        throw CustomException(StringRes.invalidEmailMessage);
      } else if (e.code == 'user-not-found') {
        throw CustomException(StringRes.invalidEmailForUserErrorMessage);
      } else if (e.code == 'wrong-password') {
        throw CustomException(StringRes.invalidPasswordErrorMessage);
      } else {
        throw CustomException(StringRes.defaultErrorMessage);
      }
    } on Exception catch (e) {
      throw CustomException(e.toString());
    }
  }

  String getAuthTypeString(AuthProvider provider) {
    String authType;
    if (provider == AuthProvider.fb) {
      authType = "fb";
    } else if (provider == AuthProvider.gmail) {
      authType = "gmail";
    } else if (provider == AuthProvider.apple) {
      authType = "apple";
    } else {
      authType = "email";
    }
    return authType;
  }

  AuthProvider getAuthProviderFromString(String? value) {
    AuthProvider authProvider;
    if (value == "fb") {
      authProvider = AuthProvider.fb;
    } else if (value == "gmail") {
      authProvider = AuthProvider.gmail;
    } else if (value == "apple") {
      authProvider = AuthProvider.apple;
    } else {
      authProvider = AuthProvider.email;
    }
    return authProvider;
  }

  static Future<String> getFCMToken() async {
    // try {
    //   return await FirebaseMessaging.instance.getToken() ?? '';
    // } catch (e) {
    //   print(e.toString());
    //   return "";
    // }
    return '';
  }

  Future addUser(String? name, User user, AuthProvider authProvider) async {
    String fcmToken = await getFCMToken();

    Map<String, String> parameter = {
      ApiConstants.firebaseIdAPiKey: user.uid,
      ApiConstants.nameAPiKey: name ?? user.displayName ?? '',
      ApiConstants.emailAPiKey: user.email ?? '',
    };
    print('prama==$parameter');
    var getdata = await apiBaseHelper.postAPICall(
        param: parameter, apiMethodUrl: ApiConstants.userloginApiKey);
    if (getdata != null) {
      bool error = getdata[Constants.error];
      print('user login---$getdata');

      if (!error) {
        return getdata[Constants.data];
      } else {
        throw CustomException(getdata[Constants.message]);
      }
    } else {
      throw CustomException(StringRes.defaultErrorMessage);
    }
  }

  // void updateFcmId(String fcmToken) async {
  //   if (fcmToken != '') {
  //     Map<String, String> parameter = {
  //       updateFcmApiKey: '1',
  //       userIdApiKey: session.getStringData(userIdSessionKey),
  //       fcmIDAPiKey: fcmToken
  //     };

  //     var getdata = await apiBaseHelper.postAPICall(
  //       param: parameter,
  //       headers: false,
  //     );
  //     if (getdata != null) {
  //       session.saveData(fcmTokenSessionKey, fcmToken);
  //       print(getdata['message']);
  //     } else {
  //       throw CustomException(StringRes.updateFcmErrorMessage);
  //     }
  //   }
  // }

  Future<String> resetPassword(String email) async {
    print('reset email--$email');
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return StringRes.passwordResetLinkSent;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'invalid-email') {
        return StringRes.invalidEmailMessage;
      } else if (e.code == 'user-not-found') {
        return StringRes.invalidEmailForUserErrorMessage;
      } else {
        return StringRes.defaultErrorMessage;
      }
    } catch (e) {
      return StringRes.defaultErrorMessage;
    }
  }

  Future<String> deleteAccount(String userId) async {
    String message = '';
    // try {
    //   await FirebaseAuth.instance.currentUser!.delete();
    //   Map<String, dynamic> parameter = {
    //     deleteUserApiKey: '1',
    //     userIdApiKey: userId,
    //   };

    //   var getdata = await apiBaseHelper.postAPICall(
    //     param: parameter,
    //   );
    //   if (getdata != null) {
    //     if (getdata["error"] == "true") {
    //       throw CustomException(getdata["message"]);
    //     } else {
    //       session.removeCurrentUserData();
    //       message = getdata['message'];
    //     }
    //   } else {
    //     throw CustomException(StringRes.defaultErrorMessage);
    //   }
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'requires-recent-login') {
    //     throw CustomException(StringRes.userDeleteErrorMessage);
    //   }
    // }
    return message;
  }
}
