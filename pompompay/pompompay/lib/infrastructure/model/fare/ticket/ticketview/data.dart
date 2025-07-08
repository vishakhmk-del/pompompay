import 'package:json_annotation/json_annotation.dart';

import 'ticketview.dart';

part 'data.g.dart';

@JsonSerializable()
class TktData {
  List<Ticketview>? tktlist;

  TktData({this.tktlist});

  factory TktData.fromJson(Map<String, dynamic> json) =>
      _$TktDataFromJson(json);

  Map<String, dynamic> toJson() => _$TktDataToJson(this);
}
