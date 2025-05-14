class UserModel {
  String email;
  String longitude;
  String latitude;

  UserModel({
    required this.email,
    required this.longitude,
    required this.latitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }
}
