// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_conductor_tkt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QrConductorTkt _$QrConductorTktFromJson(Map<String, dynamic> json) =>
    QrConductorTkt(
      type: json['type'] as String?,
      data: json['data'] == null
          ? null
          : DataQrTkt.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QrConductorTktToJson(QrConductorTkt instance) =>
    <String, dynamic>{'type': instance.type, 'data': instance.data};
