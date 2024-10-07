import 'dart:async';
import 'dart:ui' as ui;
import 'package:e_track/screens/common/populate_row_item.dart';
import 'package:e_track/utils/colors.dart';
import 'package:e_track/utils/global.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../common/swipesview.dart';
import 'employee_track_controller.dart';

class EmployeeTrackScreen extends StatefulWidget {
  final String employeeId;
  final String deviceLinkId;
  final String swipeInTime;
  final String? swipeOutTime;

  const EmployeeTrackScreen(
      {super.key,
        required this.employeeId,
        required this.deviceLinkId,
        required this.swipeInTime,
        required this.swipeOutTime});

  @override
  State<EmployeeTrackScreen> createState() => _EmployeeTrackScreenState();
}

class _EmployeeTrackScreenState extends State<EmployeeTrackScreen> {
  final controller = Get.put(EmployeeTrackController());


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final inTime = DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(widget.swipeInTime); //.toUtc();
      final outTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(widget
          .swipeOutTime ??
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())); //.toUtc();
      controller.getAttendanceDetails(
        widget.employeeId,
        widget.deviceLinkId,
        DateFormat('yyyy-MM-dd HH:mm:ss').format(inTime),
        DateFormat('yyyy-MM-dd HH:mm:ss').format(outTime),
      );
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
                            initialCameraPosition: controller.googlePlex,
                            mapType: MapType.normal,
                            markers: controller.markers.value,
                            // polylines: controller.polyline.value,
                            scrollGesturesEnabled: true,
                            zoomGesturesEnabled: true,
                            myLocationButtonEnabled: false,
                            gestureRecognizers: {
                              Factory<OneSequenceGestureRecognizer>(
                                      () => EagerGestureRecognizer())
                            },
                            onMapCreated: (c) {
                              controller.mapController =c;
                              kPrintLog("map created");
                            },
                          ))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    swipesView(
                        inTime: formatDateTime(widget.swipeInTime),
                        outTime: formatDateTime(widget.swipeOutTime)),
                    SizedBox(
                      height: 10,
                    ),
                    Obx(() => PopulateRowItem(
                        label: 'Last known location:',
                        value: controller.lastKnownLocation.value))
                  ],
                )),
          )),
      backgroundColor: colorWhite,
    );
  }
}
