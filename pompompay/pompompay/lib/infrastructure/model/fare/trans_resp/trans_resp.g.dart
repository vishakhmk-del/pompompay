// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trans_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransResp _$TransRespFromJson(Map<String, dynamic> json) => TransResp(
  status: json['status'] as String?,
  code: json['code'] as String?,
  message: json['message'] as String?,
  response: json['response'] == null
      ? null
      : TransResponse.fromJson(json['response'] as Map<String, dynamic>),
  data: json['data'] == null
      ? null
      : Transactionresp.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TransRespToJson(TransResp instance) => <String, dynamic>{
  'status': instance.status,
  'code': instance.code,
  'message': instance.message,
  'response': instance.response,
  'data': instance.data,
};
