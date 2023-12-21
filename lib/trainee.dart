import 'dart:collection';

class Trainee {

  String name;
  int age;
  int weight;
  String sex;

  Trainee({
    required this.name,
    required this.age,
    required this.weight,
    required this.sex,
  });

  /// Transform data into [trainee] object from Firebase database
  factory Trainee.fromMap(LinkedHashMap<dynamic, dynamic> map) => Trainee(
      name: map['name'],
      age: map['age'],
      weight: map['weight'],
      sex: map['sex']
  );

  /// Transform to be read by Firebase database
  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'weight': weight,
    'sex': sex,
  };

}