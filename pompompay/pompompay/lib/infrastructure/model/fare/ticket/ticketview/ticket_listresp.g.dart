// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_listresp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketFetch _$TicketFetchFromJson(Map<String, dynamic> json) => TicketFetch(
  status: json['status'] as String?,
  message: json['message'] as String?,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => Ticketview.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$TicketFetchToJson(TicketFetch instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
