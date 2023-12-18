import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';

class Intensity {
  String description = '';
  double rangePercentage = 0.0;
  int heartrate;
  //Duration pace = Duration();

  Intensity({
    required this.description,
    required this.rangePercentage,
    required this.heartrate});

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