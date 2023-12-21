import 'dart:collection';

class Intensity {
  String description = '';
  double rangePercentage = 0.0;
  int heartrate;
  //TODO: implement target pace for each intensity
  //Duration pace = Duration();

  Intensity({
    required this.description,
    required this.rangePercentage,
    required this.heartrate});

  /// Transform data into [Intensity] object from Firebase database
  factory Intensity.fromMap(LinkedHashMap<dynamic, dynamic> map) => Intensity(
    description: map['description'],
    rangePercentage: map['rangePercentage'],
    heartrate: map['heartrate'],
  );

  Map<String, dynamic> toJson() => {
    'description': description,
    'rangePercentage': rangePercentage,
    'heartrate': heartrate,
  };
}