import 'package:json_annotation/json_annotation.dart';
import 'package:pompompay/infrastructure/model/search/stoploc_resp/bus_location.dart';

part 'data.g.dart';

@JsonSerializable()
class Datalive {
  @JsonKey(name: 'bus_id')
  String? busId;
  String? latitude;
  String? longitude;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'modify_by')
  String? modifyBy;
  @JsonKey(name: 'bus_location')
  BusLocation? busLocation;
  Datalive({
    this.busId,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.modifyBy,
    this.busLocation
  });

  factory Datalive.fromJson(Map<String, dynamic> json) => _$DataliveFromJson(json);

  Map<String, dynamic> toJson() => _$DataliveToJson(this);
}
