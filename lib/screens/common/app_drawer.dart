import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_track/database/database_helper.dart';
import 'package:e_track/screens/change_password/change_password_screen.dart';
import 'package:e_track/screens/employees_attendance/employee_attendance_controller.dart';
import 'package:e_track/screens/employees_attendance/employees_attendance_screen.dart';
import 'package:e_track/screens/home/homecontroller.dart';
import 'package:e_track/screens/sync_status/sync_screen.dart';
import 'package:e_track/utils/colors.dart';
import 'package:e_track/utils/storagebox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/global.dart';
import '../../utils/strings.dart';
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
                  FutureBuilder<String>(
                    future: getProfileImage(),
                    builder: (c, t) => t.hasData ?
                        CachedNetworkImage(
                      imageUrl:
                          t.data!,
                      placeholder: (c, u) => const CircleAvatar(
                        backgroundColor: colorWhite,
                        radius: 36,
                        backgroundImage:
                            AssetImage("assets/images/icons/user.png"),
                      ),
                      errorWidget: (c, u, e) => const CircleAvatar(
                        backgroundColor: colorWhite,
                        radius: 36,
                        backgroundImage:
                            AssetImage("assets/images/icons/user.png"),
                      ),
                      imageBuilder: (c, m) => CircleAvatar(
                        backgroundColor: colorWhite,
                        radius: 36,
                        backgroundImage: m,
                      ),
                    ) : const CircleAvatar(
                      backgroundColor: colorWhite,
                      radius: 36,
                      backgroundImage:
                      AssetImage("assets/images/icons/user.png"),
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
                'Sync Status',
                style: TextStyle(
                  color: colorBlack,
                  fontSize: 16,
                ),
              ),
              onTap: () async {
                Get.back();
                await Future.delayed(const Duration(milliseconds: 400), () {
                  var showSync = !(controller.inOutDetails.value.checkInTime
                              ?.isNotNullOrEmpty ==
                          true &&
                      controller.inOutDetails.value.checkOutTime
                              ?.isNotNullOrEmpty ==
                          true);
                  if (showSync) {
                    showSync = controller
                            .inOutDetails.value.checkInTime?.isNotNullOrEmpty ==
                        true;
                  }

                  Get.to(() => SyncScreen(
                        showSync: showSync,
                      ));
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
              onTap: () async {
                Get.back();
                if ((await DatabaseHelper().getUnSyncedLocations()).isEmpty) {
                  logOut();
                } else {
                  showToast(message: syncErrorMsg);
                }
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

  Future<String> getProfileImage() async {
    final profilePic = await StorageBox.instance.getProfilePic();
    if (profilePic.isNotNullOrEmpty &&
        !profilePic!.contains("uploads/no-image.png")) {
      return profilePic;
    } else {
      return "assets/images/icons/user.png";
    }
  }
}
