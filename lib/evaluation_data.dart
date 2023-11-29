/*
import 'interval.dart';


class EvaluationData {
  // ---- Input data ------
  int restingHeartrate;
  List<Interval> intervals = [];

  // ---- Calculated figures -------
  String fitnessLevel;
  double vo2;
  double power;
  double mets;
  double kcals;
  double speed;

  EvaluationData({
    required this.restingHeartrate,
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
 */