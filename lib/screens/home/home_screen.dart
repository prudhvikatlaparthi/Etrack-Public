import 'package:e_track/screens/common/mybutton.dart';
import 'package:e_track/screens/home/homecontroller.dart';
import 'package:e_track/utils/colors.dart';
import 'package:e_track/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/storagebox.dart';
import '../common/app_drawer.dart';
import '../common/swipesview.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(HomeController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.checkSync();
      // controller.callDate();
      controller.initPackageInfo();
      controller.getAttendanceDetails();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          elevation: 0,
          leading: Builder(builder: (context) {
            return Center(
              child: GestureDetector(
                onTap: () {
                  controller.checkSync();
                  Scaffold.of(context).openDrawer();
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      color: colorPrimary,
                      borderRadius: BorderRadius.circular(5)),
                  child: const Icon(
                    Icons.menu,
                    size: 24,
                    color: colorWhite,
                  ),
                ),
              ),
            );
          }),
          title: const Text(
            "Home",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: colorBlack),
          ),
        ),
        drawer: AppDrawer(controller: controller),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 10),
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi ${StorageBox.instance.getFullName().split(" ")[0]} 👋',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colorPrimaryDark),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 10,
                        surfaceTintColor: colorWhite,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(children: [
                              CircleAvatar(
                                radius: 60,
                                child: Obx(
                                  () => Text(
                                    controller
                                        .getDateValue()
                                        .time
                                        .replaceAll("", " "),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: colorPrimaryDark,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    controller.getDateValue().day,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: colorPrimaryDark,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    controller.getDateValue().date,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: colorPrimaryDark,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Obx(
                                    () => MyButton(
                                        disableButton: controller
                                                    .inOutDetails
                                                    .value
                                                    .checkInTime
                                                    ?.isNotNullOrEmpty ==
                                                true &&
                                            controller
                                                    .inOutDetails
                                                    .value
                                                    .checkOutTime
                                                    ?.isNotNullOrEmpty ==
                                                true,
                                        label: getButtonText(),
                                        onPress: () {
                                          if (controller
                                                      .inOutDetails
                                                      .value
                                                      .checkInTime
                                                      ?.isNotNullOrEmpty ==
                                                  true &&
                                              controller
                                                      .inOutDetails
                                                      .value
                                                      .checkOutTime
                                                      ?.isNotNullOrEmpty ==
                                                  true) {
                                            return;
                                          }
                                          controller.retrieveLatLng();
                                        }),
                                  )
                                ],
                              )
                            ]))),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(() => swipesView(
                        inTime: formatDateTime(controller.inOutDetails.value.checkInTime),
                        outTime:
                        formatDateTime(controller.inOutDetails.value.checkOutTime))),
                  ],
                )))));
  }

  String getButtonText() {
    if (controller.inOutDetails.value.checkInTime?.isNotNullOrEmpty == true &&
        controller.inOutDetails.value.checkOutTime?.isNotNullOrEmpty == true) {
      return "Sign In";
    }
    return controller.inOutDetails.value.checkInTime?.isNullOrEmpty ?? true == true
        ? "Sign In"
        : "Sign Out";
  }
}
