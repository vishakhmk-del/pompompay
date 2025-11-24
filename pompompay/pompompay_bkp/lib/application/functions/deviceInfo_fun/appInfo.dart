import 'package:package_info_plus/package_info_plus.dart';

class Appinfo {
  static Future<String> getpackageName() async {
    final packageinfo = await PackageInfo.fromPlatform();
    return packageinfo.packageName;
  }

  static Future<String> getappVersion() async {
    final packageinfo = await PackageInfo.fromPlatform();
    return '${packageinfo.version} + ${packageinfo.buildNumber}';
  }
}
