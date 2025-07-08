import 'package:json_annotation/json_annotation.dart';

part 'fare_req.g.dart';

@JsonSerializable()
class FareReq {
  String? busidNo;

  FareReq({this.busidNo});

  factory FareReq.fromJson(Map<String, dynamic> json) {
    return _$FareReqFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FareReqToJson(this);
}
