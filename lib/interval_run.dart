import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';

class IntervalRun {

  int distance;
  Duration time;
  int heartrate;

  IntervalRun({
      required this.distance,
      required this.time,
      required this.heartrate,
  }
  );

  factory IntervalRun.fromMap(LinkedHashMap<dynamic, dynamic> map) => IntervalRun(
    distance: map['distance'],
    time: Duration(microseconds: map['time']),
    heartrate: map['heartrate'],
  );

  Map<String, dynamic> toJson() => {
    'distance': distance,
    'time': time.inMicroseconds,
    'heartrate': heartrate,
  };

}