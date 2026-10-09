import 'package:json_annotation/json_annotation.dart';

part 'trip_det.g.dart';

@JsonSerializable()
class TripDet {
  @JsonKey(name: 'trip_id')
  String? tripId;
  @JsonKey(name: 'route_id')
  String? routeId;
  @JsonKey(name: 'permit_id')
  String? permitId;
  @JsonKey(name: 'trip_no')
  int? tripNo;
  @JsonKey(name: 'trip_name')
  String? tripName;
  @JsonKey(name: 'from_station')
  int? fromStation;
  @JsonKey(name: 'to_station')
  int? toStation;
  @JsonKey(name: 'from_station_name')
  String? fromStationName;
  @JsonKey(name: 'to_station_name')
  String? toStationName;
  @JsonKey(name: 'start_time')
  String? startTime;
  @JsonKey(name: 'end_time')
  String? endTime;
  @JsonKey(name: 'trip_status')
  int? tripStatus;

  TripDet({
    this.tripId,
    this.routeId,
    this.permitId,
    this.tripNo,
    this.tripName,
    this.fromStation,
    this.toStation,
    this.fromStationName,
    this.toStationName,
    this.startTime,
    this.endTime,
    this.tripStatus,
  });

  factory TripDet.fromJson(Map<String, dynamic> json) {
    return _$TripDetFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TripDetToJson(this);
}
