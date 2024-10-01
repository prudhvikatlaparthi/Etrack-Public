// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeAttendance _$EmployeeAttendanceFromJson(Map<String, dynamic> json) =>
    EmployeeAttendance(
      employeeId: json['employee_id'] as String?,
      userName: json['user_name'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      attendanceId: json['attendance_id'] as String?,
      userId: json['user_id'] as String?,
      checkInTime: json['check_in_time'] as String?,
      checkOutTime: json['check_out_time'] as String?,
      checkInLatitude: json['check_in_latitude'] as String?,
      checkInLongitude: json['check_in_longitude'] as String?,
      checkInLocation: json['check_in_location'] as String?,
      checkOutLatitude: json['check_out_latitude'] as String?,
      checkOutLongitude: json['check_out_longitude'] as String?,
      checkOutLocation: json['check_out_location'] as String?,
      status: json['status'] as String?,
      attendanceDate: json['attendance_date'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$EmployeeAttendanceToJson(EmployeeAttendance instance) =>
    <String, dynamic>{
      'employee_id': instance.employeeId,
      'user_name': instance.userName,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'attendance_id': instance.attendanceId,
      'user_id': instance.userId,
      'check_in_time': instance.checkInTime,
      'check_out_time': instance.checkOutTime,
      'check_in_latitude': instance.checkInLatitude,
      'check_in_longitude': instance.checkInLongitude,
      'check_in_location': instance.checkInLocation,
      'check_out_latitude': instance.checkOutLatitude,
      'check_out_longitude': instance.checkOutLongitude,
      'check_out_location': instance.checkOutLocation,
      'status': instance.status,
      'attendance_date': instance.attendanceDate,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
