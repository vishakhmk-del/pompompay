import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'calculate_fare.g.dart';

@JsonSerializable()
class CalculateFare {
  String? status;
  String? message;
  DataValue? data;

  CalculateFare({this.status, this.message, this.data});

  factory CalculateFare.fromJson(Map<String, dynamic> json) {
    return _$CalculateFareFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CalculateFareToJson(this);
}
