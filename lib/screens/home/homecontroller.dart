import 'package:e_track/models/internal/date.dart';
import 'package:e_track/utils/global.dart';
import 'package:e_track/utils/storagebox.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../utils/location_service.dart';

class HomeController extends GetxController {
  final Rx<Date> _date = Rx<Date>(Date());
  final Rx<PackageInfo> _info = Rx<PackageInfo>(PackageInfo(
      appName: '',
      packageName: '',
      version: '',
      buildNumber: '',
      buildSignature: '',
      installerStore: ''));
  final isSyncing = false.obs;
  final isSignedIn = false.obs;

  Future<void> initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    _info.value = info;
  }

  @override
  void onInit() {
    callDate();
    super.onInit();
  }

  void callDate() {
    final date = getDate();
    _date.value = date;
    Future.delayed(const Duration(seconds: 1), () {
      callDate();
    });
  }

  Date getDateValue() => _date.value;

  PackageInfo getInfoValue() => _info.value;

  Future<void> checkSync() async {
    bool sync = await isLocationServiceRunning();
    await StorageBox.instance.setBackgroundFetchEnable(sync);
    isSyncing.value = sync;
  }

  void retrieveLatLng() async {
    final hasPermission = await handleLocationPermission(false);
    if (!hasPermission) return;
    LatLng? position = await getCurrentPosition();
    kPrintLog("Sign In ${position?.latitude} ${position?.longitude}");
    // call sign in API
    signInOut();

    if (await isLocationServiceRunning()) {
      await stopLocationService();
      await StorageBox.instance.setBackgroundFetchEnable(false);
      return;
    }
    await StorageBox.instance.setBackgroundFetchEnable(true);
    await startLocationService();
  }

  void signInOut() {
  }
}
