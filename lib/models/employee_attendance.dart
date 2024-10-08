import 'package:e_track/models/device_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employee_attendance.g.dart';

@JsonSerializable()
class EmployeeAttendance {
  @JsonKey(name: 'employee_id')
  final String? employeeId;
  @JsonKey(name: 'user_name')
  final String? userName;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  @JsonKey(name: 'attendance_id')
  final String? attendanceId;
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'check_in_time')
  final String? checkInTime;
  @JsonKey(name: 'check_out_time')
  final String? checkOutTime;
  @JsonKey(name: 'check_in_latitude')
  final String? checkInLatitude;
  @JsonKey(name: 'check_in_longitude')
  final String? checkInLongitude;
  @JsonKey(name: 'check_in_location')
  final String? checkInLocation;
  @JsonKey(name: 'check_out_latitude')
  final String? checkOutLatitude;
  @JsonKey(name: 'check_out_longitude')
  final String? checkOutLongitude;
  @JsonKey(name: 'check_out_location')
  final String? checkOutLocation;
  final String? status;
  @JsonKey(name: 'attendance_date')
  final String? attendanceDate;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'device_info')
  final DeviceInfo? deviceInfo;

  EmployeeAttendance({
    this.employeeId,
    this.userName,
    this.firstName,
    this.lastName,
    this.attendanceId,
    this.userId,
    this.checkInTime,
    this.checkOutTime,
    this.checkInLatitude,
    this.checkInLongitude,
    this.checkInLocation,
    this.checkOutLatitude,
    this.checkOutLongitude,
    this.checkOutLocation,
    this.status,
    this.attendanceDate,
    this.createdAt,
    this.updatedAt,
    this.deviceInfo,
  });

  factory EmployeeAttendance.fromJson(Map<String, dynamic> json) => _$EmployeeAttendanceFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeAttendanceToJson(this);
}
