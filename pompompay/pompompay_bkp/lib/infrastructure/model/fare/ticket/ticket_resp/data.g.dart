// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Datatkt _$DatatktFromJson(Map<String, dynamic> json) => Datatkt(
  ticketNo: json['ticket_no'] as String?,
  seatno: json['seatno'] as String?,
  busid: json['busid'] as String?,
  dot: json['dot'] as String?,
);

Map<String, dynamic> _$DatatktToJson(Datatkt instance) => <String, dynamic>{
  'ticket_no': instance.ticketNo,
  'seatno': instance.seatno,
  'busid': instance.busid,
  'dot': instance.dot,
};
