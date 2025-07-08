import 'dart:convert';
import 'dart:developer';

import 'package:pompompay/core/hook/hooks.dart';

class SharedPrefManager {
  //---singleton-----
  SharedPrefManager._internal();
  static SharedPrefManager instance = SharedPrefManager._internal();
  SharedPrefManager factory() {
    return instance;
  }

  //----end singleton
  Future<void> addSharedData(Sharedpref value) async {
    final sharedprefes = await SharedPreferences.getInstance();
    await sharedprefes.setBool(savekeyname, true);
    await sharedprefes.setString('USERID', value.userId ?? '');
    await sharedprefes.setString('NAME', value.name ?? '');
    await sharedprefes.setString('ACCESSTOKEN', value.accessTkn ?? '');
    await sharedprefes.setString('MOBNO', value.mobno ?? '');
  }

  Future<Sharedpref?> getSharedData() async {
    final sharedprefs = await SharedPreferences.getInstance();

    final userid = sharedprefs.getString('USERID') ?? '';

    final name = sharedprefs.getString('NAME') ?? '';

    final accesstkn = sharedprefs.getString('ACCESSTOKEN') ?? '';

    final mobno = sharedprefs.getString('MOBNO') ?? '';

    final valshared = Sharedpref(
      userId: userid,
      name: name,
      accessTkn: accesstkn,
      mobno: mobno,
    );

    return valshared;
  }

  Future<void> setdeviceinfo(Deviceinfo value) async {
    final sharedprefes = await SharedPreferences.getInstance();
    await sharedprefes.setBool(savedeviceinfo, true);
    await sharedprefes.setString('DEVICE', value.phone ?? '');
    await sharedprefes.setString('DEVICEOS', value.phoneos ?? '');
    await sharedprefes.setString('DEVICEID', value.deviceid ?? '');
    // await sharedprefes.setString('DEVICETOKEN', value.devicetoken ?? '');
    await sharedprefes.setString('PLATFORMID', value.androidid ?? '');
    await sharedprefes.setString(
      'SCREENRESOLUTION',
      value.screenresolution ?? '',
    );
    await sharedprefes.setString('DEVICEVERSION', value.osversion ?? '');
    await sharedprefes.setString('PACKAGENAME', value.packagename ?? '');
    await sharedprefes.setString('APPVERSION', value.appversion ?? '');
    await sharedprefes.setString('BUILDNUMBER', value.buildnumber ?? '');
  }

  Future<Deviceinfo> getdeviceinfo() async {
    final sharedprefs = await SharedPreferences.getInstance();
    bool checkValue = sharedprefs.containsKey('DEVICE');
    log('$checkValue');
    final device = sharedprefs.getString('DEVICE') ?? '';
    final deviceos = sharedprefs.getString('DEVICEOS') ?? '';
    final deviceid = sharedprefs.getString('DEVICEID') ?? '';
    // final devicetkn = sharedprefs.getString('DEVICETOKEN') ?? '';
    final platformid = sharedprefs.getString('PLATFORMID') ?? '';
    final screenres = sharedprefs.getString('SCREENRESOLUTION') ?? '';
    final deviceversion = sharedprefs.getString('DEVICEVERSION') ?? '';
    final packagename = sharedprefs.getString('PACKAGENAME') ?? '';
    final appversion = sharedprefs.getString('APPVERSION') ?? '';
    final buildno = sharedprefs.getString('BUILDNUMBER') ?? '';

    final infoshared = Deviceinfo(
      phone: device,
      phoneos: deviceos,
      deviceid: deviceid,
      // devicetoken: devicetkn,
      androidid: platformid,
      screenresolution: screenres,
      osversion: deviceversion,
      packagename: packagename,
      appversion: appversion,
      buildnumber: buildno,
    );

    return infoshared;
  }

  Future<void> setdeviceTkn(Deviceinfo value) async {
    final sharedprefes = await SharedPreferences.getInstance();
    await sharedprefes.setBool(savedevicetkn, true);
    await sharedprefes.setString('DEVICETOKEN', value.devicetoken ?? '');
  }

  Future<Deviceinfo> getdeviceTkn() async {
    final sharedprefs = await SharedPreferences.getInstance();
    final devicetkn = sharedprefs.getString('DEVICETOKEN') ?? '';
    final tkn = Deviceinfo(devicetoken: devicetkn);
    return tkn;
  }
  // Save a search request (recent search)
Future<void> saveRecentSearch(Farereq request) async {
  final prefs = await SharedPreferences.getInstance();
  final List<String> existingList =
      prefs.getStringList('recent_searches') ?? [];

  final String jsonRequest = jsonEncode(request.toJson());

  // Avoid duplicates
  if (!existingList.contains(jsonRequest)) {
    existingList.insert(0, jsonRequest);
    if (existingList.length > 5) {
      existingList.removeLast(); // Keep only last 5 searches
    }
  }

  await prefs.setStringList('recent_searches', existingList);
}

// Load recent searches
Future<List<Farereq>> loadRecentSearches() async {
  final prefs = await SharedPreferences.getInstance();
  final List<String> jsonList = prefs.getStringList('recent_searches') ?? [];

  return jsonList.map((jsonStr) {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
    return Farereq.fromJson(jsonMap);
  }).toList();
}

}
