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

  Stop({this.stopName, this.latitude, this.longitude, this.arrivingTime});

  factory Stop.fromJson(Map<String, dynamic> json) => _$StopFromJson(json);

  Map<String, dynamic> toJson() => _$StopToJson(this);
}
