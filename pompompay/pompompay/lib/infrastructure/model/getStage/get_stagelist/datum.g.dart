// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
  stopName: json['stop_name'] as String?,
  stopId: (json['stop_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
  'stop_name': instance.stopName,
  'stop_id': instance.stopId,
};
