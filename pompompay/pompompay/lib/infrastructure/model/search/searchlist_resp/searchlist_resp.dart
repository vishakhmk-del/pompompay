import 'package:json_annotation/json_annotation.dart';

import 'datum.dart';

part 'searchlist_resp.g.dart';

@JsonSerializable()
class SearchlistResp {
  String? status;
  String? message;
  List<Datumlist>? data;

  SearchlistResp({this.status, this.message, this.data});

  factory SearchlistResp.fromJson(Map<String, dynamic> json) {
    return _$SearchlistRespFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SearchlistRespToJson(this);
}
