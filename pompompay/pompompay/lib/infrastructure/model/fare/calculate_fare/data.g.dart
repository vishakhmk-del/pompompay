// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataValue _$DataValueFromJson(Map<String, dynamic> json) => DataValue(
  totalFare: json['total_fare'] as String?,
  adultFare: json['adult_fare'] as String?,
  kidsFare: json['kids_fare'] as String?,
  studentFare: json['student_fare'] as String?,
  handicappedFare: json['handicapped_fare'] as String?,
  ownerUpid: json['owner_upid'] as String?,
  owner: json['owner'] as String?,
  singleadult: json['unit_adult_fare'] as String?,
  singlekid: json['unit_kids_fare'] as String?,
  singlestud: json['unit_student_fare'] as String?,
);

Map<String, dynamic> _$DataValueToJson(DataValue instance) => <String, dynamic>{
  'total_fare': instance.totalFare,
  'adult_fare': instance.adultFare,
  'kids_fare': instance.kidsFare,
  'student_fare': instance.studentFare,
  'handicapped_fare': instance.handicappedFare,
  'owner_upid': instance.ownerUpid,
  'owner': instance.owner,
  'unit_adult_fare': instance.singleadult,
  'unit_kids_fare': instance.singlekid,
  'unit_student_fare': instance.singlestud,
};
