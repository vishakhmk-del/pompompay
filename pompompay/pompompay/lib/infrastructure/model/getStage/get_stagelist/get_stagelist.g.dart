// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_stagelist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetStagelist _$GetStagelistFromJson(Map<String, dynamic> json) => GetStagelist(
  status: json['status'] as String?,
  message: json['message'] as String?,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$GetStagelistToJson(GetStagelist instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
