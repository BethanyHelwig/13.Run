import 'package:flutter/material.dart';
import 'package:thirteen_point_run/evaluation_data.dart';
import 'package:thirteen_point_run/training_plan.dart';
import 'trainee.dart';
import 'package:intl/intl.dart';
import 'interval_run.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class _MyHomePageState extends State<MyHomePage> {

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
    EvaluationData evaluationData = EvaluationData(restingHeartrate: restingHR, intervalRuns: intervalRuns);
    TrainingPlan newTrainingPlan = TrainingPlan(trainee, DateTime.now(), evaluationData);
    newTrainingPlan.intensityChart = newTrainingPlan.calculateChart(evaluationData);
    //TODO: fix beginning distance placeholder with final calculations
    newTrainingPlan.workouts = newTrainingPlan.calculateWorkouts(2);

    // Sending all the information over to Firebase
    await itemCollectionDB.add({
          "name": trainee.name,
          "age" : trainee.age,
          "sex" : trainee.sex,
          "weight" : trainee.weight
    });

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
                                Navigator.pop(context);
                                _createTrainingPlan();
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
  void _loadPlanDialog(){
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
                                  Card(
                                      child: ListTile(
                                        title: Text(snapshot.data!.docs[position]['name']),
                                        onTap: () {
                                          setState(() {
                                            print("You tapped on items $position");
                                            String itemId = snapshot.data!.docs[position].id;
                                            //itemCollectionDB.doc(itemId).delete();
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
          childCount: 6,
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
                  '${workout.distance} ${workout.description}',
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
TrainingPlan dummyPlan = TrainingPlan(dummyTrainee, DateTime.now(), evalData);
EvaluationData evalData = EvaluationData(intervalRuns: intervals, restingHeartrate: 67);
List<IntervalRun> intervals = [
  IntervalRun(distance: 0, time: const Duration(minutes: 4, seconds: 14), heartrate: 67),
  IntervalRun(distance: 400, time: const Duration(minutes: 4, seconds: 14), heartrate: 67),
  IntervalRun(distance: 800, time: const Duration(minutes: 4, seconds: 14), heartrate: 67),
  IntervalRun(distance: 1200, time: const Duration(minutes: 4, seconds: 14), heartrate: 67),
  IntervalRun(distance: 1600, time: const Duration(minutes: 4, seconds: 14), heartrate: 67),
  IntervalRun(distance: 2000, time: const Duration(minutes: 4, seconds: 14), heartrate: 67),
  IntervalRun(distance: 2400, time: const Duration(minutes: 4, seconds: 14), heartrate: 67),
];

// --------- Helpers -----------------
class Server {
  static List<Workout> getWorkoutList() =>
      dummyPlan.workouts.toList();

  static Workout getWorkoutByID(int id) {
    dummyPlan.intensityChart = dummyPlan.calculateChart(dummyPlan.evaluationData);
    dummyPlan.workouts = dummyPlan.calculateWorkouts(2);
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

