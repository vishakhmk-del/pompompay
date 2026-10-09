// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TktData _$TktDataFromJson(Map<String, dynamic> json) => TktData(
  tktlist: (json['tktlist'] as List<dynamic>?)
      ?.map((e) => Ticketview.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TktDataToJson(TktData instance) => <String, dynamic>{
  'tktlist': instance.tktlist,
};
