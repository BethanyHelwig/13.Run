import 'trainee.dart';

class TrainingPlan {
  final double totalDistance = 13.1;
  int programLength = 12;
  Trainee trainee = Trainee(name: 'Bethany', age: 32, weight: 160, sex: 'Female');
  List<Workout> workouts = [];

  TrainingPlan(this.programLength, this.trainee, this.workouts);
}

class Workout {
  int positionInSequence = 0;
  int targetHeartrate = 0;
  String description = '';
  String type = '';
  int distance = 0;
  String measurement = 'miles';

  Workout(
      this.positionInSequence,
      this.targetHeartrate,
      this.description,
      this.type,
      this.distance
      );
}


