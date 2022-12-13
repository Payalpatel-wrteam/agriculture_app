// import 'dart:io';

// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../main.dart';

// abstract class SystemConfigState {}

// class SystemConfigIntial extends SystemConfigState {}

// class SystemConfigFetchInProgress extends SystemConfigState {}

// class SystemConfigFetchSuccess extends SystemConfigState {
//   final SystemConfig systemConfig;

//   SystemConfigFetchSuccess(this.systemConfig);
// }

// class SystemConfigFetchFailure extends SystemConfigState {
//   final String errorMessage;

//   SystemConfigFetchFailure(this.errorMessage);
// }

// class SystemConfigCubit extends Cubit<SystemConfigState> {
//   final AppRepository _appRepository = AppRepository();

//   SystemConfigCubit() : super(SystemConfigIntial());

//   void getSystemConfig() {
//     emit(SystemConfigFetchInProgress());
//     _appRepository
//         .fetchSystemConfig()
//         .then((value) => emit(SystemConfigFetchSuccess(value)))
//         .catchError((e) {
//       emit(SystemConfigFetchFailure(e.toString()));
//     });
//   }

//   bool isUpdateRequired() {
//     if (state is SystemConfigFetchSuccess) {
//       if ((state as SystemConfigFetchSuccess).systemConfig.forceUpdate == '1') {
//         if (Platform.isAndroid &&
//                 needsUpdate((state as SystemConfigFetchSuccess)
//                     .systemConfig
//                     .androidAppVersion) ||
//             Platform.isIOS &&
//                 needsUpdate((state as SystemConfigFetchSuccess)
//                     .systemConfig
//                     .iosAppVersion)) {
//           return true;
//         }
//       } else {
//         return false;
//       }
//     }
//     return false;
//   }

//   bool needsUpdate(String enforceVersion) {
//     final List<int> currentVersion = packageInfo.version
//         .split('.')
//         .map((String number) => int.parse(number))
//         .toList();
//     final List<int> enforcedVersion = enforceVersion
//         .split('.')
//         .map((String number) => int.parse(number))
//         .toList();
//     for (int i = 0; i < 3; i++) {
//       if (enforcedVersion[i] > currentVersion[i]) {
//         return true;
//       } else if (currentVersion[i] > enforcedVersion[i]) {
//         return false;
//       }
//     }
//     return false;
//   }

//   String getPaystackCurrency() {
//     if (state is SystemConfigFetchSuccess) {
//       return (state as SystemConfigFetchSuccess).systemConfig.paystackCurrency;
//     }
//     return session.getStringData(paystackCurrencySessionKey);
//   }

//   String getPaystackCurrencySymbol() {
//     if (state is SystemConfigFetchSuccess) {
//       return (state as SystemConfigFetchSuccess)
//           .systemConfig
//           .paystackCurrencySymbol;
//     }
//     return session.getStringData(paystackCurrencySymbolSessionKey);
//   }

//   // String getaboutUsUrl() {
//   //   if (state is SystemConfigFetchSuccess) {
//   //     return (state as SystemConfigFetchSuccess).systemConfig.aboutUsUrl;
//   //   }
//   //   return "";
//   // }
//   // String getHelpUrl() {
//   //   if (state is SystemConfigFetchSuccess) {
//   //     return (state as SystemConfigFetchSuccess).systemConfig.hepUrl;
//   //   }
//   //   return "";
//   // }

//   // String getPrivacyUrl() {
//   //   if (state is SystemConfigFetchSuccess) {
//   //     return (state as SystemConfigFetchSuccess).systemConfig.privacyPolicyUrl;
//   //   }
//   //   return "";
//   // }

//   // String getTermsUrl() {
//   //   if (state is SystemConfigFetchSuccess) {
//   //     return (state as SystemConfigFetchSuccess).systemConfig.termsUrl;
//   //   }
//   //   return "";
//   // }

//   String getEmailId() {
//     if (state is SystemConfigFetchSuccess) {
//       return (state as SystemConfigFetchSuccess).systemConfig.emailId;
//     }
//     return session.getStringData(emailSessionKey);
//   }

//   String getLocation() {
//     if (state is SystemConfigFetchSuccess) {
//       return (state as SystemConfigFetchSuccess).systemConfig.location;
//     }
//     return session.getStringData(addressSessionKey);
//   }

//   String getPhoneNo() {
//     if (state is SystemConfigFetchSuccess) {
//       return (state as SystemConfigFetchSuccess).systemConfig.phoneNo;
//     }
//     return session.getStringData(phoneSessionKey);
//   }

//   String getFacebookUrl() {
//     if (state is SystemConfigFetchSuccess) {
//       return (state as SystemConfigFetchSuccess).systemConfig.facebookUrl;
//     }
//     return session.getStringData(facebookUrlSessionKey);
//   }

//   String getInstaUrl() {
//     if (state is SystemConfigFetchSuccess) {
//       return (state as SystemConfigFetchSuccess).systemConfig.instaUrl;
//     }
//     return session.getStringData(instaUrlSessionKey);
//   }

//   String getTwitterUrl() {
//     if (state is SystemConfigFetchSuccess) {
//       return (state as SystemConfigFetchSuccess).systemConfig.twiterUrl;
//     }
//     return session.getStringData(twiterUrlSessionKey);
//   }

//   String getLinkedinUrl() {
//     if (state is SystemConfigFetchSuccess) {
//       return (state as SystemConfigFetchSuccess).systemConfig.linkedInUrl;
//     }
//     return session.getStringData(linkedInUrlSessionKey);
//   }

//   String getYoutubeUrl() {
//     if (state is SystemConfigFetchSuccess) {
//       return (state as SystemConfigFetchSuccess).systemConfig.youtubeUrl;
//     }
//     return session.getStringData(youtubeUrlSessionKey);
//   }
// }
