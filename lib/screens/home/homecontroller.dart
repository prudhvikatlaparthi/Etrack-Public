import 'package:e_track/models/employee_attendance.dart';
import 'package:e_track/models/internal/date.dart';
import 'package:e_track/network/api_service.dart';
import 'package:e_track/utils/global.dart';
import 'package:e_track/utils/storagebox.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../utils/location_service.dart';
import '../../utils/strings.dart';

class HomeController extends GetxController {
  final Rx<Date> _date = Rx<Date>(Date(time: '', day: '', date: ''));
  final Rx<PackageInfo> _info = Rx<PackageInfo>(PackageInfo(
      appName: '',
      packageName: '',
      version: '',
      buildNumber: '',
      buildSignature: '',
      installerStore: ''));
  final isSyncing = false.obs;
  final inOutDetails = Rx<EmployeeAttendance>(EmployeeAttendance());

  Future<void> initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    _info.value = info;
  }

  @override
  void onInit() {
    callDate();
    super.onInit();
  }

  var clockTimer = 60 - DateTime.now().second;

  void callDate() {
    final date = getDate();
    _date.value = date;
    kPrintLog(clockTimer);
    Future.delayed(Duration(seconds: clockTimer), () {
      clockTimer = 60;
      callDate();
    });
  }

  Date getDateValue() => _date.value;

  PackageInfo getInfoValue() => _info.value;

  Future<void> checkSync() async {
    bool sync = await isLocationServiceRunning();
    isSyncing.value = sync;
  }

  void retrieveLatLng() async {
    final hasPermission = await handleLocationPermission(false);
    if (!hasPermission) return;
    showLoader();
    LatLng? position = await getCurrentPosition();
    kPrintLog("Sign In ${position?.latitude} ${position?.longitude}");
    if (inOutDetails.value.checkInTime?.isNotNullOrEmpty == true) {
      // sign out
      await stopLocationService();
      await signInOut(position);
    } else {
      // sign in
      await signInOut(position);
    }
  }

  Future<void> getAttendanceDetails() async {
    try {
      showLoader();
      final response = await ApiService.instance
          .request('etrack/my_attendance', DioMethod.get, param: {
        'user_id': StorageBox.instance.getUserId(),
        'employee_id': StorageBox.instance.getUserId(),
        'device_token': StorageBox.instance.getDeviceID(),
        'user_type': StorageBox.instance.getUserType(),
      });
      dismissLoader();
      if (response.statusCode == 200) {
        if (response.data['status'] == true) {
          final EmployeeAttendance empAtt =
              EmployeeAttendance.fromJson(response.data['data']);
          inOutDetails.value = empAtt;
          kPrintLog(empAtt.deviceInfo?.imei);
          await StorageBox.instance.setImei(empAtt.deviceInfo?.imei);
          if (empAtt.checkOutTime.isNullOrEmpty) {
            if (!await isLocationServiceRunning()) {
              await Future.delayed(const Duration(seconds: 5));
              startLocationService();
            }
          }
        } else {
          inOutDetails.value = EmployeeAttendance();
          // showToast(message: response.data['message']);
        }
      } else {
        showToast(message: response.statusMessage ?? networkErrorMsg);
        inOutDetails.value = EmployeeAttendance();
      }
    } catch (e) {
      dismissLoader();
      showToast(message: e.toString());
    }
  }

  Future<void> signInOut(LatLng? position) async {
    if (position == null) return;
    String endUrl;
    Map<String, double> payload;
    if (inOutDetails.value.checkInTime?.isNotNullOrEmpty == true) {
      endUrl = 'user_attendance_out';
      payload = {
        'check_out_latitude': position.latitude,
        'check_out_longitude': position.longitude,
      };
    } else {
      endUrl = 'user_attendance_in';
      payload = {
        'check_in_latitude': position.latitude,
        'check_in_longitude': position.longitude,
      };
    }

    try {
      final response = await ApiService.instance
          .request('etrack/$endUrl', DioMethod.post, formData: {
        'user_id': StorageBox.instance.getUserId(),
        'employee_id': StorageBox.instance.getUserId(),
        'device_token': StorageBox.instance.getDeviceID(),
        'user_type': StorageBox.instance.getUserType(),
        ...payload
      });
      dismissLoader();
      if (response.statusCode == 200) {
        if (response.data['status'] == true) {
          getAttendanceDetails();
        } else {
          showToast(message: response.data['message']);
        }
      } else {
        showToast(message: response.statusMessage ?? networkErrorMsg);
      }
    } catch (e) {
      dismissLoader();
      showToast(message: e.toString());
    }
  }
}
