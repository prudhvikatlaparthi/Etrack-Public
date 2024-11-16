import 'dart:async';

import 'package:e_track/database/database_helper.dart';
import 'package:e_track/screens/common/mybutton.dart';
import 'package:e_track/screens/common/populate_row_item.dart';
import 'package:e_track/utils/global.dart';
import 'package:e_track/utils/location_service.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class SyncScreen extends StatefulWidget {
  final bool showSync;

  const SyncScreen({super.key, required this.showSync});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  Timer? _timer;
  int pendingCount = 0;

  @override
  void initState() {
    super.initState();
    if(widget.showSync) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _startTimer() async {
    await _callFutureFunction();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _callFutureFunction();
    });
  }

  Future<void> _callFutureFunction() async {
    final data = await DatabaseHelper().getUnSyncedLocations();
    setState(() {
      pendingCount = data.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sync Status",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: colorBlack),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            PopulateRowItem(
                label: "Pending Records to Sync : ",
                value: widget.showSync ? pendingCount.toString() : "--"),
            const SizedBox(
              height: 30,
            ),
            widget.showSync
                ? MyButton(
                    label: "Restart Sync",
                    onPress: () async {
                      showLoader();
                      await stopLocationService();
                      await startLocationService();
                      dismissLoader();
                    })
                : const SizedBox()
          ],
        ),
      )),
      backgroundColor: colorWhite,
    );
  }
}
