import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory Trainee.fromMap(LinkedHashMap<dynamic, dynamic> map) => Trainee(
      name: map['name'],
      age: map['age'],
      weight: map['weight'],
      sex: map['sex']
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'weight': weight,
    'sex': sex,
  };

}