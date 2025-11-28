import 'package:json_annotation/json_annotation.dart';

part 'bus_location.g.dart';

@JsonSerializable()
class BusLocation {
  @JsonKey(name: 'bus_id')
  String? busId;
  String? latitude;
  String? longitude;
  @JsonKey(name: 'date')
  String? date;
  @JsonKey(name: 'created_at')
  String? createdAt;

  BusLocation({this.busId, this.latitude, this.longitude,this.date, this.createdAt});

  factory BusLocation.fromJson(Map<String, dynamic> json) {
    return _$BusLocationFromJson(json);
  }

  Map<String, dynamic> toJson() => _$BusLocationToJson(this);
}
