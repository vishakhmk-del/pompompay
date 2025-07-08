// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_cmn_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCmnReq _$UserCmnReqFromJson(Map<String, dynamic> json) => UserCmnReq(
  userName: json['user_name'] as String?,
  mobno: json['mobno'] as String?,
  pw: json['pw'] as String?,
  otp: json['otp'] as String?,
  type: json['type'] as String?,
  device: json['device'] as String?,
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

Map<String, dynamic> _$UserCmnReqToJson(UserCmnReq instance) =>
    <String, dynamic>{
      'user_name': instance.userName,
      'mobno': instance.mobno,
      'pw': instance.pw,
      'otp': instance.otp,
      'type': instance.type,
      'device': instance.device,
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
