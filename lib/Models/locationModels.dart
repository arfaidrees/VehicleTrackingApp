class locationModels {
  late String email;
  late double longitude;
  late double latitude;
  late double bearing;

  locationModels({
    required this.email,
    required this.longitude,
    required this.latitude,
    required this.bearing,
  });

  // To JSON - Serialization
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'longitude': longitude,
      'latitude': latitude,
      'bearing': bearing,
    };
  }

  // From JSON - Deserialization
  factory locationModels.fromJson(Map<String, dynamic> json) {
    return locationModels(
      email: json['email'] as String,
      longitude: json['longitude'] as double,
      latitude: json['latitude'] as double,
      bearing: json['bearing'] as double,
    );
  }
}
