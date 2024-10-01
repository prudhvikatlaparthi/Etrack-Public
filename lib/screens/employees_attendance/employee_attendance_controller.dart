import 'package:e_track/models/employee_attendance.dart';
import 'package:e_track/network/api_service.dart';
import 'package:e_track/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/debounce.dart';
import '../../utils/storagebox.dart';
import '../../utils/strings.dart';

class EmployeeAttendanceController extends GetxController {
  final TextEditingController searchTextController = TextEditingController();
  final dateUsers = RxList<EmployeeAttendance>([]);
  final searchEnable = false.obs;
  final apiData = <EmployeeAttendance>[];
  final Debounce _debounce = Debounce(const Duration(milliseconds: 400));
  final Rx<DateTime> date = Rx<DateTime>(DateTime.now());

  @override
  void onClose() {
    searchTextController.dispose();
    _debounce.dispose();
    super.onClose();
  }

  void onChangeListener() {
    _debounce(() {
      if (searchTextController.text.isEmpty) {
        dateUsers.value = apiData;
      } else {
        final data = apiData
            .where((d) =>
                (d.userName ?? '')
                    .toLowerCase()
                    .contains(searchTextController.text.toLowerCase()) ||
                (d.firstName ?? '')
                    .toLowerCase()
                    .contains(searchTextController.text.toLowerCase()) ||
                (d.lastName ?? '')
                    .toLowerCase()
                    .contains(searchTextController.text.toLowerCase()))
            .toList();
        dateUsers.value = data;
      }
    });
  }

  Future<void> fetchEmployeeAttendance() async {
    try {
      showLoader();
      final response = await ApiService.instance
          .request('etrack/employee_attendance', DioMethod.get, param: {
        'user_id': StorageBox.instance.getUserId(),
        'device_token': StorageBox.instance.getDeviceID(),
        'user_type': StorageBox.instance.getUserType(),
        'attendance_date': DateFormat("yyyy-MM-dd").format(date.value),
      });
      dismissLoader();
      if (response.statusCode == 200) {
        if (response.data['status'] == true) {
          final List<EmployeeAttendance> employees = response.data['data']
              .map<EmployeeAttendance>((e) => EmployeeAttendance.fromJson(e))
              .toList();
          dateUsers.value = employees;
          apiData.clear();
          apiData.addAll(employees);
        } else {
          showToast(message: response.data['message']);
          dateUsers.value = [];
          apiData.clear();
        }
      } else {
        showToast(message: response.statusMessage ?? networkErrorMsg);
        dateUsers.value = [];
        apiData.clear();
      }
    } catch (e) {
      dismissLoader();
      dateUsers.value = [];
      apiData.clear();
      showToast(message: e.toString());
    }
  }
}
