import 'package:e_track/screens/change_password/change_password_screen.dart';
import 'package:e_track/screens/employees_attendance/employee_attendance_controller.dart';
import 'package:e_track/screens/employees_attendance/employees_attendance_screen.dart';
import 'package:e_track/screens/home/homecontroller.dart';
import 'package:e_track/utils/colors.dart';
import 'package:e_track/utils/storagebox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/global.dart';
import '../change_password/change_password_controller.dart';
import '../employees/employee_controller.dart';
import '../employees/employees_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: Get.width * 0.5,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: colorPrimaryDark,
              ),
              child: Column(
                children: [
                  FutureBuilder(
                    future: getProfileImage(),
                    builder: (c, t) => CircleAvatar(
                      backgroundColor: colorWhite,
                      radius: 36,
                      backgroundImage: t.data,
                    ),
                  ),
                  const Spacer(),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      /*Obx(() => Icon(
                            controller.isSyncing.value
                                ? Icons.sync
                                : Icons.sync_disabled,
                            size: 20,
                            color: colorWhite,
                          )),
                      const SizedBox(
                        width: 10,
                      ),*/
                      FutureBuilder(
                        future: StorageBox.instance.getFullName(),
                        builder: (c, t) => t.data.isNotNullOrEmpty
                            ? Text(
                                t.data!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: colorWhite,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                  const Spacer()
                ],
              ),
            ),
            ListTile(
              title: const Text(
                'Home',
                style: TextStyle(color: colorBlack, fontSize: 16),
              ),
              onTap: () {
                Get.back();
              },
            ),
            FutureBuilder(
              future: isAdmin(),
              builder: (c, t) => t.data == true
                  ? ListTile(
                      title: const Text(
                        'My Employees',
                        style: TextStyle(color: colorBlack, fontSize: 16),
                      ),
                      onTap: () async {
                        Get.back();
                        await Future.delayed(const Duration(milliseconds: 400),
                            () {
                          Get.delete<EmployeeController>();
                          Get.to(() => const EmployeesScreen());
                        });
                      },
                    )
                  : const SizedBox(),
            ),
            FutureBuilder(
              future: isAdmin(),
              builder: (c, t) => t.data == true
                  ? ListTile(
                      title: const Text(
                        'E Attendance',
                        style: TextStyle(color: colorBlack, fontSize: 16),
                      ),
                      onTap: () async {
                        Get.back();
                        await Future.delayed(const Duration(milliseconds: 400),
                            () {
                          Get.delete<EmployeeAttendanceController>();
                          Get.to(() => const EmployeesAttendanceScreen());
                        });
                      },
                    )
                  : const SizedBox(),
            ),
            ListTile(
              title: const Text(
                'Change Password',
                style: TextStyle(
                  color: colorBlack,
                  fontSize: 16,
                ),
              ),
              onTap: () async {
                Get.back();
                await Future.delayed(const Duration(milliseconds: 400), () {
                  Get.delete<ChangePasswordController>();
                  Get.to(() => ChangePasswordScreen());
                });
              },
            ),
            ListTile(
              title: const Text(
                'Log out',
                style: TextStyle(
                  color: colorBlack,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Get.back();
                logOut();
              },
            ),
            ListTile(
              title: Text(
                "App Ver: ${controller.getInfoValue().version}",
                style: const TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 12,
                    color: colorPrimaryDark),
              ),
            ),
          ],
        ));
  }

  Future<ImageProvider<Object>> getProfileImage() async {
    final profilePic = await StorageBox.instance.getProfilePic();
    if (profilePic.isNotNullOrEmpty &&
        !profilePic!.contains("uploads/no-image.png")) {
      return NetworkImage(profilePic);
    } else {
      return const AssetImage("assets/images/icons/user.png");
    }
  }
}
