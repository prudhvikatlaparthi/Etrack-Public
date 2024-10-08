import 'package:json_annotation/json_annotation.dart';

part 'device_info.g.dart';

@JsonSerializable()
class DeviceInfo {
  @JsonKey(name: 'device_link_id')
  final String? deviceLinkId;

  @JsonKey(name: 'imei')
  final String? imei;

  @JsonKey(name: 'device_id')
  final String? deviceId;

  @JsonKey(name: 'vehicle_image')
  final String? vehicleImage;

  @JsonKey(name: 'vehicle_number')
  final String? vehicleNumber;

  @JsonKey(name: 'user_device_trans_id')
  final String? userDeviceTransId;

  @JsonKey(name: 'latitude')
  final String? latitude;

  @JsonKey(name: 'longitude')
  final String? longitude;

  @JsonKey(name: 'speed')
  final String? speed;

  @JsonKey(name: 'devicetime')
  final String? deviceTime;

  @JsonKey(name: 'last_running_time')
  final String? lastRunningTime;

  @JsonKey(name: 'course')
  final String? course;

  @JsonKey(name: 'last_location')
  final String? lastLocation;

  @JsonKey(name: 'last_loc_distance')
  final String? lastLocDistance;

  @JsonKey(name: 'last_area')
  final String? lastArea;

  @JsonKey(name: 'last_district')
  final String? lastDistrict;

  @JsonKey(name: 'last_city')
  final String? lastCity;

  @JsonKey(name: 'last_state')
  final String? lastState;

  @JsonKey(name: 'fixtime')
  final String? fixTime;

  @JsonKey(name: 'latest_loc')
  final String? latestLoc;

  DeviceInfo({
    this.deviceLinkId,
    this.imei,
    this.deviceId,
    this.vehicleImage,
    this.vehicleNumber,
    this.userDeviceTransId,
    this.latitude,
    this.longitude,
    this.speed,
    this.deviceTime,
    this.lastRunningTime,
    this.course,
    this.lastLocation,
    this.lastLocDistance,
    this.lastArea,
    this.lastDistrict,
    this.lastCity,
    this.lastState,
    this.fixTime,
    this.latestLoc,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceInfoToJson(this);
}
