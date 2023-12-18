import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class Workout {
  int positionInSequence = 0;
  int targetHeartRate = 0;
  String description = '';
  String type = '';
  int distance = 0;
  int weekNumber = 0;
  bool completed = false;

  Workout({
    required this.positionInSequence,
    required this.targetHeartRate,
    required this.description,
    required this.type,
    required this.distance,
    required this.weekNumber,
    required this.completed
  });

  /*factory Workout.fromSnapshot(DocumentSnapshot docSnap) => Workout(
    positionInSequence: docSnap['positionInSequence'],
    targetHeartRate: docSnap['targetHeartRate'],
    description: docSnap['description'],
    type: docSnap['type'],
    distance: docSnap['distance'],
    weekNumber: docSnap['weekNumber'],
    completed: docSnap['completed']
  );*/

  factory Workout.fromMap(LinkedHashMap<dynamic, dynamic> map) => Workout(
      positionInSequence: map['positionInSequence'],
      targetHeartRate: map['targetHeartRate'],
      description: map['description'],
      type: map['type'],
      distance: map['distance'],
      weekNumber: map['weekNumber'],
      completed: map['completed']
  );

  Map<String, dynamic> toJson() => {
    'positionInSequence': positionInSequence,
    'targetHeartRate': targetHeartRate,
    'description': description,
    'type': type,
    'distance': distance,
    'weekNumber': weekNumber,
    'completed' : completed
  };

}