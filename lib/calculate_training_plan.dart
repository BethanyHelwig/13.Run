import 'dart:core';
import 'interval_run.dart';
import 'trainee.dart';
import 'evaluation_data.dart';
import 'training_plan.dart';
import 'workout.dart';
import 'intensity.dart';

TrainingPlan calculateTrainingPlan(Trainee trainee, EvaluationData evalData) {
  int paceInMicroSeconds = (evalData.intervalRuns[6].time.inMicroseconds ~/ 1.5).round();
  Duration pace = Duration(days: 0, hours: 0, minutes: 0, seconds: 0, milliseconds: 0, microseconds: paceInMicroSeconds);
  double speed = 60 / (pace.inSeconds / 60);
  print("speed: {$speed}");
  print("pace: {$pace}");

  // calculate the average heartrate
  int calculateAverageHR(){
    int totalHR = 0;
    for(IntervalRun run in evalData.intervalRuns) {
      totalHR += run.heartrate;
    }
    int average = (totalHR / (evalData.intervalRuns.length)).round();
    return average;
  }
  int averageHR = calculateAverageHR();
  print("average heart rate: {$averageHR}");

  // calculate the maximum heartrate and heartrate range
  int calculateMaximumHR(){
    int maxHR = 0;
    for(IntervalRun run in evalData.intervalRuns) {
      if(run.heartrate > maxHR) {
        maxHR = run.heartrate;
      }
    }
    return maxHR;
  }
  int estimatedMaxHR = 220 - trainee.age;
  int actualMaxHR = calculateMaximumHR();
  int heartrateRange = actualMaxHR - evalData.restingHeartrate;
  print("maximum heart rate: {$actualMaxHR}");
  print("heart rate range: {$heartrateRange}");

  // calcuate the vo2, which is the maximum (max) rate (V) of oxygen (O₂) your body is able to use during exercise
  double calculateVo2() {
    if(speed < 3.7){
      return 0.1 * speed * 26.8 + 3.5;
    } else {
      return 0.2 * speed * 26.8 + 3.5;
    }
  }
  double vo2 = calculateVo2();
  print("vo2: {$vo2}");

  // calculate the fitness level of the individual using their vo2, age, and sex
  String fitnessLevel;
  if(trainee.sex == 'Male') {
    fitnessLevel = calculateFitnessLevelMale(vo2, trainee.age);
  } else {
    fitnessLevel = calculateFitnessLevelFemale(vo2, trainee.age);
  }
  print("fitness level: {$fitnessLevel}");
  // calculate the beginning distance
  int beginningDistance;
  if(fitnessLevel == "Average" || fitnessLevel == "Fair"){
    beginningDistance = 2;
  } else if (fitnessLevel == "Good" || fitnessLevel == "High"){
    beginningDistance = 3;
  } else {
    beginningDistance = 1;
  }
  print("beginning distance: {$beginningDistance}");
  // Create the intensity chart for this individual that sets the target heartrate for each type of workout
  List<Intensity> intensityChart = calculateChart(heartrateRange, evalData.restingHeartrate);

  // Create the complete list of workouts built off the previously calculated information
  List<Workout> workouts = calculateWorkouts(beginningDistance, intensityChart);

  return TrainingPlan(
      trainee: trainee,
      dateCreated: DateTime.now(),
      evaluationData: evalData,
      fitnessLevel: fitnessLevel,
      vo2: vo2,
      speed: speed,
      pace: pace,
      heartrateRange: heartrateRange,
      workouts: workouts,
      beginningDistance: beginningDistance,
      intensityChart: intensityChart
  );

}

