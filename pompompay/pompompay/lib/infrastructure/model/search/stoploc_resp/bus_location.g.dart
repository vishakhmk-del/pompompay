// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusLocation _$BusLocationFromJson(Map<String, dynamic> json) => BusLocation(
  busId: json['bus_id'] as String?,
  latitude: json['latitude'] as String?,
  longitude: json['longitude'] as String?,
  date: json['date'] as String?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$BusLocationToJson(BusLocation instance) =>
    <String, dynamic>{
      'bus_id': instance.busId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'date':instance.date,
      'created_at': instance.createdAt,
    };
