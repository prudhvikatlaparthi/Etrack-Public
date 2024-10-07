import 'dart:async';

import 'package:e_track/models/track_item.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/internal/place.dart';
import '../../network/api_service.dart';
import '../../utils/global.dart';
import '../../utils/storagebox.dart';
import '../../utils/strings.dart';

class EmployeeTrackController extends GetxController {
  final CameraPosition googlePlex = const CameraPosition(
    target: LatLng(17.4065, 78.4772),
    zoom: 10.4746,
  );

  final Rx<Set<Marker>> markers = Rx({});

  GoogleMapController? mapController = null;

  // final Rx<List<Place>> places = Rx([]);

  final Rx<String> lastKnownLocation = "".obs;

  // final Rx<Set<Polyline>> polyline = Rx({});

  Future<void> getAttendanceDetails(String empId, String deviceLinkId,
      String swipeInTime, String swipeOutTime) async {
    try {
      showLoader();
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
        'device_token': StorageBox.instance.getDeviceID(),
        'user_type': 'Employee',
      });
      dismissLoader();
      if (response.statusCode == 200) {
        if (response.data['status'] == true) {
          final List<TrackItem> trackItems = response.data['data']
              .map<TrackItem>((e) => TrackItem.fromJson(e))
              .toList();
          /*trackItems.add(TrackItem(la: '17.4401', lo: '78.3489'));
          trackItems.add(TrackItem(la: '17.4399', lo: '78.4983'));
          trackItems.add(TrackItem(la: '17.4209', lo: '78.5461'));*/
          if (trackItems.isNotEmpty) {
            lastKnownLocation.value = trackItems.last.ln ?? '';
            mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(
                double.tryParse(trackItems.last.la ?? '0.0') ?? 0.0,
                double.tryParse(trackItems.last.lo ?? '0.0') ?? 0.0)));
            /*final markerIcons = <BitmapDescriptor>[];
            for (int i = 0; i < trackItems.length; i++) {
              markerIcons.add(await _createCustomMarkerBitmap(i));
            }*/
            /*places.value = trackItems
                .asMap()
                .entries
                .map((e) => Place(
                    name: e.value.ln ?? '',
                    latLng: LatLng(
                        double.tryParse(e.value.la ?? '0.0') ?? 0.0,
                        double.tryParse(e.value.lo ?? '0.0') ?? 0.0)))
                .toList();*/
            markers.value = trackItems
                .asMap()
                .entries
                .map((e) => Marker(
                    markerId: MarkerId(e.key.toString()),
                    position: LatLng(
                        double.tryParse(e.value.la ?? '0.0') ?? 0.0,
                        double.tryParse(e.value.lo ?? '0.0') ?? 0.0),
                    infoWindow: InfoWindow(
                        title: (e.key + 1).toString(),
                        snippet: e.value.ln ?? ''),
                    icon: BitmapDescriptor.defaultMarker))
                .toSet();
            /*polyline.value = {
              Polyline(
                  polylineId: const PolylineId('0'),
                  color: colorPrimaryDark,
                  width: 2,
                  points: trackItems
                      .map((e) => LatLng(double.tryParse(e.la ?? '0.0') ?? 0.0,
                          double.tryParse(e.lo ?? '0.0') ?? 0.0))
                      .toList())
            };*/
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
}
