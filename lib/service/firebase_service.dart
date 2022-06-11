import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/goal.dart';
import '../model/task.dart';
import '../model/user.dart';

class FirebaseService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static get getCurrentUser async {
    final user = await firestore
        .collection('users')
        .doc(getCurrentUserId)
        .get();

    return UserData.fromJson(user.data()!);
  }

  static get getCurrentUserId {
    return auth.currentUser!.uid;
  }

  static getTasks() async {
    final list = await firestore
        .collection('users')
        .doc(getCurrentUserId)
        .collection('tasks')
        .get();

    return list.docs.map((e) => Task.fromJson(e.data())).toList();
  }

  static getGoals() async {
    final list = await firestore
        .collection('users')
        .doc(getCurrentUserId)
        .collection('goals')
        .get();

    return list.docs.map((e) => Goal.fromJson(e.data())).toList();
  }

  static void createNewTask(Task task) async {
    final savedTask = await firestore
        .collection('users')
        .doc(getCurrentUserId)
        .collection('tasks')
        .add(task.toJson());
    await firestore
        .collection('users')
        .doc(getCurrentUserId)
        .collection('tasks')
        .doc(savedTask.id)
        .update({"id": savedTask.id});
  }

  static void editExistingTask(Task task) async {
    await firestore
        .collection('users')
        .doc(getCurrentUserId)
        .collection('tasks')
        .doc(task.id)
        .update({
      'name': task.name,
      'repetitive_type': task.repetitiveType == null
          ? null
          : EnumToString.convertToString(task.repetitiveType),
      'task_type': EnumToString.convertToString(task.type),
      'time': task.time
    });
  }

  static void createNewGoal(Goal goal) async {
    final savedGoal = await firestore
        .collection('users')
        .doc(getCurrentUserId)
        .collection('goals')
        .add(goal.toJson());
    await firestore
        .collection('users')
        .doc(getCurrentUserId)
        .collection('goals')
        .doc(savedGoal.id)
        .update({"id": savedGoal.id});
  }

  static void editExistingGoal(Goal goal) async {
    await firestore
        .collection('users')
        .doc(getCurrentUserId)
        .collection('goals')
        .doc(goal.id)
        .update({
      'name': goal.name,
      'task_type': EnumToString.convertToString(goal.type),
    });
  }

  static void editProfileData(UserData user) async {
    await firestore
        .collection('users')
        .doc(getCurrentUserId)
        .update({
      'name': user.name,
      'city': user.city == null
          ? null
          : user.city,
      'country': user.country == null
          ? null
          : user.country,
      'description': user.description == null
          ? null
          : user.description
    });
  }

  static getTask(String id) async {
    final task = await firestore
        .collection('users')
        .doc(getCurrentUserId)
        .collection('tasks')
        .doc(id)
        .get();

    return Task.fromJson(task.data()!);
  }

  static deleteTask(String id) async {
    await firestore
        .collection('users')
        .doc(getCurrentUserId)
        .collection('tasks')
        .doc(id)
        .delete();
  }
}
