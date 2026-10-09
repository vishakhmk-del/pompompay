// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculate_fare.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalculateFare _$CalculateFareFromJson(Map<String, dynamic> json) =>
    CalculateFare(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : DataValue.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CalculateFareToJson(CalculateFare instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
