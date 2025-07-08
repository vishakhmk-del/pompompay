// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataList _$DataListFromJson(Map<String, dynamic> json) => DataList(
  stops:
      (json['stops'] as List<dynamic>?)
          ?.map((e) => Stop.fromJson(e as Map<String, dynamic>))
          .toList(),
  busLocation:
      json['bus_location'] == null
          ? null
          : BusLocation.fromJson(json['bus_location'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DataListToJson(DataList instance) => <String, dynamic>{
  'stops': instance.stops,
  'bus_location': instance.busLocation,
};
