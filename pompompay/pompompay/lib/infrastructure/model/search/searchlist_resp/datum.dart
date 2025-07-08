import 'package:json_annotation/json_annotation.dart';

part 'datum.g.dart';

@JsonSerializable()
class Datumlist {
  @JsonKey(name: 'bus_id')
  String? busId;
  @JsonKey(name: 'short_name')
  String? shortName;
  @JsonKey(name: 'bus_name')
  String? busName;
  @JsonKey(name: 'registration_no')
  String? registrationNo;
  @JsonKey(name: 'owner_id')
  String? ownerId;
  @JsonKey(name: 'conductor_id')
  String? conductorId;
  @JsonKey(name: 'driver_id')
  String? driverId;
  @JsonKey(name: 'bus_type')
  String? busType;
  @JsonKey(name: 'trip_nos')
  dynamic tripNos;
  @JsonKey(name: 'active_trip')
  String? activeTrip;
  @JsonKey(name: 'permit_no')
  String? permitNo;
  @JsonKey(name: 'valid_from')
  String? validFrom;
  @JsonKey(name: 'valid_to')
  String? validTo;
  @JsonKey(name: 'created_by')
  String? createdBy;
  @JsonKey(name: 'created_time')
  String? createdTime;
  @JsonKey(name: 'modified_by')
  String? modifiedBy;
  @JsonKey(name: 'modified_date')
  String? modifiedDate;
  @JsonKey(name: 'trip_id')
  String? tripId;
  @JsonKey(name: 'trip_no')
  String? tripNo;
  @JsonKey(name: 'trip_name')
  String? tripName;
  String? via;
  @JsonKey(name: 'from_station')
  String? fromStation;
  @JsonKey(name: 'to_station')
  String? toStation;
  @JsonKey(name: 'start_time')
  String? startTime;
  @JsonKey(name: 'end_time')
  String? endTime;
  @JsonKey(name: 'from_stop')
  String? fromStop;
  @JsonKey(name: 'to_stop')
  String? toStop;
  @JsonKey(name: 'from_arrival')
  String? fromArrival;
  @JsonKey(name: 'to_arrival')
  String? toArrival;
  String? duration;

  Datumlist({
    this.busId,
    this.shortName,
    this.busName,
    this.registrationNo,
    this.ownerId,
    this.conductorId,
    this.driverId,
    this.busType,
    this.tripNos,
    this.activeTrip,
    this.permitNo,
    this.validFrom,
    this.validTo,
    this.createdBy,
    this.createdTime,
    this.modifiedBy,
    this.modifiedDate,
    this.tripId,
    this.tripNo,
    this.tripName,
    this.via,
    this.fromStation,
    this.toStation,
    this.startTime,
    this.endTime,
    this.fromStop,
    this.toStop,
    this.fromArrival,
    this.toArrival,
    this.duration,
  });

  factory Datumlist.fromJson(Map<String, dynamic> json) =>
      _$DatumlistFromJson(json);

  Map<String, dynamic> toJson() => _$DatumlistToJson(this);
}
