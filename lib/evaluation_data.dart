import 'interval_run.dart';

class EvaluationData {
  // ---- Input data ------
  int restingHeartrate;
  List<IntervalRun> intervalRuns = [];
  List<IntervalData> intervalData = [];

  // ---- Calculated figures -------
  String fitnessLevel = '';
  double vo2 = 0;
  double speed = 0;
  int heartrateRange = 0;
  //double power = 0;
  //double mets = 0;
  //double kcals = 0;


  EvaluationData({
    required this.restingHeartrate,
    required this.intervalRuns,
  });

  calculateFitnessLevelMale(double vo2, int age) {
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
    }
  }
}

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

}
