import 'package:json_annotation/json_annotation.dart';

part 'stop.g.dart';

@JsonSerializable()
class Stop {
  @JsonKey(name: 'stop_name')
  String? stopName;
  String? latitude;
  String? longitude;
  @JsonKey(name: 'arriving_time')
  String? arrivingTime;
  @JsonKey(name: 'departure_time')
  String? departureTime;
  int? id;
  int? passed;

  Stop({
    this.stopName,
    this.latitude,
    this.longitude,
    this.arrivingTime,
    this.departureTime,
    this.id,
    this.passed,
  });

  factory Stop.fromJson(Map<String, dynamic> json) => _$StopFromJson(json);

  Map<String, dynamic> toJson() => _$StopToJson(this);
}
