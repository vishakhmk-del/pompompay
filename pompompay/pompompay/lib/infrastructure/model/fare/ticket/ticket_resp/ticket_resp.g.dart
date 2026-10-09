// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketResp _$TicketRespFromJson(Map<String, dynamic> json) => TicketResp(
  status: json['status'] as String?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : Datatkt.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TicketRespToJson(TicketResp instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
