// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stoploc_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoplocResp _$StoplocRespFromJson(Map<String, dynamic> json) => StoplocResp(
  status: json['status'] as String?,
  message: json['message'] as String?,
  data:
      json['data'] == null
          ? null
          : DataList.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StoplocRespToJson(StoplocResp instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
