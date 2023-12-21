import 'dart:core';
import 'package:flutter/foundation.dart';

import 'interval_run.dart';
import 'trainee.dart';
import 'evaluation_data.dart';
import 'training_plan.dart';
import 'workout.dart';
import 'intensity.dart';

/// Calculates the final training plan, including all [workouts] using the
/// information collected by the user for the [trainee] and [evalData] objects.
///
/// Algorithms and calculates are copyright William Helwig, who created this plan
/// as part of this Master's in Exercise Psy
TrainingPlan calculateTrainingPlan(Trainee trainee, EvaluationData evalData) {

  /// This is originally calculated in microseconds then converted to Duration.
  int paceInMicroSeconds = (evalData.intervalRuns[6].time.inMicroseconds ~/ 1.5).round();
  Duration pace = Duration(days: 0, hours: 0, minutes: 0, seconds: 0, milliseconds: 0, microseconds: paceInMicroSeconds);

  /// Speed is calculated using [pace].
  double speed = 60 / (pace.inSeconds / 60);

  /// Loops through heart rate date in [evalData.intervalRuns] to find average heart rate.
  int calculateAverageHR(){
    int totalHR = 0;
    for(IntervalRun run in evalData.intervalRuns) {
      totalHR += run.heartrate;
    }
    int average = (totalHR / (evalData.intervalRuns.length)).round();
    return average;
  }
  int averageHR = calculateAverageHR();

  /// Loops through heart rate data in [evalData.intervalRuns] to find the max heart rate.
  int calculateMaximumHR(){
    int maxHR = 0;
    for(IntervalRun run in evalData.intervalRuns) {
      if(run.heartrate > maxHR) {
        maxHR = run.heartrate;
      }
    }
    return maxHR;
  }
  int actualMaxHR = calculateMaximumHR();

  //TODO: use the estimated HR in later versions
  //int estimatedMaxHR = 220 - trainee.age;

  /// After [actualMaxHR] is calculated, can calculate this.
  int heartrateRange = actualMaxHR - evalData.restingHeartrate;

  /// Calculates the vo2, which is the maximum (max) rate (V) of oxygen (O₂) your body is able to use during exercise
  double calculateVo2() {
    if(speed < 3.7){
      return 0.1 * speed * 26.8 + 3.5;
    } else {
      return 0.2 * speed * 26.8 + 3.5;
    }
  }
  double vo2 = calculateVo2();

  if (kDebugMode) {
    print("speed: {$speed}");
    print("pace: {$pace}");
    print("average heart rate: {$averageHR}");
    print("maximum heart rate: {$actualMaxHR}");
    print("heart rate range: {$heartrateRange}");
    print("vo2: {$vo2}");
  }

  /// Calculates the fitness level of the [trainee] using vo2, age, and sex.
  String fitnessLevel;
  if(trainee.sex == 'Male') {
    fitnessLevel = calculateFitnessLevelMale(vo2, trainee.age);
  } else {
    fitnessLevel = calculateFitnessLevelFemale(vo2, trainee.age);
  }
  if (kDebugMode) {
    print("fitness level: {$fitnessLevel}");
  }

  /// Calculates the beginning distance based on the fitness level.
  int beginningDistance;
  if(fitnessLevel == "Average" || fitnessLevel == "Fair"){
    beginningDistance = 2;
  } else if (fitnessLevel == "Good" || fitnessLevel == "High"){
    beginningDistance = 3;
  } else {
    beginningDistance = 1;
  }
  if (kDebugMode) {
    print("beginning distance: {$beginningDistance}");
  }

  /// Create the intensity chart that sets the target heart rate for each type of workout
  List<Intensity> intensityChart = calculateChart(heartrateRange, evalData.restingHeartrate);

  /// Create the complete list of workouts built off the previously calculated information
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

/// Male-specific table for calculating fitness level.
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

/// Female-specific table for calculating fitness level.
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
/// Calculate the target heart rate for each workout intensity.
calculateHeartRate(int beginningDistance, String type, int week, List<Intensity> chart) {
  /// for fitness levels of Low
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
    /// for fitness levels of Fair and Average
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
    /// for fitness levels of Good and High
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
/// Create intensity chart using heart rate range and resting HR.
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

/// Calculates the 48 workouts in total for a plan; 4 per week over 12 weeks.
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

  // TODO: finish inputting the rest of the workouts

  return workouts;
}