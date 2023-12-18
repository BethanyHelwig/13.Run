import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'evaluation_data.dart';
import 'training_plan.dart';
import 'trainee.dart';
import 'interval_run.dart';
import 'calculate_training_plan.dart';
import 'workout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        textTheme: const TextTheme(
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

TrainingPlan? targetPlan;

class _MyHomePageState extends State<MyHomePage> {

  //static TrainingPlan? targetPlan;
  final CollectionReference itemCollectionDB = FirebaseFirestore.instance.collection('PLANS');

  // --------- Mask for duration input fields __________
  var maskFormatter = MaskTextInputFormatter(
      mask: '##:##:##',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.eager
  );

  // ---------- Create Plan variables -------------------
  final nameTextField = TextEditingController();
  final ageTextField = TextEditingController();
  final sexTextField = TextEditingController();
  final weightTextField = TextEditingController();
  final restingHeartrateTextField = TextEditingController();
  final evalStartTextField = TextEditingController();
  final eval400HRTextField = TextEditingController();
  final eval400TimeTextField = TextEditingController();
  final eval800HRTextField = TextEditingController();
  final eval800TimeTextField = TextEditingController();
  final eval1200HRTextField = TextEditingController();
  final eval1200TimeTextField = TextEditingController();
  final eval1600HRTextField = TextEditingController();
  final eval1600TimeTextField = TextEditingController();
  final eval2000HRTextField = TextEditingController();
  final eval2000TimeTextField = TextEditingController();
  final eval2400HRTextField = TextEditingController();
  final eval2400TimeTextField = TextEditingController();

  // --- Takes the user input and creates the objects, then converts them into
  // --- fields that Firebase will take
  Future<void> _createTrainingPlan() async {
    String name = nameTextField.text;
    int age = int.parse(ageTextField.text);
    String sex = sexTextField.text;
    int weight = int.parse(weightTextField.text);
    int restingHR = int.parse(restingHeartrateTextField.text);
    int evalStartHR = int.parse(evalStartTextField.text);
    int eval400HR = int.parse(eval400HRTextField.text);
    Duration eval400Time = parseDuration(eval400TimeTextField.text);
    int eval800HR = int.parse(eval800HRTextField.text);
    Duration eval800Time = parseDuration(eval800TimeTextField.text);
    int eval1200HR = int.parse(eval1200HRTextField.text);
    Duration eval1200Time = parseDuration(eval1200TimeTextField.text);
    int eval1600HR = int.parse(eval1600HRTextField.text);
    Duration eval1600Time = parseDuration(eval1600TimeTextField.text);
    int eval2000HR = int.parse(eval2000HRTextField.text);
    Duration eval2000Time = parseDuration(eval2000TimeTextField.text);
    int eval2400HR = int.parse(eval2400HRTextField.text);
    Duration eval2400Time = parseDuration(eval2400TimeTextField.text);

    // Creation of each component that goes into making the training plan
    Trainee trainee = Trainee(name: name, age: age, weight: weight, sex: sex);
    List<IntervalRun> intervalRuns = [
      IntervalRun(distance: 0, time: const Duration(), heartrate: evalStartHR),
      IntervalRun(distance: 400, time: eval400Time, heartrate: eval400HR),
      IntervalRun(distance: 800, time: eval800Time, heartrate: eval800HR),
      IntervalRun(distance: 1200, time: eval1200Time, heartrate: eval1200HR),
      IntervalRun(distance: 1600, time: eval1600Time, heartrate: eval1600HR),
      IntervalRun(distance: 2000, time: eval2000Time, heartrate: eval2000HR),
      IntervalRun(distance: 2400, time: eval2400Time, heartrate: eval2400HR)
    ];
    EvaluationData evaluationData = EvaluationData(intervalRuns: intervalRuns, restingHeartrate: restingHR);
    targetPlan = calculateTrainingPlan(trainee, evaluationData);

    // Uploding the training plan to Firebase database
    await itemCollectionDB.add(targetPlan?.toJson());

  }

