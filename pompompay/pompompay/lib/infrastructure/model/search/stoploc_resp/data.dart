import 'package:json_annotation/json_annotation.dart';

import 'bus_location.dart';
import 'stop.dart';

part 'data.g.dart';

@JsonSerializable()
class DataList {
  List<Stop>? stops;
  @JsonKey(name: 'bus_location')
  BusLocation? busLocation;

  DataList({this.stops, this.busLocation});

  factory DataList.fromJson(Map<String, dynamic> json) =>
      _$DataListFromJson(json);

  Map<String, dynamic> toJson() => _$DataListToJson(this);
}
