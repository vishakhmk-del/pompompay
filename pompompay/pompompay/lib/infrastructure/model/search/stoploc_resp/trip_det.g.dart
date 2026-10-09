// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_det.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripDet _$TripDetFromJson(Map<String, dynamic> json) => TripDet(
  tripId: json['trip_id'] as String?,
  routeId: json['route_id'] as String?,
  permitId: json['permit_id'] as String?,
  tripNo: (json['trip_no'] as num?)?.toInt(),
  tripName: json['trip_name'] as String?,
  fromStation: (json['from_station'] as num?)?.toInt(),
  toStation: (json['to_station'] as num?)?.toInt(),
  fromStationName: json['from_station_name'] as String?,
  toStationName: json['to_station_name'] as String?,
  startTime: json['start_time'] as String?,
  endTime: json['end_time'] as String?,
  tripStatus: (json['trip_status'] as num?)?.toInt(),
);

Map<String, dynamic> _$TripDetToJson(TripDet instance) => <String, dynamic>{
  'trip_id': instance.tripId,
  'route_id': instance.routeId,
  'permit_id': instance.permitId,
  'trip_no': instance.tripNo,
  'trip_name': instance.tripName,
  'from_station': instance.fromStation,
  'to_station': instance.toStation,
  'from_station_name': instance.fromStationName,
  'to_station_name': instance.toStationName,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'trip_status': instance.tripStatus,
};
