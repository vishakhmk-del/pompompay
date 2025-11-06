// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farereq.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Farereq _$FarereqFromJson(Map<String, dynamic> json) => Farereq(
  tripId: json['trip_id'] as String?,
  busId: json['bus_id'] as String?,
  busidNo: json['busid'] as String?,
  from: json['from'] as String?,
  to: json['to'] as String?,
  adults: json['adults'] as String?,
  stud: json['stud'] as String?,
  handi: json['handi'] as String?,
  kids: json['kids'] as String?,
  seatno: json['seatno'] as String?,
  userId: json['user_id'] as String?,
  orderId: json['order_id'] as String?,
  ticketstatus: json['ticket_status'],
  startTime: json['start_time'],
  endTime: json['end_time'],
  fromPlace: json['from_place'],
  toPlace: json['to_place'],
  type: json['type'] as String?,
  flag: json['flag'] as String?,
  crntDt: json['crntDt'] as String?,
  crntTm: json['crntTm'] as String?,
  status: json['status'],
);

Map<String, dynamic> _$FarereqToJson(Farereq instance) => <String, dynamic>{
  'trip_id': instance.tripId,
  'bus_id': instance.busId,
  'busid': instance.busidNo,
  'from': instance.from,
  'to': instance.to,
  'adults': instance.adults,
  'stud': instance.stud,
  'handi': instance.handi,
  'kids': instance.kids,
  'seatno': instance.seatno,
  'user_id': instance.userId,
  'order_id': instance.orderId,
  'ticket_status': instance.ticketstatus,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'from_place': instance.fromPlace,
  'to_place': instance.toPlace,
  'type': instance.type,
  'flag': instance.flag,
  'crntDt': instance.crntDt,
  'crntTm': instance.crntTm,
  'status': instance.status,
};
