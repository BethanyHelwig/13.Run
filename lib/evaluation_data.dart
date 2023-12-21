import 'dart:collection';
import 'interval_run.dart';

/// Base data that is then used to calculate [TrainingPlan].
class EvaluationData {
  // ---- Input data ------
  int restingHeartrate;
  List<IntervalRun> intervalRuns = [];

  EvaluationData({
    required this.intervalRuns,
    required this.restingHeartrate,
  });

  /// Transform data into [EvaluationData] object from Firebase database
  factory EvaluationData.fromMap(LinkedHashMap<dynamic, dynamic> map) => EvaluationData(
    restingHeartrate: map['restingHeartrate'],
    intervalRuns: List<IntervalRun>.from(map['intervalRuns'].map((x) => IntervalRun.fromMap(x))),
  );

  Map<String, dynamic> toJson() => {
    'restingHeartrate' : restingHeartrate,
    'intervalRuns' : intervalRuns.map((a) => a.toJson()).toList(),
  };
}

// TODO: features and data collected to add later
/*
class IntervalData {
  int distance = 0;
  Duration time = Duration();
  int heartrate = 0;
  Duration split = Duration();
  Duration pace = Duration();
  double speed = 0;

  IntervalData(IntervalRun run) {
    distance = run.distance;
    time = run.time;
    heartrate = run.heartrate;
    //split =
    //pace = split * 4;
    //speed = 15 / (split.inSeconds/60)
  }

  factory IntervalData.fromSnapshot(DocumentSnapshot docSnap) => IntervalData(
      distance: docSnap.get('distance'),
      time: docSnap.get('time'),
      heartrate: docSnap.get('heartrate'),
      split: docSnap.get('split'),
      pace: docSnap.get('pace'),
      speed: docSnap.get('speed'),
  );

  Map<String, dynamic> toJson() => {
    'distance': distance,
    'time': time,
    'heartrate': heartrate,
    'split': split,
    'pace': pace,
    'speed': speed
  };

}*/