String calculateFitnessLevelMale(double vo2, int age) {
  String fitnessLevel;
  if (age < 30) {
    switch (vo2) {
      case < 39:
        fitnessLevel = 'Low';
        break;
      case < 44:
        fitnessLevel = 'Fair';
        break;
      case < 52:
        fitnessLevel = 'Average';
        break;
      case < 57:
        fitnessLevel = 'Good';
        break;
      case >= 57:
        fitnessLevel = 'High';
        break;
      default:
        fitnessLevel = 'Unknown';
    }
  } else if (age >= 30 && age < 40) {
    switch (vo2) {
      case < 35:
        fitnessLevel = 'Low';
        break;
      case < 40:
        fitnessLevel = 'Fair';
        break;
      case < 48:
        fitnessLevel = 'Average';
        break;
      case < 52:
        fitnessLevel = 'Good';
        break;
      case >= 52:
        fitnessLevel = 'High';
        break;
      default:
        fitnessLevel = 'Unknown';
    }
  } else if (age >= 40 && age < 50) {
    switch (vo2) {
      case < 26:
        fitnessLevel = 'Low';
        break;
      case < 32:
        fitnessLevel = 'Fair';
        break;
      case < 40:
        fitnessLevel = 'Average';
        break;
      case < 44:
        fitnessLevel = 'Good';
        break;
      case >= 44:
        fitnessLevel = 'High';
        break;
      default:
        fitnessLevel = 'Unknown';
    }
  } else if (age >= 50) {
    switch (vo2) {
      case < 22:
        fitnessLevel = 'Low';
        break;
      case < 27:
        fitnessLevel = 'Fair';
        break;
      case < 36:
        fitnessLevel = 'Average';
        break;
      case < 40:
        fitnessLevel = 'Good';
        break;
      case >= 40:
        fitnessLevel = 'High';
        break;
      default:
        fitnessLevel = 'Unknown';
    }
  } else {
    fitnessLevel = 'Error calculating';
  }
  return fitnessLevel;
}

String calculateFitnessLevelFemale(double vo2, int age) {
  String fitnessLevel;
  if (age < 30) {
    switch (vo2) {
      case < 29:
        fitnessLevel = 'Low';
        break;
      case < 35:
        fitnessLevel = 'Fair';
        break;
      case < 44:
        fitnessLevel = 'Average';
        break;
      case < 49:
        fitnessLevel = 'Good';
        break;
      case >= 49:
        fitnessLevel = 'High';
        break;
      default:
        fitnessLevel = 'Unknown';
    }
  } else if (age >= 30 && age < 40) {
    switch (vo2) {
      case < 28:
        fitnessLevel = 'Low';
        break;
      case < 34:
        fitnessLevel = 'Fair';
        break;
      case < 42:
        fitnessLevel = 'Average';
        break;
      case < 48:
        fitnessLevel = 'Good';
        break;
      case >= 48:
        fitnessLevel = 'High';
        break;
      default:
        fitnessLevel = 'Unknown';
    }
  } else if (age >= 40 && age < 50) {
    switch (vo2) {
      case < 26:
        fitnessLevel = 'Low';
        break;
      case < 32:
        fitnessLevel = 'Fair';
        break;
      case < 41:
        fitnessLevel = 'Average';
        break;
      case < 46:
        fitnessLevel = 'Good';
        break;
      case >= 46:
        fitnessLevel = 'High';
        break;
      default:
        fitnessLevel = 'Unknown';
    }
  } else if (age >= 50) {
    switch (vo2) {
      case < 22:
        fitnessLevel = 'Low';
        break;
      case < 29:
        fitnessLevel = 'Fair';
        break;
      case < 37:
        fitnessLevel = 'Average';
        break;
      case < 42:
        fitnessLevel = 'Good';
        break;
      case >= 42:
        fitnessLevel = 'High';
        break;
      default:
        fitnessLevel = 'Unknown';
    }
  } else {
    fitnessLevel = 'Error calculating';
  }
  return fitnessLevel;
}
/// Using the personalized intensity chart and beginning distance, calculate the
/// target heart rate for the workout based on the intensity of it
calculateHeartRate(int beginningDistance, String type, int week, List<Intensity> chart) {
  // for fitness levels of Low
  if (beginningDistance == 1) {
    if (week < 5) {
      return chart[0].heartrate;
    } else if (week < 9) {
      switch (type) {
        case 'Aerobic':
          return chart[1].heartrate;
        case 'Threshold':
          return chart[3].heartrate;
      }
    } else {
      switch (type) {
        case 'Aerobic':
          return chart[2].heartrate;
        case 'Threshold':
          return chart[3].heartrate;
      }
    }
    // for fitness levels of Fair and Average
  } else if (beginningDistance == 2) {
    if (week < 5) {
      return chart[1].heartrate;
    } else if (week < 9) {
      switch (type) {
        case 'Aerobic':
          return chart[2].heartrate;
        case 'Threshold':
          return chart[3].heartrate;
      }
    } else {
      switch (type) {
        case 'Aerobic':
          return chart[2].heartrate;
        case 'Threshold':
          return chart[4].heartrate;
      }
    }
    // for fitness levels of Good and High
  } else if (beginningDistance == 3) {
    if (week < 5) {
      return chart[2].heartrate;
    } else if (week < 9) {
      switch (type) {
        case 'Aerobic':
          return chart[2].heartrate;
        case 'Threshold':
          return chart[4].heartrate;
      }
    } else {
      switch (type) {
        case 'Aerobic':
          return chart[2].heartrate;
        case 'Threshold':
          return chart[4].heartrate;
      }
    }
  }
  return 0;
}

