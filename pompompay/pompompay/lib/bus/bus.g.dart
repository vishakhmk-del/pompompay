// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bus _$BusFromJson(Map<String, dynamic> json) => Bus(
  busId: json['bus_id'] as String?,
  fromStation: json['from_station'] as String?,
  toStation: json['to_station'] as String?,
  startTime: json['start_time'] as String?,
  endTime: json['end_time'] as String?,
  busName: json['bus_name'] as String?,
  busType: json['bus_type'] as String?,
  registrationNo: json['registration_no'] as String?,
);

Map<String, dynamic> _$BusToJson(Bus instance) => <String, dynamic>{
  'bus_id': instance.busId,
  'from_station': instance.fromStation,
  'to_station': instance.toStation,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'bus_name': instance.busName,
  'bus_type': instance.busType,
  'registration_no': instance.registrationNo,
};
