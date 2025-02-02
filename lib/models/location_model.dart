class LocationModel {
  final double latitude;
  final double longitude;
  final String address;
  final String place;

  LocationModel({required this.latitude, required this.longitude, required this.address, required this.place});

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'place': place,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      place: json['place'],
    );
  }

  @override
  String toString() => "$latitude,$longitude,$address,$place";
}