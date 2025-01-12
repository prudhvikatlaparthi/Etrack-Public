import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:e_track/models/track_item.dart';
import 'package:e_track/utils/colors.dart';
import 'package:e_track/utils/location_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart'
    as cm;
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart'
    hide Cluster;

import '../../models/internal/place.dart';
import '../../network/api_service.dart';
import '../../utils/global.dart';
import '../../utils/storagebox.dart';
import '../../utils/strings.dart';

class EmployeeTrackController extends GetxController {
  final gm.CameraPosition googlePlex = const gm.CameraPosition(
    target: gm.LatLng(0, 0),
    zoom: 18.4746,
  );

  final Rx<Set<gm.Marker>> markers = Rx({});

  gm.GoogleMapController? mapController;

  final Rx<List<Place>> places = Rx([]);

  final Rx<String> lastKnownLocation = "".obs;

  // late cm.ClusterManager manager;

  final Rx<Set<Polyline>> polyline = Rx({});

  final enablePolyline = false.obs;

  List<TrackItem> trackItems = [];

  Future<void> getAttendanceDetails(String empId, String deviceLinkId,
      String swipeInTime, String swipeOutTime) async {
    try {
      showLoader();
      gm.LatLng? clatlng = await getCurrentPosition();
      mapController?.animateCamera(gm.CameraUpdate.newLatLng(
          gm.LatLng(clatlng?.latitude ?? 0.0, clatlng?.longitude ?? 0.0)));
      final response = await ApiService.instance
          .request('etrack/track_report_etrack', DioMethod.get, param: {
        'user_id': empId,
        'device_link_id': deviceLinkId,
        'time_diff': '10',
        'enable_locations': '1',
        'enable_consecutive': '0',
        'latlng_format': '1',
        'from_date': swipeInTime,
        'to_date': swipeOutTime,
        'device_token': await StorageBox.instance.getDeviceID(),
        'user_type': 'Employee',
      });
      dismissLoader();
      if (response.statusCode == 200) {
        if (response.data['status'] == true) {
          List<TrackItem> acItems = response.data['data']
              .map<TrackItem>((e) => TrackItem.fromJson(e))
              .toList();
          if(acItems.isEmpty){
            showToast(message: "No data found.");
            return;
          }
          trackItems = removeConsecutiveDuplicates(acItems);
          /*trackItems.add(TrackItem(la: '17.4401', lo: '78.3489'));
          trackItems.add(TrackItem(la: '17.4399', lo: '78.4983'));
          trackItems.add(TrackItem(la: '17.4209', lo: '78.5461'));*/
          if (trackItems.isNotEmpty) {
            lastKnownLocation.value = trackItems.last.ln ?? '';
            mapController?.animateCamera(gm.CameraUpdate.newCameraPosition(gm.CameraPosition(target: gm.LatLng(
                double.tryParse(trackItems.last.la ?? '0.0') ?? 0.0,
                double.tryParse(trackItems.last.lo ?? '0.0') ?? 0.0),zoom: 18)));
            /*final markerIcons = <BitmapDescriptor>[];
            for (int i = 0; i < trackItems.length; i++) {
              markerIcons.add(await _createCustomMarkerBitmap(i));
            }*/
            /*places.value = trackItems
                .asMap()
                .entries
                .map((e) =>
                Place(
                    title: (e.key + 1).toString(),
                    name: e.value.ln ?? '',
                    latLng: gm.LatLng(
                        double.tryParse(e.value.la ?? '0.0') ?? 0.0,
                        double.tryParse(e.value.lo ?? '0.0') ?? 0.0)))
                .toList();
            manager.setItems(places.value);*/
            final localMarkers = <gm.Marker>[];
            final m = trackItems.asMap().entries;
            for (var e in m) {
              localMarkers.add(Marker(
                  markerId: MarkerId(e.key.toString()),
                  position: LatLng(double.tryParse(e.value.la ?? '0.0') ?? 0.0,
                      double.tryParse(e.value.lo ?? '0.0') ?? 0.0),
                  infoWindow: InfoWindow(title: e.value.ln ?? ''),
                  icon: await _getMarkerBitmap(110,
                      text: (e.key + 1).toString(),
                      p1: e.key == trackItems.length - 1
                          ? Colors.green
                          : Colors.redAccent)));
            }
            markers.value = localMarkers.toSet();
          }
        } else {
          showToast(message: response.data['message']);
        }
      } else {
        showToast(message: response.statusMessage ?? networkErrorMsg);
      }
    } catch (e) {
      dismissLoader();
      showToast(message: e.toString());
    }
  }

  cm.ClusterManager initClusterManager() {
    return cm.ClusterManager<Place>(places.value, (m) {
      markers.value = m;
    }, markerBuilder: _markerBuilder);
  }

  void drawPolyline() {
    if (enablePolyline.value) {
      polyline.value = {
        Polyline(
            polylineId: const PolylineId('0'),
            color: colorPrimaryDark,
            width: 2,
            points: trackItems
                .map((e) => LatLng(double.tryParse(e.la ?? '0.0') ?? 0.0,
                    double.tryParse(e.lo ?? '0.0') ?? 0.0))
                .toList())
      };
    } else {
      polyline.value = {};
    }
  }

  Future<Marker> Function(cm.Cluster<Place>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {},
          infoWindow: cluster.items.length == 1
              ? (gm.InfoWindow(
                  title: cluster.items.last.title,
                  snippet: cluster.items.last.name))
              : InfoWindow.noText,
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
              text: cluster.isMultiple ? cluster.count.toString() : null),
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(int size,
      {String? text, Color p1 = Colors.redAccent}) async {
    if (kIsWeb) size = (size / 2).floor();

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = p1;
    final Paint paint2 = Paint()..color = colorWhite;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: colorWhite,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

// Function to calculate distance between two LatLng points using Haversine formula
  double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000; // Radius of the Earth in meters
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // Distance in meters
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  List<TrackItem> removeConsecutiveDuplicates(List<TrackItem> latLngList,
      {double threshold = 10.0}) {
    if (latLngList.isEmpty) return [];

    final filteredList = <TrackItem>[latLngList[0]];

    for (int i = 1; i < latLngList.length; i++) {
      final previous = filteredList.last;
      final current = latLngList[i];
      final distance = haversineDistance(double.tryParse(previous.la ?? '0.0') ?? 0.0, double.tryParse(previous.lo ?? '0.0') ?? 0.0,
          double.tryParse(current.la ?? '0.0') ?? 0.0, double.tryParse(current.lo ?? '0.0') ?? 0.0);

      if (distance >= threshold) {
        filteredList.add(current);
      }
    }

    return filteredList;
  }
}
