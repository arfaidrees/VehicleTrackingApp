import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vehicle_tracking_app/components/Screens/login_page.dart';

import '../Models/locationModels.dart';

class Location extends GetxController {
  late LocationSettings locationSettings;
  RxDouble long = 0.0.obs;
  RxDouble lat = 0.0.obs;
  RxDouble bearing = 0.0.obs;
  late StreamController<Position> _positionStreamController;
  late StreamSubscription<Position> _positionSubscription;
  late FirebaseFirestore fireStore;
  late FirebaseAuth _auth;
  String? uid;
  String? email;

  Location() {
    _auth = FirebaseAuth.instance;
    fireStore = FirebaseFirestore.instance;
    uid = _auth.currentUser!.uid;
    _positionStreamController = StreamController<Position>.broadcast();
    email = _auth.currentUser?.email;
    getuserdata().then((value) {
      Geolocator.getCurrentPosition().then((value) {
        long.value = value.longitude;
        lat.value = value.latitude;
      });
    });
  }

  Future<void> getuserdata() async {
    _auth = FirebaseAuth.instance;
    fireStore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        email = snapshot.get('email');
        long.value = snapshot.get('longitude');
        lat.value = snapshot.get('latitude');
        bearing.value = snapshot.get('bearing'); // Get the bearing
      } else {
        print("User not Found");
      }
    });
  }

  Stream<Position> get positionStream => _positionStreamController.stream;

  Future<void> getlocation() async {
    await Geolocator.requestPermission();

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 1),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) async {
      print("REPEAT");
      lat.value = position.latitude;
      long.value = position.longitude;
      saveLocation();
      _positionStreamController.add(position);
      print(position.toString());
    });

    // Listen to device orientation changes using magnetometer sensor
    magnetometerEvents.listen((MagnetometerEvent event) {
      double heading = atan2(event.y, event.x) * (180 / pi);
      bearing.value = heading; // Update bearing based on magnetometer data
    });
  }

  Future<void> saveLocation() async {
    locationModels userlocation = locationModels(
        email: email ?? "",
        longitude: long.value,
        latitude: lat.value,
        bearing: bearing.value);
    await fireStore
        .collection('users')
        .doc(uid)
        .set(userlocation.toJson())
        .then((value) {
      print('Location Update');
    }).onError((error, stackTrace) {
      print("Error $error");
    });
  }

  void deleteLocation() {
    fireStore.collection('users').doc(uid).set({
      'email': email,
      'longitude': null,
      'latitude': null,
      'bearing': null,
    });
  }

  void stopLocationUpdates() {
    if (_positionSubscription != null) {
      deleteLocation();
      _positionSubscription.cancel();
    }
  }

  @override
  void dispose() {
    if (_positionSubscription != null) {
      _positionSubscription.cancel();
    }
    if (_positionStreamController != null) {
      _positionStreamController.close();
    }
    deleteLocation();
    super.dispose();
    if (kDebugMode) {
      print("Location disposed");
    }
  }

  void signOut() async {
    stopLocationUpdates();
    deleteLocation();
    await _auth.signOut();
    Get.offAll(const LoginPage());
    dispose();
  }
}
