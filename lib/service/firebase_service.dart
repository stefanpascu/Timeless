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
    final user =
        await firestore.collection('users').doc(getCurrentUserId).get();

    return UserData.fromJson(user.data()!);
  }

  static get getCurrentUserId {
    return auth.currentUser!.uid;
  }

  static getUserByEmail(String email) async {
    final id = (await firestore.collection('emails').doc(email).get()).data();
    if (id == null) return null;

    final user = await firestore
        .collection('users')
        .doc(id.toString().split(" ")[1].split("}")[0])
        .get();
    print(user.data());
    return UserData.fromJson(user.data()!);
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
        .update({'id': savedTask.id});
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
      'goal_type': EnumToString.convertToString(goal.type),
    });
  }

  static void editProfileData(UserData user) async {
    await firestore.collection('users').doc(getCurrentUserId).update({
      'name': user.name,
      'city': user.city == null ? null : user.city,
      'country': user.country == null ? null : user.country,
      'description': user.description == null ? null : user.description
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

  static deleteGoal(String id) async {
    await firestore
        .collection('users')
        .doc(getCurrentUserId)
        .collection('goals')
        .doc(id)
        .delete();
  }

  static void updateProfilePicIndex(int index) async {
    await firestore.collection('users').doc(getCurrentUserId).update({
      'profile_index': index + 1,
    });
  }

  static void updateCoverPicIndex(int index) async {
    await firestore.collection('users').doc(getCurrentUserId).update({
      'cover_index': index + 1,
    });
  }

  static void updateProfilePic(String link) async {
    await firestore.collection('users').doc(getCurrentUserId).update({
      'profile_pic': link,
    });
  }

  static void updateCoverPic(String link) async {
    await firestore.collection('users').doc(getCurrentUserId).update({
      'cover_pic': link,
    });
  }

  static followList(List<String> list) async {
    List<UserData> usersList = [];
    UserData auxUser;
    if (list.length > 0)
      for (int index = 0; index < list.length; index++) {
        var x =
            (await firestore.collection('users').doc(list[index]).get()).data();
        if (x != null) {
          auxUser = UserData.fromJson(x);
          usersList.add(auxUser);
        }
      }

    return usersList;
  }

  static void addFollower(String id) async {
    dynamic auxId = id;
    await firestore
        .collection('users')
        .doc(getCurrentUserId)
        .update({
      'following': FieldValue.arrayUnion([auxId])
    });

    await firestore
        .collection('users')
        .doc(id)
        .update({
      'followers': FieldValue.arrayUnion([getCurrentUserId])
    });
  }

  static removeFollower(String id) async {
    dynamic auxId = id;
    await firestore
        .collection('users')
        .doc(getCurrentUserId)
        .update({
      'following': FieldValue.arrayRemove([auxId]),
    });

    await firestore
        .collection('users')
        .doc(auxId)
        .update({
      'followers': FieldValue.arrayRemove([getCurrentUserId]),
    });
  }

  static isFollowedBy(String id) async {
    final query = await firestore
        .collection("users")
        .doc(getCurrentUserId)
        .get();
    return UserData.fromJson(query.data()!).following.contains(id);
  }
}
