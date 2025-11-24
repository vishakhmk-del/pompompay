import 'package:json_annotation/json_annotation.dart';

part 'bus.g.dart';

@JsonSerializable()
class BusValue {
  @JsonKey(name: 'bus_id')
  String? busId;
  @JsonKey(name: 'from_station')
  String? fromStation;
  @JsonKey(name: 'to_station')
  String? toStation;
  @JsonKey(name: 'start_time')
  String? startTime;
  @JsonKey(name: 'end_time')
  String? endTime;
  @JsonKey(name: 'bus_name')
  String? busName;
  @JsonKey(name: 'bus_type')
  String? busType;
  @JsonKey(name: 'registration_no')
  String? registrationNo;

  BusValue({
    this.busId,
    this.fromStation,
    this.toStation,
    this.startTime,
    this.endTime,
    this.busName,
    this.busType,
    this.registrationNo,
  });

  factory BusValue.fromJson(Map<String, dynamic> json) => _$BusValueFromJson(json);

  Map<String, dynamic> toJson() => _$BusValueToJson(this);
}
