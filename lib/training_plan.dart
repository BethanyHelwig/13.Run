import 'package:cloud_firestore/cloud_firestore.dart';

import 'evaluation_data.dart';
import 'trainee.dart';
import 'workout.dart';
import 'intensity.dart';

class TrainingPlan {
  Trainee trainee;
  DateTime dateCreated;
  EvaluationData evaluationData;
  String fitnessLevel;
  double vo2;
  double speed;
  Duration pace;
  int heartrateRange;
  List<Workout> workouts;
  int beginningDistance;
  List<Intensity> intensityChart;

  //TODO: additional features and information to add later
  //double power = 0;
  //double mets = 0;
  //double kcals = 0;

  TrainingPlan({
    required this.trainee,
    required this.dateCreated,
    required this.evaluationData,
    required this.fitnessLevel,
    required this.vo2,
    required this.speed,
    required this.pace,
    required this.heartrateRange,
    required this.workouts,
    required this.beginningDistance,
    required this.intensityChart
  });

  factory TrainingPlan.fromSnapshot(DocumentSnapshot docSnap) => TrainingPlan(
    trainee: Trainee.fromMap(docSnap['trainee']), // convert
    dateCreated: (docSnap['dateCreated'] as Timestamp).toDate(),
    evaluationData: EvaluationData.fromMap(docSnap['evaluationData']), // convert
    fitnessLevel: docSnap['fitnessLevel'],
    vo2: docSnap['vo2'],
    speed: docSnap['speed'],
    pace: Duration(microseconds: docSnap['pace']),
    heartrateRange: docSnap['heartrateRange'],
    workouts: List<Workout>.from(docSnap['workouts'].map((x) => Workout.fromMap(x))), // convert
    beginningDistance: docSnap['beginningDistance'],
    intensityChart: List<Intensity>.from(docSnap['intensityChart'].map((x) => Intensity.fromMap(x))), // convert
  );


  Map<String, dynamic> toJson() => {
    'trainee' : trainee.toJson(), // convert
    'dateCreated' : dateCreated,
    'evaluationData' : evaluationData.toJson(), // convert
    'fitnessLevel' : fitnessLevel,
    'vo2' : vo2,
    'speed' : speed,
    'pace' : pace.inMicroseconds,
    'heartrateRange' : heartrateRange,
    'workouts' : workouts.map((a) => a.toJson()).toList(), // convert
    'beginningDistance' : beginningDistance,
    'intensityChart' : intensityChart.map((a) => a.toJson()).toList() // convert
  };
}