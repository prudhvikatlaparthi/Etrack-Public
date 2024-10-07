import 'package:e_track/screens/common/edittext.dart';
import 'package:e_track/screens/employee_tracking/employee_track_controller.dart';
import 'package:e_track/screens/employees_attendance/employee_attendance_controller.dart';
import 'package:e_track/utils/colors.dart';
import 'package:e_track/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/employee_attendance.dart';
import '../common/populate_row_item.dart';
import '../employee_tracking/employee_track_screen.dart';

class EmployeesAttendanceScreen extends StatefulWidget {
  const EmployeesAttendanceScreen({super.key});

  @override
  State<EmployeesAttendanceScreen> createState() =>
      _EmployeesAttendanceScreenState();
}

class _EmployeesAttendanceScreenState extends State<EmployeesAttendanceScreen> {
  final controller = Get.put(EmployeeAttendanceController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchEmployeeAttendance();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        title: const Text(
          "E Attendance",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: colorBlack),
        ),
        actions: [
          IconButton(
              onPressed: () {
                controller.searchEnable.toggle();
                controller.searchTextController.clear();
                controller.dateUsers.value = controller.apiData;
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                _selectDate(context);
              },
              icon: const Icon(Icons.date_range))
        ],
        elevation: 0,
      ),
      body: SafeArea(
          child: Obx(
        () => Column(
          children: [
            controller.searchEnable.value
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                        elevation: 5,
                        child: EditText(
                            hint: "Type here to search (Username, Name)",
                            onChange: (value) {
                              controller.onChangeListener();
                            },
                            label: null,
                            controller: controller.searchTextController)))
                : const SizedBox(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchEmployeeAttendance();
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.dateUsers.length,
                  itemBuilder: (context, index) {
                    EmployeeAttendance employee = controller.dateUsers[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 1.0),
                      child: Card(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  PopulateRowItem(
                                    label: 'Username:',
                                    value: employee.userName,
                                  ),
                                  PopulateRowItem(
                                    label: 'Name:',
                                    value:
                                        "${employee.firstName} ${employee.lastName}",
                                  ),
                                  PopulateRowItem(
                                    label: 'Swipe In Time:',
                                    value: formatDateTime(employee.checkInTime),
                                  ),
                                  PopulateRowItem(
                                    label: 'Swipe In Location:',
                                    value: employee.checkInLocation,
                                  ),
                                  PopulateRowItem(
                                    label: 'Swipe Out Time:',
                                    value:
                                        formatDateTime(employee.checkOutTime),
                                  ),
                                  PopulateRowItem(
                                    label: 'Swipe Out Location:',
                                    value: employee.checkOutLocation,
                                  ),
                                  PopulateRowItem(
                                    label: 'Status:',
                                    value: employee.status,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  Get.delete<EmployeeTrackController>();
                                  Get.to(() => EmployeeTrackScreen(
                                        employeeId: employee.employeeId!,
                                        deviceLinkId:
                                            employee.deviceInfo?.deviceLinkId ??
                                                '',
                                        swipeInTime: employee.checkInTime!,
                                        swipeOutTime: employee.checkOutTime,
                                      ));
                                },
                                child: const Text("Track")),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: controller.date.value,
        firstDate: DateTime(2024, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != controller.date.value) {
      controller.date.value = picked;
      controller.fetchEmployeeAttendance();
    }
  }
}
