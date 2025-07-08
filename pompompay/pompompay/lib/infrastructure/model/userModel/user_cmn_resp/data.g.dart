// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  userId: json['user_id'] as String?,
  name: json['name'] as String?,
  accessToken: json['access_token'] as String?,
  mobno: json['mobno'] as String?,
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'user_id': instance.userId,
  'name': instance.name,
  'access_token': instance.accessToken,
  'mobno': instance.mobno,
};
