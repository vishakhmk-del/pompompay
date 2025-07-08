import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class DataValue {
  @JsonKey(name: 'total_fare')
  String? totalFare;
  @JsonKey(name: 'adult_fare')
  String? adultFare;
  @JsonKey(name: 'kids_fare')
  String? kidsFare;
  @JsonKey(name: 'student_fare')
  String? studentFare;
  @JsonKey(name: 'handicapped_fare')
  String? handicappedFare;
  @JsonKey(name: 'owner_upid')
  String? ownerUpid;
  String? owner;
  @JsonKey(name: 'unit_adult_fare')
  String? singleadult;
  @JsonKey(name: 'unit_kids_fare')
  String? singlekid;
  @JsonKey(name: 'unit_student_fare')
  String? singlestud;

  DataValue({
    this.totalFare,
    this.adultFare,
    this.kidsFare,
    this.studentFare,
    this.handicappedFare,
    this.ownerUpid,
    this.owner,
    this.singleadult,
    this.singlekid,
    this.singlestud,
  });

  factory DataValue.fromJson(Map<String, dynamic> json) =>
      _$DataValueFromJson(json);

  Map<String, dynamic> toJson() => _$DataValueToJson(this);
}
