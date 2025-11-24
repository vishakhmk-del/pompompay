// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deviceinfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Deviceinfo _$DeviceinfoFromJson(Map<String, dynamic> json) => Deviceinfo(
  userId: json['userId'],
  userid: json['user_id'],
  phone: json['phone'] as String?,
  devicetoken: json['devicetoken'] as String?,
  deviceid: json['deviceid'] as String?,
  phoneos: json['phoneos'] as String?,
  screenresolution: json['screenresolution'] as String?,
  androidid: json['androidid'] as String?,
  osversion: json['osversion'] as String?,
  packagename: json['packagename'] as String?,
  appversion: json['appversion'] as String?,
  buildnumber: json['buildnumber'] as String?,
);

Map<String, dynamic> _$DeviceinfoToJson(Deviceinfo instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'user_id':instance.userid,
      'phone': instance.phone,
      'devicetoken': instance.devicetoken,
      'deviceid': instance.deviceid,
      'phoneos': instance.phoneos,
      'screenresolution': instance.screenresolution,
      'androidid': instance.androidid,
      'osversion': instance.osversion,
      'packagename': instance.packagename,
      'appversion': instance.appversion,
      'buildnumber': instance.buildnumber,
    };
