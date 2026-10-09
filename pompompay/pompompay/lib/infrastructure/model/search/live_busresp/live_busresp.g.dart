// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_busresp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveBusresp _$LiveBusrespFromJson(Map<String, dynamic> json) => LiveBusresp(
  status: json['status'] as String?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : Datalive.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LiveBusrespToJson(LiveBusresp instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
