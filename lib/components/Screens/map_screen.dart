import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadMarkersOnce(); // Fetch markers once
  }

  Future<void> _loadMarkersOnce() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('users').get();
      Set<Marker> markers = snapshot.docs.map((doc) {
        // Validate Firestore data
        final lat = doc['latitude'];
        final lng = doc['longitude'];

        if (lat is double && lng is double) {
          return Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: doc['email']),
          );
        }
        return null;
      }).whereType<Marker>().toSet();

      setState(() {
        _markers = markers;
      });

      _updateCameraPosition();
    } catch (e) {
      debugPrint('Error loading markers: $e');
    }
  }

  void _updateCameraPosition() {
    if (_markers.isNotEmpty) {
      final firstMarker = _markers.first.position;
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(firstMarker, 15), // Adjust zoom as needed
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(32.4945, 74.5229), // Default location
          zoom: 10,
        ),
        markers: _markers,
        onMapCreated: (controller) {
          _mapController = controller;
          _updateCameraPosition();
        },
      ),
    );
  }
}
