import 'package:json_annotation/json_annotation.dart';

import 'busdetails.dart';
import 'stopsdetail.dart';

part 'data.g.dart';

@JsonSerializable()
class DataVal {
  Busdetails? busdetails;
  List<Stopsdetail>? stopsdetails;

  DataVal({this.busdetails, this.stopsdetails});

  factory DataVal.fromJson(Map<String, dynamic> json) =>
      _$DataValFromJson(json);

  Map<String, dynamic> toJson() => _$DataValToJson(this);
}
