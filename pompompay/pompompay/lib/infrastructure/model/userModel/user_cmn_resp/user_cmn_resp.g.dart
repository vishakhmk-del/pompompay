// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_cmn_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCmnResp _$UserCmnRespFromJson(Map<String, dynamic> json) => UserCmnResp(
  status: json['status'] as String?,
  message: json['message'] as String?,
  data:
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserCmnRespToJson(UserCmnResp instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
