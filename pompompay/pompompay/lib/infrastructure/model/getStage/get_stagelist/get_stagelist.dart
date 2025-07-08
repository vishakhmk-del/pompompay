import 'package:json_annotation/json_annotation.dart';

import 'datum.dart';

part 'get_stagelist.g.dart';

@JsonSerializable()
class GetStagelist {
  String? status;
  String? message;
  List<Datum>? data;

  GetStagelist({this.status, this.message, this.data});

  factory GetStagelist.fromJson(Map<String, dynamic> json) {
    return _$GetStagelistFromJson(json);
  }

  Map<String, dynamic> toJson() => _$GetStagelistToJson(this);
}
