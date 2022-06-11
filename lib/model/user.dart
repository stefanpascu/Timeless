import 'package:timeless/model/gender_type.dart';
import 'package:timeless/model/task.dart';

import 'goal.dart';

class UserData{
  String uid;
  String name;
  String email;
  DateTime birthDate;
  GenderType gender;
  String city;
  String country;
  String description;
  List<String> friends; // emails
  List<Task> tasks;
  List<Goal> goals;

  UserData(this.uid, this.name, this.email, this.birthDate, this.gender) : city = '', country = '', description = '', friends = [], tasks = [], goals = [];

}