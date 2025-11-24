// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataVal _$DataValFromJson(Map<String, dynamic> json) => DataVal(
  busdetails:
      json['busdetails'] == null
          ? null
          : Busdetails.fromJson(json['busdetails'] as Map<String, dynamic>),
  stopsdetails:
      (json['stopsdetails'] as List<dynamic>?)
          ?.map((e) => Stopsdetail.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$DataValToJson(DataVal instance) => <String, dynamic>{
  'busdetails': instance.busdetails,
  'stopsdetails': instance.stopsdetails,
};
