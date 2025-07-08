// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'getfare_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetfareResp _$GetfareRespFromJson(Map<String, dynamic> json) => GetfareResp(
  status: json['status'] as String?,
  message: json['message'] as String?,
  data:
      json['data'] == null
          ? null
          : DataVal.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GetfareRespToJson(GetfareResp instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
