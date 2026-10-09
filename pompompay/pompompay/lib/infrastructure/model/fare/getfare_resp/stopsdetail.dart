import 'package:json_annotation/json_annotation.dart';

part 'stopsdetail.g.dart';

@JsonSerializable()
class Stopsdetail {
  @JsonKey(name: 'stop_name')
  String? stopName;
  @JsonKey(name: 'stop_id')
  dynamic stopId;

  Stopsdetail({this.stopName, this.stopId});

  factory Stopsdetail.fromJson(Map<String, dynamic> json) {
    return _$StopsdetailFromJson(json);
  }

  Map<String, dynamic> toJson() => _$StopsdetailToJson(this);
}
