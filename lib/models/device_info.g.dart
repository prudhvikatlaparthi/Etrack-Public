// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) => DeviceInfo(
      deviceLinkId: json['device_link_id'] as String?,
      imei: json['imei'] as String?,
      deviceId: json['device_id'] as String?,
      vehicleImage: json['vehicle_image'] as String?,
      vehicleNumber: json['vehicle_number'] as String?,
      userDeviceTransId: json['user_device_trans_id'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      speed: json['speed'] as String?,
      deviceTime: json['devicetime'] as String?,
      lastRunningTime: json['last_running_time'] as String?,
      course: json['course'] as String?,
      lastLocation: json['last_location'] as String?,
      lastLocDistance: json['last_loc_distance'] as String?,
      lastArea: json['last_area'] as String?,
      lastDistrict: json['last_district'] as String?,
      lastCity: json['last_city'] as String?,
      lastState: json['last_state'] as String?,
      fixTime: json['fixtime'] as String?,
      latestLoc: json['latest_loc'] as String?,
    );

Map<String, dynamic> _$DeviceInfoToJson(DeviceInfo instance) =>
    <String, dynamic>{
      'device_link_id': instance.deviceLinkId,
      'imei': instance.imei,
      'device_id': instance.deviceId,
      'vehicle_image': instance.vehicleImage,
      'vehicle_number': instance.vehicleNumber,
      'user_device_trans_id': instance.userDeviceTransId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'speed': instance.speed,
      'devicetime': instance.deviceTime,
      'last_running_time': instance.lastRunningTime,
      'course': instance.course,
      'last_location': instance.lastLocation,
      'last_loc_distance': instance.lastLocDistance,
      'last_area': instance.lastArea,
      'last_district': instance.lastDistrict,
      'last_city': instance.lastCity,
      'last_state': instance.lastState,
      'fixtime': instance.fixTime,
      'latest_loc': instance.latestLoc,
    };
