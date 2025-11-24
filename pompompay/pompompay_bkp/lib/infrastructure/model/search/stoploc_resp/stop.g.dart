// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stop _$StopFromJson(Map<String, dynamic> json) => Stop(
  stopName: json['stop_name'] as String?,
  latitude: json['latitude'] as String?,
  longitude: json['longitude'] as String?,
  arrivingTime: json['arriving_time'] as String?,
);

Map<String, dynamic> _$StopToJson(Stop instance) => <String, dynamic>{
  'stop_name': instance.stopName,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'arriving_time': instance.arrivingTime,
};
