import 'package:flutter/material.dart';
import 'training_plan.dart';
import 'trainee.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thirteen Point Run',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Thirteen Point Run'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const TrainingPlanList(),
      /*floatingActionButton: FloatingActionButton(
        onPressed: ,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/
    );
  }
}

class TrainingPlanList extends StatelessWidget {
  const TrainingPlanList({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            leadingImage(),
            exerciseDetails(textTheme),
          ],
        ),
    );
  }

  Widget leadingImage() {
    return SizedBox(
      height: 100,
      width: 100,
      child: Center(
        child: Icon(Icons.directions_run),
      )
    );
  }

  Widget exerciseDetails(TextTheme textTheme) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exercise #${dummyPlan.workouts[0].positionInSequence}',
              style: textTheme.headlineSmall,
            ),
            Text('${dummyPlan.workouts[0].distance} mile ${dummyPlan.workouts[0].description}'),
            Text('Target Heartrate: ${dummyPlan.workouts[0].targetHeartrate} \nType: ${dummyPlan.workouts[0].type}'),
          ],
        )
      )
    );
  }

}


// --------- Dummy Data --------------
Trainee dummyTrainee = Trainee(name: 'Bethany', age: 32, weight: 160, sex: 'Female');
TrainingPlan dummyPlan = TrainingPlan(12, dummyTrainee, dummyWorkouts);
List<Workout> dummyWorkouts = [
  Workout(1, 132, 'run', 'aerobic', 2),
  Workout(2, 132, 'run or equivalent cross-training', 'aerobic', 2),
  Workout(3, 132, 'run', 'aerobic', 2),
  Workout(4, 132, 'run', 'aerobic', 3),
  Workout(5, 137, 'run', 'aerobic', 2),
];


