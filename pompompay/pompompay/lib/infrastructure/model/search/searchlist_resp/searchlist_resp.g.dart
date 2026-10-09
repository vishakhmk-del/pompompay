// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'searchlist_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchlistResp _$SearchlistRespFromJson(Map<String, dynamic> json) =>
    SearchlistResp(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datumlist.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchlistRespToJson(SearchlistResp instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
