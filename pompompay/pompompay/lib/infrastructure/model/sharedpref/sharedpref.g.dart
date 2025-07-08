// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharedpref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sharedpref _$SharedprefFromJson(Map<String, dynamic> json) => Sharedpref(
  userId: json['user_id'] as String?,
  accessTkn: json['access_token'] as String?,
  name: json['name'] as String?,
  mobno: json['mobno'] as String?,
);

Map<String, dynamic> _$SharedprefToJson(Sharedpref instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'access_token': instance.accessTkn,
      'name': instance.name,
      'mobno': instance.mobno,
    };
