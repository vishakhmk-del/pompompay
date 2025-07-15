// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Datalive _$DataliveFromJson(Map<String, dynamic> json) => Datalive(
  busLocation:
      json['bus_location'] == null
          ? null
          : BusLocation.fromJson(json['bus_location'] as Map<String, dynamic>),
  busId: json['bus_id'] as String?,
  latitude: json['latitude'] as String?,
  longitude: json['longitude'] as String?,
  createdAt: json['created_at'] as String?,
  modifyBy: json['modify_by'] as String?,
   
);

Map<String, dynamic> _$DataliveToJson(Datalive instance) => <String, dynamic>{
  'bus_location':instance.busLocation,
  'bus_id': instance.busId,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'created_at': instance.createdAt,
  'modify_by': instance.modifyBy,
  
};
