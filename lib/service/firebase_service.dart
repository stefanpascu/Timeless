import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeless/pages/friends_page.dart';

import '../model/task.dart';

class FirebaseService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static get getCurrentUser {
    return auth.currentUser;
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

  static get getGoals {
    return firestore
        .collection('users')
        .doc(getCurrentUserId)
        .collection('goals')
        .doc();
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

// save si update

}
