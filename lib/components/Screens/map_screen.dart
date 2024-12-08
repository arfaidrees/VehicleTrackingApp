import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

import '../../Location/location.dart';
import '../../Location/marker.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  final locationServices = Get.put(Location());
  bool isLocationServiceEnabled = false;
  double _currentZoom = 15.0;

  @override
  void initState() {
    super.initState();
    // locationServices.getlocation();
    // Listen to device orientation changes using magnetometer sensor
    // magnetometerEvents.listen((MagnetometerEvent event) {
    //   double heading = atan2(event.y, event.x) * (180 / pi);
    // setState(() {
    //   locationServices.bearing.value =
    //       heading; // Update bearing based on magnetometer data
    // });
    // });
  }

  Future<Set<Marker>> _createMarkersFromData(QuerySnapshot snapshot) async {
    var futures = snapshot.docs.map((doc) async {
      final lat = doc['latitude'];
      final lng = doc['longitude'];
      if (lat != null && lng != null) {
        double markerSize = _calculateMarkerSize(_currentZoom);
        return Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(lat, lng),
          icon: await TextOnImage(
            text: doc['email'],
          ).toBitmapDescriptor(
              logicalSize: Size(markerSize, markerSize),
              imageSize: Size(markerSize, markerSize)),
          infoWindow: InfoWindow(title: doc['email']),
          rotation: doc['bearing'] ?? 0.0, // Add rotation based on bearing
        );
      }
      return null;
    });

    var markers = await Future.wait(futures);
    return markers.whereType<Marker>().toSet();
  }

  double _calculateMarkerSize(double zoom) {
    // Adjust the marker size based on the zoom level
    // Modify this formula as needed to get the desired scaling effect
    return 150.0 * (zoom / _currentZoom);
  }

  @override
  void dispose() {
    _mapController.dispose();
    locationServices.dispose(); // Ensure Location controller is disposed
    super.dispose();
    if (kDebugMode) {
      print("MapScreen disposed");
    }
  }

  void _updateMarkers() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();
    _createMarkersFromData(snapshot).then((markers) {
      setState(() {
        _markers = {...markers};
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Map'),
        actions: [
          CupertinoSwitch(
            value: isLocationServiceEnabled,
            onChanged: (value) {
              setState(() {
                isLocationServiceEnabled = value;
              });
              if (value) {
                locationServices.getlocation();
              } else {
                locationServices.stopLocationUpdates();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.location_searching),
            onPressed: () {
              _mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(locationServices.lat.value,
                        locationServices.long.value),
                    zoom: _currentZoom,
                  ),
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              locationServices.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            try {
              _createMarkersFromData(snapshot.data!).then((markers) {
                setState(() {
                  _markers = {...markers};
                });
              });
            } catch (e) {
              if (kDebugMode) {
                print("W100 ${e.toString()}");
              }
            }
            return Obx(
              () => GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      locationServices.lat.value, locationServices.long.value),
                  zoom: _currentZoom,
                ),
                onMapCreated: (GoogleMapController googlemapcontroller) {
                  _mapController = googlemapcontroller;
                  _updateMarkers();
                },
                onCameraMove: (CameraPosition position) {
                  _currentZoom = position.zoom;
                  _updateMarkers();
                },
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                markers: _markers,
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
