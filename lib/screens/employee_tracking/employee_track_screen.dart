import 'package:e_track/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../common/swipesview.dart';
import 'employee_track_controller.dart';

class EmployeeTrackScreen extends StatefulWidget {
  final String employeeId;

  const EmployeeTrackScreen({super.key, required this.employeeId});

  @override
  State<EmployeeTrackScreen> createState() => _EmployeeTrackScreenState();
}

class _EmployeeTrackScreenState extends State<EmployeeTrackScreen> {
  final controller = Get.put(EmployeeTrackController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAttendanceDetails(widget.employeeId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Track Details",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: colorBlack),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Obx(() => GoogleMap(
                      initialCameraPosition: controller.googlePlex.value))),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() => swipesView(
                inTime: controller.inOutDetails.value.checkInTime ?? '',
                outTime: controller.inOutDetails.value.checkOutTime ?? '')),
          ],
        )),
      )),
      backgroundColor: colorWhite,
    );
  }


}
