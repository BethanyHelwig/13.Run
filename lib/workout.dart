import 'dart:collection';

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

  /// Transform data into [workout] object from Firebase database
  factory Workout.fromMap(LinkedHashMap<dynamic, dynamic> map) => Workout(
      positionInSequence: map['positionInSequence'],
      targetHeartRate: map['targetHeartRate'],
      description: map['description'],
      type: map['type'],
      distance: map['distance'],
      weekNumber: map['weekNumber'],
      completed: map['completed']
  );

  /// Transform to be read by Firebase database
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