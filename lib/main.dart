import 'package:flutter/material.dart';
import 'package:thirteen_point_run/training_plan.dart';
import 'trainee.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const ConstantScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Thirteen Point Run',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        textTheme: TextTheme(
          headlineSmall: TextStyle(),
        ).apply(bodyColor: Colors.blue)
      ),
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

  // ---------- Create Plan variables -------------------
  final nameTextField = TextEditingController();
  final ageTextField = TextEditingController();
  final sexTextField = TextEditingController();

  // ---------- Create Plan pop-up window ---------------
  void _createPlan(){
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) =>
            SimpleDialog(
              title: Text("Create a new plan",
                  style: Theme.of(context).textTheme.headlineSmall),
                contentPadding: const EdgeInsets.all(15.0),
              children: [
                Column(
                  children: [
                    SizedBox(height: 15),
                    Container(
                      width: 400,
                      child: TextField(controller: nameTextField,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder()
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: 400,
                      child: TextField(controller: ageTextField,
                        decoration: InputDecoration(
                            labelText: 'Age',
                            border: OutlineInputBorder()
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: 400,
                      child: TextField(controller: sexTextField,
                        decoration: InputDecoration(
                            labelText: 'Sex',
                            border: OutlineInputBorder()
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                          },
                              child: Text('Cancel')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Submit')),
                        ),
                      ],
                    )
                  ]
                )
              ]
            ),
    );
  }

  // ---------- Load Plan pop-up window -----------------
  void _loadPlan(){
    showDialog<String>(
        context: context,
        builder: (BuildContext context) =>
            SimpleDialog(
              title: const Text("Load a plan"),
              contentPadding: const EdgeInsets.all(15.0),
              children: [
                SizedBox(
                  width: 275,
                  height: 300,
                  child:
                  Text("This will list all training plans saved in the database.")
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                padding: const EdgeInsets.all(9.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                child: Text('Cancel')),
                    ),
                    Padding(
                padding: const EdgeInsets.all(9.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                child: Text('Load')),
                    ),
                  ],
                )
              ]
            )
    );
  }

  // ---------- Main GUI body ------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Image.asset('assets/images/13PointRun.png',)
        //Text(widget.title),
      ),*/
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 175,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: [
                  StretchMode.zoomBackground,
                  StretchMode.fadeTitle,
                  StretchMode.blurBackground,
                ],
                title: Text(
                    '13.Run',
                    style: Theme.of(context).textTheme.headlineMedium
                ),
                  //Image.asset('assets/images/13PointRun.png'),
                background: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[Colors.white12, Colors.transparent],
                    )
                  ),
                  child: Image.asset('assets/images/Run_header.jpg', fit: BoxFit.cover),
                ),
              ),
          ),
          SliverToBoxAdapter(
            child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () { _createPlan();},
                              child: const Text('Create Plan')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () { _loadPlan();},
                              child: const Text('Load Plan')),
                        )
                      ]
                  ),
                  const TrainingOverview(),
                ]
            )
          ),
          const TrainingPlanWorkouts(),
        ]
      ),
    );
  }
}

// ----------- Sliver Workout List --------------------------
class TrainingPlanWorkouts extends StatelessWidget {
  const TrainingPlanWorkouts({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) {
            Workout workout = Server.getWorkoutByID(index);
            return Card(
              child: Column(
                children: <Widget>[
                  workoutTitle(workout, textTheme),
                  Row(
                    children: [
                      leadingImage(workout),
                      workoutDetails(workout, textTheme),
                      workoutCompletion(workout, textTheme)
                    ],
                  )
                ],
              ),
            );
          },
          childCount: 4,
      ),
    );
  }

  Widget workoutTitle(Workout workout, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      color: Colors.white10,
      padding: EdgeInsets.all(8.0),
      constraints: const BoxConstraints.tightForFinite(
        height: 45,
      ),
      /*decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white10,
      ),*/
      child: Text(
        'Exercise #${workout.positionInSequence}',
        style: textTheme.headlineSmall,
      ),
    );
  }

  Widget leadingImage(Workout workout) {
    return SizedBox(
        height: 100,
        width: 100,
        child: Icon(
          Icons.directions_run,
          color: Colors.deepOrange[400],
          size: 40,
        )
    );
  }

  Widget workoutDetails(Workout workout, TextTheme textTheme) {
    return Expanded(
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Goals:',
                  style: TextStyle(fontWeight: FontWeight.bold, height: 1.5)),
              Text(
                  '${workout.distance} mile ${workout.description}',
                  style: TextStyle(height: 1.5)),
              Text(
                  'Target Heartrate: ${workout.targetHeartrate} \nType: ${workout.type}',
                  style: TextStyle(height: 1.5)),
            ],
          )
      ),
    );
  }
  
  Widget workoutCompletion(Workout workout, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          onPressed: () {},
          child: Text('Completed?')),
    );
  }

}

// ----------- Training Plan general details widget -----------------
class TrainingOverview extends StatelessWidget {
  const TrainingOverview({super.key});

  @override
  Widget build(BuildContext context) {
  TrainingPlan trainingPlan = Server.getTrainingPlan();
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(9.0),
          child: Text(
              'Training Plan for ${trainingPlan.trainee.name}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
        ),
        Text('Date created: ${DateFormat.yMd().format(trainingPlan.dateCreated)}'),
        Text('Goal: 13.1 miles',
          style: TextStyle(height: 1.5)),
        Text('Length: 12 weeks',
          style: TextStyle(height: 1.5)),
        Text('End Date: March 13, 2024',
          style: TextStyle(height: 1.5)),
        SizedBox(height:20)
      ],
    );
  }
}


// --------- Dummy Data --------------
Trainee dummyTrainee = Trainee(name: 'Bethany', age: 32, weight: 160, sex: 'Female');
TrainingPlan dummyPlan = TrainingPlan(12, dummyTrainee, dummyWorkouts, DateTime.now());
List<Workout> dummyWorkouts = [
  Workout(1, 132, 'run', 'aerobic', 2),
  Workout(2, 132, 'run or equivalent cross-training', 'aerobic', 2),
  Workout(3, 132, 'run', 'aerobic', 2),
  Workout(4, 132, 'run', 'aerobic', 3),
  Workout(5, 137, 'run', 'aerobic', 2),
];


// --------- Helpers -----------------
class Server {
  static List<Workout> getWorkoutList() =>
      dummyPlan.workouts.toList();

  static Workout getWorkoutByID(int id) {
    assert(id >= 0 && id <= 6);
    return dummyPlan.workouts[id]!;
  }

  static TrainingPlan getTrainingPlan() => dummyPlan;

  static Trainee getTrainee() => dummyPlan.trainee;
}

class ConstantScrollBehavior extends ScrollBehavior {
  const ConstantScrollBehavior();

  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  TargetPlatform getPlatform(BuildContext context) => TargetPlatform.macOS;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}

