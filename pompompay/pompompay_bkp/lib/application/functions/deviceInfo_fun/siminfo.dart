// import 'dart:developer';

// import 'package:permission_handler/permission_handler.dart';
// import 'package:telephony_info_plus/telephony_info_plus.dart';
// import 'package:telephony_info_plus/telephony_info_plus_platform_interface.dart';

// class Siminfo {
//   static Future<List<TelephonyInfo>?> getPhoneNumber() async {
//     // Request phone permissions
//     var status = await Permission.phone.request();
//     String _platformVersion = '';
//   final _telephonyInfoPlusPlugin = TelephonyInfoPlus();

//     List<TelephonyInfo>? platformVersion;
//     if (status.isGranted) {
//     try {
//       platformVersion =
//           await _telephonyInfoPlusPlugin.getSimInfos();
//     return platformVersion;
//     } catch(e) {
//       print(e.toString());
//     }
//     _platformVersion = platformVersion.toString();
//    log(_platformVersion);
//     } else{
//       _platformVersion="no phone number";
//    log(_platformVersion);
//    return [];

//     }
//     return [];

//   }
// }
