import 'dart:io';
import 'dart:ui';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:pompompay/core/hook/hooks.dart';

class DeviceInformation {
  static final _deviceinfoplugin = DeviceInfoPlugin();
  static const _androidIdPlugin = AndroidId();

  static Future<String> getdeviceinfo() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await _deviceinfoplugin.androidInfo;
      // log('id:${info.id}');
      // log('serial number:${info.serialNumber}');
      // log('brand:${info.brand}');
      // log('device:${info.device}');
      // log('version:${info.version}');

      return '${info.manufacturer}-${info.model}';
    } else if (Platform.isIOS) {
      final info = await _deviceinfoplugin.iosInfo;
      return '${info.name}-${info.model}';
    } else {
      throw UnimplementedError();
    }
  }

  static Future<String> getdeviceid() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await _deviceinfoplugin.androidInfo;
      return info.id;
    } else if (Platform.isIOS) {
      final info = await _deviceinfoplugin.iosInfo;
      return '${info.identifierForVendor}';
    } else {
      throw UnimplementedError();
    }
  }

  static Future<String> getOSdetails() async => Platform.operatingSystem;

  static Future<String> getScreenResolution() async {
    if (Platform.isAndroid) {
      final view = PlatformDispatcher.instance.views.first;
      final screenwidth = view.display.size.width;
      final swidth = screenwidth.toString();
      final screenheight = view.display.size.height;
      final sheight = screenheight.toString();

      return '$swidth × $sheight';
    } else if (Platform.isIOS) {
      return ' ';
    } else {
      throw UnimplementedError();
    }
  }

  static Future<String> getDeviceVersion() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await _deviceinfoplugin.androidInfo;
      return info.version.sdkInt.toString();
    } else if (Platform.isIOS) {
      final info = await _deviceinfoplugin.iosInfo;
      return info.systemVersion;
    } else {
      throw UnimplementedError();
    }
  }

  static Future<String?> initPlatformId() async {
    String androidId;
    String? identifierForVendor;

    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    if (Platform.isAndroid) {
      try {
        androidId = await _androidIdPlugin.getId() ?? '';
        return androidId;
      } on PlatformException {
        androidId = 'Failed to get Android ID';
        return '';
      }
    } else if (Platform.isIOS) {
      try {
        IosDeviceInfo iosInfo = await _deviceinfoplugin.iosInfo;
        identifierForVendor = iosInfo.identifierForVendor;
        return identifierForVendor;
      } on PlatformException {
        identifierForVendor = 'Failed to get identifierForVendor';
        return '';
      }
    } else {
      throw UnimplementedError();
    }
  }
}
