import 'package:json_annotation/json_annotation.dart';
import 'package:pompompay/infrastructure/model/search/stoploc_resp/bus.dart';

import 'bus_location.dart';
import 'stop.dart';

part 'data.g.dart';

@JsonSerializable()
class DataList {
  List<Stop>? stops;
  @JsonKey(name: 'bus_location')
  BusLocation? busLocation;
  @JsonKey(name: 'bus')
  BusValue? bus;

  DataList({this.stops, this.busLocation,this.bus});

  factory DataList.fromJson(Map<String, dynamic> json) =>
      _$DataListFromJson(json);

  Map<String, dynamic> toJson() => _$DataListToJson(this);
}
