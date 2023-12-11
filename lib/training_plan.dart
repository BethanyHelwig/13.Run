import 'evaluation_data.dart';
import 'trainee.dart';

class TrainingPlan {
  final double totalDistance = 13.1;
  int programLength = 12;
  DateTime dateCreated;
  EvaluationData evaluationData;
  //TODO: finish implementing calculations for actual fitness level
  String fitnessLevel = '';
  //TODO: fix placeholder for trainee
  Trainee trainee = Trainee(name: 'Bethany', age: 32, weight: 160, sex: 'Female');
  List<Workout> workouts = [];
  int beginningDistance = 1;
  List<Intensity> intensityChart = [
    Intensity('Low Intensity', 0.4),
    Intensity('Low Intensity: Initial conditioning', 0.5),
    Intensity('Aerobic', 0.6),
    Intensity('Aerobic: Long, slow distance', 0.7),
    Intensity('Aerobic: Endurance, Base', 0.75),
    Intensity('Threshold', 0.8),
    Intensity('Threshold: Race pace, intervals', 0.9),
    Intensity('Anaerobic', 0.91),
    Intensity('Anaerobic: Peaking, sprints', 1.0)
  ];

  TrainingPlan(this.trainee, this.dateCreated, this.evaluationData);

  //TODO: finish fleshing out workouts
  // should be 48 workouts in total for 4 per week over 12 weeks
  calculateWorkouts(int beginningDistance) {
    List<Workout> workouts = [
      Workout(
          positionInSequence: 1,
          description: 'mile run',
          type: intensityChart[2].description,
          weekNumber: 1),
      Workout(
          positionInSequence: 2,
          description: 'mile run, cross-training, or rest day',
          type: intensityChart[2].description,
          weekNumber: 1),
      Workout(
          positionInSequence: 3,
          description: 'mile run',
          type: intensityChart[0].description,
          weekNumber: 1),
      Workout(
          positionInSequence: 4,
          description: 'mile long run',
          type: intensityChart[0].description,
          weekNumber: 1),
      Workout(
          positionInSequence: 5,
          description: 'mile run',
          type: intensityChart[0].description,
          weekNumber: 2),
      Workout(
          positionInSequence: 6,
          description: 'mile run',
          type: intensityChart[0].description,
          weekNumber: 2),
    ];

    for(int j = 0; j < workouts.length; j++) {
      workouts[j].targetHeartrate = calculateHeartrate(beginningDistance, workouts[j]);
    }

    // Calculating the distance for each workout
    workouts[0].distance = beginningDistance;
    workouts[1].distance = beginningDistance;
    workouts[2].distance = beginningDistance;
    workouts[3].distance = beginningDistance + 1;
    workouts[4].distance = beginningDistance;
    workouts[5].distance = beginningDistance;
    /*workouts[6].distance = beginningDistance;
    workouts[7].distance = beginningDistance + 1;
    if(beginningDistance == 3) {
      workouts[8].distance = beginningDistance;
      workouts[9].distance = beginningDistance;
      workouts[10].distance = beginningDistance;
      workouts[12].distance = beginningDistance;
    } else {
      workouts[8].distance = beginningDistance + 1;
      workouts[9].distance = beginningDistance + 1;
      workouts[10].distance = beginningDistance + 1;
      workouts[12].distance = beginningDistance + 1;
    }
    workouts[11].distance = beginningDistance + 1;
    workouts[12].distance = beginningDistance;
    workouts[13].distance = beginningDistance;
    workouts[14].distance = beginningDistance + 1;*/

    return workouts;
  }

  calculateHeartrate(int beginningDistance, Workout workout) {
    if(beginningDistance == 1) {
      switch (workout.type) {
        case 'Aerobic':
          return 144;
        case 'Threshold':
          return 168;
      }
    } else if(beginningDistance == 2) {
      switch (workout.type) {
        case 'Aerobic':
          return 144;
        case 'Threshold':
          return 168;
      }
    }
    return 0;
  }

  calculateChart(EvaluationData data) {
    for(int i = 0; i < intensityChart.length; i++) {
      intensityChart[i].heartrate = (intensityChart[i].rangePercentage * data.heartrateRange +
          data.restingHeartrate) as int;
    }
    return intensityChart;
  }

}

class Workout {
  int positionInSequence = 0;
  int targetHeartrate = 0;
  String description = '';
  String type = '';
  int distance = 0;
  String measurement = 'miles';
  int weekNumber = 0;

  Workout({
    required this.positionInSequence,
    required this.description,
    required this.type,
    required this.weekNumber,
  });

  void setHeartrate(int heartrate){
    targetHeartrate = heartrate;
  }
}

class Intensity {
  String description = '';
  double rangePercentage = 0.0;
  int heartrate = 0;
  //Duration pace = Duration();

  Intensity(this.description, this.rangePercentage);
}