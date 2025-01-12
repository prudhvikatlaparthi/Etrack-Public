import 'dart:io';

import 'package:e_track/database/database_helper.dart';
import 'package:e_track/utils/global.dart';
import 'package:e_track/utils/socket_connection.dart';
import 'package:e_track/utils/storagebox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../models/internal/olocation.dart';
import 'strings.dart';

Future<bool> handleLocationPermission(bool isSilent) async {
  bool serviceEnabled;
  bool permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await Location().requestService();
    if (!serviceEnabled) {
      if (!isSilent) {
        showToast(
            message:
                'Location services are disabled. Please enable the services');
      }
      return false;
    }
  }
  permission = await Geolocator.checkPermission() == LocationPermission.denied;
  if (permission) {
    permission =
        await Geolocator.requestPermission() == LocationPermission.denied;
    if (permission) {
      if (!isSilent) {
        showToast(message: 'Location permissions are denied');
      }
      return false;
    }
  }
  return true;
}

Future<LatLng?> getCurrentPosition() async {
  try {
    Position? ld = await Geolocator.getCurrentPosition();
    return LatLng(ld.latitude ?? 0.0, ld.longitude ?? 0.0);
  } catch (e) {
    kPrintLog(e);
    return null;
  }
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIusing custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      appName, // id
      notificationTitle, // title
      importance: Importance.low,
      // importance must be at low or higher level
      playSound: false,
      sound: null,
      enableLights: false,
      enableVibration: false);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings(notificationIconName),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: false,
      isForegroundMode: true,
      autoStartOnBoot: false,

      notificationChannelId: appName,
      initialNotificationTitle: notificationTitle,
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: channelID,
      foregroundServiceTypes: [
        AndroidForegroundType.location,
        AndroidForegroundType.dataSync
      ],
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: false,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  // DartPluginRegistrant.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  getLocation(flutterLocalNotificationsPlugin);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  // DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  if (service is AndroidServiceInstance) {
    if (await service.isForegroundService()) {
      /// OPTIONAL for use custom notification
      /// the notification id must be equals with AndroidConfiguration when you call configure() method.
      getLocation(flutterLocalNotificationsPlugin);
    }
  }
}

Future<void> getLocation(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  if (await StorageBox.instance.isStopSync()) {
    await stopLocationService();
    return;
  }
  while (!await StorageBox.instance.isStopSync()) {
    if ((await StorageBox.instance.getImei()).isNullOrEmpty) {
      showNotification(flutterLocalNotificationsPlugin,
          "Problem occurred, please check IMEI");
      await Future.delayed(const Duration(minutes: timeInterval));
      continue;
    }
    LatLng? position = await getCurrentPosition();
    String body = "";
    final dateTime = DateTime.now();
    if (position != null) {
      body = "last synced at ${DateFormat("hh:mm a").format(dateTime)}";
      kPrintLog('FLUTTER BACKGROUND SERVICE: $dateTime');
      try {
        final msg =
            '${await StorageBox.instance.getImei()},${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime.toUtc())},${position.latitude},${position.longitude},0,0,5,1,50';
        // final dbHelper = DatabaseHelper();
        final syncBox = DatabaseHelper();
        syncBox.insertLocation(OLocation(
            message: msg,
            timestamp: DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime),
            synced: 'N'));
        if (await isInternetAvailable()) {
          body = await syncLocation(body, syncBox);
        } else {
          body = "Please check Internet Connection Offline Synced at ${DateFormat("hh:mm a").format(dateTime)}";
        }
      } catch (e) {
        kPrintLog(e);
        body = "Problem occurred, please check Offline Sync";
      }
    } else {
      body = "Problem occurred, please check mobile GPS";
      kPrintLog('FLUTTER BACKGROUND SERVICE Error: $body $dateTime');
    }

    showNotification(flutterLocalNotificationsPlugin, body);
    await Future.delayed(const Duration(minutes: timeInterval));
  }
}

Future<String> syncLocation(String bodyM, DatabaseHelper syncBox) async {
  String body = bodyM;
  try {
    // final dbHelper = DatabaseHelper();
    SocketConnection socket = SocketConnection.instance;
    await socket.connect('13.235.142.155', 4307);
    final unSyncedLocation = await syncBox.getUnSyncedLocations();
    for (var loc in unSyncedLocation) {
      socket.sendData(loc.message, (message) {});
      await syncBox.removeLocation([loc.id ?? 0]);
    }
  } catch (e) {
    kPrintLog(e);
    body = "Problem occurred, please check Socket";
  }
  return body;
}

void showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    String body) {
  flutterLocalNotificationsPlugin.show(
    channelID,
    notificationTitle,
    body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        appName,
        notificationTitle,
        icon: notificationIconName,
        ongoing: true,
        playSound: false,
        enableVibration: false,
        enableLights: false,
        sound: null,
        importance: Importance.low,
        priority: Priority.low,
      ),
    ),
  );
}

Future<bool> isLocationServiceRunning() async {
  final service = FlutterBackgroundService();
  var isRunning = await service.isRunning();
  return isRunning;
}

Future<void> stopLocationService() async {
  if (await isLocationServiceRunning()) {
    await StorageBox.instance.setStopSync(true);
    FlutterBackgroundService().invoke("stopService");
    SocketConnection.instance.close();
  }
}

Future<void> startLocationService() async {
  if (!await isLocationServiceRunning()) {
    await StorageBox.instance.setStopSync(false);
    var service = FlutterBackgroundService();
    service.invoke("setAsForeground");
    service.startService();
  }
}