List<Intensity> calculateChart(int heartRateRange, int restingHeartRate) {

  List<Intensity> intensityChart = [
    Intensity(description: 'Aerobic', rangePercentage: 0.6, heartrate: 0),
    Intensity(description: 'Aerobic', rangePercentage: 0.7, heartrate: 0),
    Intensity(description: 'Aerobic', rangePercentage: 0.75, heartrate: 0),
    Intensity(description: 'Threshold', rangePercentage: 0.8, heartrate: 0),
    Intensity(description: 'Threshold', rangePercentage: 0.9, heartrate: 0),
  ];

  for(int i = 0; i < intensityChart.length; i++) {
    intensityChart[i].heartrate = (intensityChart[i].rangePercentage * heartRateRange +
        restingHeartRate).round();
  }
  return intensityChart;
}

// should be 48 workouts in total for 4 per week over 12 weeks
List<Workout> calculateWorkouts(int beginningDistance, List<Intensity> intensityChart) {
  List<Workout> workouts = [
    Workout(
        positionInSequence: 1,
        description: 'mile run',
        type: 'Aerobic',
        distance: beginningDistance,
        targetHeartRate: calculateHeartRate(beginningDistance, 'Aerobic', 1, intensityChart),
        weekNumber: 1,
        completed: false),
    Workout(
        positionInSequence: 2,
        description: 'mile run, cross-training, or rest day',
        type: 'Aerobic',
        distance: beginningDistance,
        targetHeartRate: calculateHeartRate(beginningDistance, 'Aerobic', 1, intensityChart),
        weekNumber: 1,
        completed: false),
    Workout(
        positionInSequence: 3,
        description: 'mile run',
        type: 'Aerobic',
        distance: beginningDistance,
        targetHeartRate: calculateHeartRate(beginningDistance, 'Aerobic', 1, intensityChart),
        weekNumber: 1,
        completed: false),
    Workout(
        positionInSequence: 4,
        description: 'mile long run',
        type: 'Aerobic',
        distance: beginningDistance + 1,
        targetHeartRate: calculateHeartRate(beginningDistance, 'Aerobic', 1, intensityChart),
        weekNumber: 1,
        completed: false),
    Workout(
        positionInSequence: 5,
        description: 'mile run',
        type: 'Aerobic',
        distance: beginningDistance,
        targetHeartRate: calculateHeartRate(beginningDistance, 'Aerobic', 2, intensityChart),
        weekNumber: 2,
        completed: false),
    Workout(
        positionInSequence: 6,
        description: 'mile run',
        type: 'Aerobic',
        distance: beginningDistance,
        targetHeartRate: calculateHeartRate(beginningDistance, 'Aerobic', 2, intensityChart),
        weekNumber: 2,
        completed: false),
    Workout(
        positionInSequence: 7,
        description: 'mile run',
        type: 'Aerobic',
        distance: beginningDistance,
        targetHeartRate: calculateHeartRate(beginningDistance, 'Aerobic', 2, intensityChart),
        weekNumber: 2,
        completed: false),
    Workout(
        positionInSequence: 8,
        description: 'mile run',
        type: 'Aerobic',
        distance: beginningDistance + 2,
        targetHeartRate: calculateHeartRate(beginningDistance, 'Aerobic', 2, intensityChart),
        weekNumber: 2,
        completed: false),
  ];

  // Calculating the distance for each workout
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