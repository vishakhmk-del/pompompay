import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'stoploc_resp.g.dart';

@JsonSerializable()
class StoplocResp {
  String? status;
  String? message;
  DataList? data;

  StoplocResp({this.status, this.message, this.data});

  factory StoplocResp.fromJson(Map<String, dynamic> json) {
    return _$StoplocRespFromJson(json);
  }

  Map<String, dynamic> toJson() => _$StoplocRespToJson(this);
}
