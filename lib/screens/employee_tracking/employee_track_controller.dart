import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/employee_attendance.dart';
import '../../network/api_service.dart';
import '../../utils/global.dart';
import '../../utils/storagebox.dart';
import '../../utils/strings.dart';
import '../common/loader.dart';

class EmployeeTrackController extends GetxController {
  final double mapZoom = 14.4746;

  final Completer<GoogleMapController> mapController = Completer<
      GoogleMapController>();
  final Rx<CameraPosition> googlePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  ).obs;
  final inOutDetails = Rx<EmployeeAttendance>(EmployeeAttendance());

  Future<void> getAttendanceDetails(String empId) async {
    try {
      showLoader();
      final response = await ApiService.instance
          .request('etrack/my_attendance', DioMethod.get, param: {
        'user_id': StorageBox.instance.getUserId(),
        'employee_id': empId,
        'device_token': StorageBox.instance.getDeviceID(),
        'user_type': 'Employee',
      });
      dismissLoader();
      if (response.statusCode == 200) {
        if (response.data['status'] == true) {
          final EmployeeAttendance empAtt =
          EmployeeAttendance.fromJson(response.data['data']);
          inOutDetails.value = empAtt;
          kPrintLog(empAtt);
          if (empAtt.checkInLatitude.isNotNullOrEmpty &&
              empAtt.checkInLongitude.isNotNullOrEmpty) {
            googlePlex.value = CameraPosition(
              target: LatLng(double.parse(empAtt.checkInLatitude!),
                  double.parse(empAtt.checkInLongitude!)),
              zoom: mapZoom,
            );
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

}