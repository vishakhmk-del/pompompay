import 'package:json_annotation/json_annotation.dart';

part 'ticketview.g.dart';

@JsonSerializable()
class Ticketview {
  @JsonKey(name: 'tiket_no')
  String? tiketNo;
  @JsonKey(name: 'bus_id')
  String? busId;
  @JsonKey(name: 'trip_id')
  String? tripId;
  String? seatno;
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'from_place')
  String? fromPlace;
  @JsonKey(name: 'to_place')
  String? toPlace;
  String? adults;
  String? student;
  String? kids;
  String? handicapped;
  @JsonKey(name: 'travel_date')
  String? travelDate;
  @JsonKey(name: 'travel_time')
  String? travelTime;
  String? amount;
  @JsonKey(name: 'pay_mode')
  String? payMode;
  String? status;
  @JsonKey(name: 'sp_type')
  dynamic spType;
  @JsonKey(name: 'sp_count')
  dynamic spCount;
  @JsonKey(name: 'sp_amount')
  dynamic spAmount;
  dynamic discount;
  @JsonKey(name: 'ticket_status')
  String? ticketStatus;
  @JsonKey(name: 'bus_name')
  String? busName;
  @JsonKey(name: 'registration_no')
  String? registrationNo;
  @JsonKey(name: 'start_time')
  String? startTime;
  @JsonKey(name: 'end_time')
  String? endTime;
  @JsonKey(name: 'trans_id')
  String? transactionId;
  @JsonKey(name: 'phone_no')
  String? phoneno;
  @JsonKey(name: 'route_name')
  String? routename;
  @JsonKey(name: 'unit_adult_fare')
  String? singleadult;
  @JsonKey(name: 'unit_kids_fare')
  String? singlekids;
  @JsonKey(name: 'unit_student_fare')
  String? singlestudent;
  @JsonKey(name: 'unit_handicapped_fare')
  String? singlehandicapped;
  @JsonKey(name: 'adult_fare')
  String? adultfare;
  @JsonKey(name: 'kids_fare')
  String? kidsfare;
  @JsonKey(name: 'student_fare')
  String? studentfare;
  @JsonKey(name: 'handicapped_fare')
  String? handicappedfare;
  @JsonKey(name: 'totalfare')
  String? totalfare;

  Ticketview({
    this.tiketNo,
    this.busId,
    this.tripId,
    this.seatno,
    this.userId,
    this.fromPlace,
    this.toPlace,
    this.adults,
    this.student,
    this.kids,
    this.handicapped,
    this.travelDate,
    this.travelTime,
    this.amount,
    this.payMode,
    this.status,
    this.spType,
    this.spCount,
    this.spAmount,
    this.discount,
    this.ticketStatus,
    this.busName,
    this.registrationNo,
    this.startTime,
    this.endTime,
    this.transactionId,
    this.routename,
    this.phoneno,
    this.singleadult,
    this.singlekids,
    this.singlestudent,
    this.singlehandicapped,
    this.totalfare,
    this.adultfare,
    this.kidsfare,
    this.handicappedfare,
    this.studentfare,
  });

  factory Ticketview.fromJson(Map<String, dynamic> json) {
    return _$TicketviewFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TicketviewToJson(this);
}
