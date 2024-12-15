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
import 'dart:ui' as ui;
import 'menu.dart';

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

  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;

  bool get isRtl => Localizations.localeOf(context).languageCode == 'ur';

  @override
  void initState() {
    super.initState();
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
          rotation: doc['bearing'] ?? 0.0,
        );
      }
      return null;
    });

    var markers = await Future.wait(futures);
    return markers.whereType<Marker>().toSet();
  }

  double _calculateMarkerSize(double zoom) {
    return 150.0 * (zoom / _currentZoom);
  }

  @override
  void dispose() {
    _mapController.dispose();
    locationServices.dispose();
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

  void _toggleDrawer() {
    setState(() {
      if (isDrawerOpen) {
        xOffset = 0;
        yOffset = 0;
      } else {
        xOffset = isRtl ? -290 : 290;
        yOffset = 80;
      }
      isDrawerOpen = !isDrawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Menu(),
          AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(isDrawerOpen ? 0.85 : 1.00)
              ..rotateZ(isDrawerOpen ? (isRtl ? 50 : -50) : 0),
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: isDrawerOpen ? BorderRadius.circular(40) : BorderRadius.circular(0),
            ),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(
                    isDrawerOpen ? Icons.arrow_back_ios : Icons.menu,
                    color: Colors.black,
                  ),
                  onPressed: _toggleDrawer,
                ),
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
                            target: LatLng(locationServices.lat.value, locationServices.long.value),
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
                        mapType: MapType.hybrid,
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
            ),
          ),
        ],
      ),
    );
  }
}