  // ---------- Create Plan pop-up window ---------------
  void _createPlanDialog(){
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 15),
                        Container(
                          height: 40,
                          width: 300,
                          child: TextField(controller: nameTextField,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder()
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 40,
                          width: 300,
                          child: TextField(controller: ageTextField,
                            decoration: InputDecoration(
                                labelText: 'Age',
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 300,
                          child: TextField(controller: sexTextField,
                            decoration: InputDecoration(
                                labelText: 'Sex',
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 40,
                          width: 300,
                          child: TextField(controller: weightTextField,
                            decoration: InputDecoration(
                                labelText: 'Weight',
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 40,
                      width: 300,
                      child: TextField(controller: restingHeartrateTextField,
                        decoration: InputDecoration(
                            labelText: 'Resting Heartrate',
                            border: OutlineInputBorder()
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child:
                        Text('The following evaluation data is required to create the plan. Please follow the instructions below:',
                            style: Theme.of(context).textTheme.headlineSmall),
                    ),
                    Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.directions_walk),
                          title: Text('In a relatively flat area, warm-up by walking 800 meters (1/4 mile).'),
                        ),
                        ListTile(
                          leading: Icon(Icons.directions_run),
                          title: Text('Begin your evaluation run of 2400 meters (1.5 miles). Overall time and heartrate must be recorded at the start of your evaluation and end of every 400 meter (1/4 mile) interval.'),
                        ),
                        ListTile(
                          leading: Icon(Icons.directions_walk),
                          title: Text('After you\'ve completed your evaluation run, cool down by walking another 800 meters (1/4 mile).'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text("Evaluation start (0 meters / 0 miles):", style: Theme.of(context).textTheme.headlineSmall)),
                        SizedBox(width: 20),
                        Container(
                          height: 40,
                          width: 125,
                          child: TextField(controller: evalStartTextField,
                            decoration: InputDecoration(
                                labelText: 'Heartrate',
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: Text("@ 400 meters / 0.25 miles):", style: Theme.of(context).textTheme.headlineSmall)),
                        SizedBox(width: 20),
                        Container(
                          height: 40,
                          width: 125,
                          child: TextField(controller: eval400HRTextField,
                            decoration: const InputDecoration(
                                labelText: 'Heart rate',
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          height: 40,
                          width: 200,
                          child: TextField(controller: eval400TimeTextField,
                            inputFormatters: [maskFormatter],
                            decoration: InputDecoration(
                                labelText: 'Total Time Elapsed',
                                hintText: '00:00:00',
                                hintStyle: TextStyle(color: Colors.white.withOpacity(.3)),
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: Text("@ 800 meters / 0.5 miles):", style: Theme.of(context).textTheme.headlineSmall)),
                        SizedBox(width: 20),
                        Container(
                          height: 40,
                          width: 125,
                          child: TextFormField(controller: eval800HRTextField,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Heartrate',
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 40,
                          width: 200,
                          child: TextField(controller: eval800TimeTextField,
                            inputFormatters: [maskFormatter],
                            decoration: InputDecoration(
                                labelText: 'Total Time Elapsed',
                                hintText: '00:00:00',
                                hintStyle: TextStyle(color: Colors.white.withOpacity(.3)),
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: Text("@ 1200 meters / 0.75 miles):", style: Theme.of(context).textTheme.headlineSmall)),
                        Container(
                          height: 40,
                          width: 125,
                          child: TextField(controller: eval1200HRTextField,
                            decoration: InputDecoration(
                                labelText: 'Heartrate',
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 40,
                          width: 200,
                          child: TextField(controller: eval1200TimeTextField,
                            inputFormatters: [maskFormatter],
                            decoration: InputDecoration(
                                labelText: 'Total Time Elapsed',
                                hintText: '00:00:00',
                                hintStyle: TextStyle(color: Colors.white.withOpacity(.3)),
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: Text("@ 1600 meters / 1 mile):", style: Theme.of(context).textTheme.headlineSmall)),
                        SizedBox(width: 20),
                        Container(
                          height: 40,
                          width: 125,
                          child: TextField(controller: eval1600HRTextField,
                            decoration: InputDecoration(
                                labelText: 'Heartrate',
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 40,
                          width: 200,
                          child: TextField(controller: eval1600TimeTextField,
                            inputFormatters: [maskFormatter],
                            decoration: InputDecoration(
                                labelText: 'Total Time Elapsed',
                                hintText: '00:00:00',
                                hintStyle: TextStyle(color: Colors.white.withOpacity(.3)),
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: Text("@ 2000 meters / 1.25 miles):", style: Theme.of(context).textTheme.headlineSmall)),
                        SizedBox(width: 20),
                        Container(
                          height: 40,
                          width: 125,
                          child: TextField(controller: eval2000HRTextField,
                            decoration: InputDecoration(
                                labelText: 'Heartrate',
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 40,
                          width: 200,
                          child: TextField(controller: eval2000TimeTextField,
                            inputFormatters: [maskFormatter],
                            decoration: InputDecoration(
                                labelText: 'Total Time Elapsed',
                                hintText: '00:00:00',
                                hintStyle: TextStyle(color: Colors.white.withOpacity(.3)),
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: Text("@ 2400 meters / 1.5 miles):", style: Theme.of(context).textTheme.headlineSmall)),
                        SizedBox(width: 20),
                        Container(
                          height: 40,
                          width: 125,
                          child: TextField(controller: eval2400HRTextField,
                            decoration: InputDecoration(
                                labelText: 'Heartrate',
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 40,
                          width: 200,
                          child: TextField(controller: eval2400TimeTextField,
                            inputFormatters: [maskFormatter],
                            decoration: InputDecoration(
                                labelText: 'Total Time Elapsed',
                                hintText: '00:00:00',
                                hintStyle: TextStyle(color: Colors.white.withOpacity(.3)),
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
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
                                setState(() {
                                  Navigator.pop(context);
                                  _createTrainingPlan();
                                });
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
  void _loadPlanDialog() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) =>
            SimpleDialog(
              title: const Text("Load a plan"),
              contentPadding: const EdgeInsets.all(15.0),
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 300,
                      width: 400,
                      child: StreamBuilder(
                          stream: itemCollectionDB.snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if(!snapshot.hasData) {
                              return const Center(
                                  child:
                                  Text("There are no saved training plans.")
                              );
                            }
                            return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int position) {
                                  return Card(
                                      child: ListTile(
                                        title: Text(snapshot.data!.docs[position]['trainee.name']),
                                        subtitle: Text("Created: ${DateFormat.yMd().format((snapshot.data!.docs[position]['dateCreated'] as Timestamp).toDate())}"),
                                        onTap: () {
                                          setState(() {
                                            String itemId = snapshot.data!.docs[position].id;
                                            print(targetPlan?.trainee.name);
                                            targetPlan = TrainingPlan.fromSnapshot(snapshot.data?.docs[position] as DocumentSnapshot<Object?>);
                                            print(targetPlan?.trainee.name);
                                            Navigator.pop(context);
                                          });
                                        },
                                      )
                                  );
                                }
                            );
                          }
                      ),
                    ),
                  ],
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 360,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [
                  StretchMode.zoomBackground,
                  StretchMode.fadeTitle,
                  StretchMode.blurBackground,
                ],
                title:
                  Image.asset('assets/images/13PointRun.png',
                  fit: BoxFit.contain,
                  width: 225,
                  ),
                background: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[Colors.white12, Colors.transparent],
                    )
                  ),
                  child: Image.asset('assets/images/Run_header.png', fit: BoxFit.cover),
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
                          padding: const EdgeInsets.all(15.0),
                          child: ElevatedButton(
                              onPressed: () { _createPlanDialog();},
                              child: const Text('Create Plan')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () { _loadPlanDialog();},
                              child: const Text('Load Plan')),
                        )
                      ]
                  ),
                  getPrimary(),
                ]
            )
          ),
          getSecondary(),
        ]
      ),
    );
  }

  Widget getPrimary() {
    if(targetPlan != null) {
      return const TrainingOverview();
    } else {
      return const WelcomeOverview();
    }
  }

  Widget getSecondary() {
    if(targetPlan != null) {
      return const TrainingPlanWorkouts();
    } else {
      return const NoWorkouts();
    }
  }

}

// ---- Placeholder for the workout area until plan is selected -----
class NoWorkouts extends StatelessWidget {
  const NoWorkouts({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme
        .of(context)
        .textTheme;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          Workout? workout = Server.getWorkoutByID(index);
          return Card(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Icon(
                  Icons.directions_run,
                  color: Colors.deepOrange[400],
                  size: 50,
                ),
                SizedBox(height: 20),
                Text('Workouts will display here once a plan is created or chosen.'),
                SizedBox(height: 20),
              ],
            ),
          );
        },
        childCount: 1,
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
            Workout? workout = targetPlan?.workouts[index];
            return Card(
              child: Column(
                children: <Widget>[
                  workoutTitle(workout!, textTheme),
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
          childCount: 8,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Exercise #${workout.positionInSequence}',
            style: textTheme.headlineSmall,
          ),
          Text('Week ${workout.weekNumber}',
            style: textTheme.headlineSmall)
        ],
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
                  '${workout.distance} ${workout.description}',
                  style: TextStyle(height: 1.5)),
              Text(
                  'Target heart rate: ${workout.targetHeartRate} \nType: ${workout.type}',
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
          onPressed: () {
          },
          child: Text('Click to complete'),
    ));
  }

  Widget completedWorkout(Workout workout){
    if (workout.completed) {
      return Text('Completed!');
    } else {
      return Text('Click to complete');
    }
  }

}

// ----------- Training Plan general details widget -----------------
class TrainingOverview extends StatelessWidget {
  const TrainingOverview({super.key});

  @override
  Widget build(BuildContext context) {
  //TrainingPlan? trainingPlan = targetPlan;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(9.0),
          child: Text(
              'Training Plan for ${targetPlan?.trainee.name}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
        ),
        Text('Fitness Level: ${targetPlan!.fitnessLevel}'),
        Text('Date created: ${DateFormat.yMd().format(targetPlan!.dateCreated)}',
          style: const TextStyle(height: 1.5)),
        const Text('Goal: 13.1 miles',
          style: TextStyle(height: 1.5)),
        const Text('Length: 12 weeks',
          style: TextStyle(height: 1.5)),
        //TODO Calculate end date
        //Text('End Date: March 13, 2024',
        //  style: TextStyle(height: 1.5)),
        const SizedBox(height:20)
      ],
    );
  }
}

// ----------- Training Plan general details widget -----------------
class WelcomeOverview extends StatelessWidget {
  const WelcomeOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(22.0),
          child: Text(
            'Welcome to your half-marathon\n training companion!',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('To get started, click on \'Create plan\' above.\nOr, if you\'ve already created a plan, click on \'Load Plan.\'',
          textAlign: TextAlign.center),
        ),
        const SizedBox(height:20)
      ],
    );
  }
}

// --------- Helpers -----------------
class Server {
  static List<Workout>? getWorkoutList() =>
      targetPlan?.workouts.toList();

  //TODO will need to update the range once all the workouts have been coded in
  static Workout? getWorkoutByID(int id) {
    assert(id >= 0 && id <= 7);
    return targetPlan?.workouts[id];
  }
  static TrainingPlan? getTrainingPlan() => targetPlan;
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

  /*@override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());*/
}

Duration parseDuration(String input, {String separator = ':'}) {
  List<String> parts = input.split(separator).map((t) => t.trim()).toList();
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);
  int seconds = int.parse(parts[2]);

  return Duration(
      days: 0,
      hours: hours ?? 0,
      minutes: minutes ?? 0,
      seconds: seconds ?? 0,
      milliseconds: 0,
      microseconds: 0);
}

