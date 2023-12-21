import 'dart:collection';

/// Component that makes up the majority of [EvaluationData].
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

  /// Transform data into [IntervalRun] object from Firebase database
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