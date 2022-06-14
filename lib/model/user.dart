import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:timeless/model/gender_type.dart';

class UserData {
  String id;
  String name;
  String email;
  DateTime birthDate;
  GenderType gender;
  String? city;
  String? country;
  String? description;
  String profilePicture;
  String cover;
  int profileIndex;
  int coverIndex;
  int notificationIndex;
  List<String> followers;
  List<String> following;

  UserData(
      {required this.id,
      required this.name,
      required this.email,
      required this.birthDate,
      required this.gender})
      : city = null,
        country = null,
        description = null,
        profileIndex = 0,
        coverIndex = 0,
        profilePicture =
            'https://firebasestorage.googleapis.com/v0/b/timeless-35302.appspot.com/o/Portrait_Placeholder%5B1%5D.png?alt=media&token=34332fa9-9bfc-4a5b-9f0f-77ba0ec387f2',
        cover =
            'https://firebasestorage.googleapis.com/v0/b/timeless-35302.appspot.com/o/50-Beautiful-and-Minimalist-Presentation-Backgrounds-036.jpg?alt=media&token=246755ab-165f-41d8-849b-ea5f34aff659',
        notificationIndex = 0,
        followers = [],
        following = [];

  UserData.full(
      {required this.id,
      required this.name,
      required this.email,
      required this.birthDate,
      required this.gender,
      this.city,
      this.country,
      this.description,
      required this.profilePicture,
      required this.cover,
      required this.profileIndex,
      required this.coverIndex,
      required this.followers,
      required this.following,
      required this.notificationIndex});

  Map<String, dynamic> toJson() => {
        'name': name,
        'date_of_birth': birthDate,
        'email': email,
        'gender': EnumToString.convertToString(gender),
        'id': id,
        'city': city,
        'country': country,
        'description': description,
        'profile_pic': profilePicture,
        'cover_pic': cover,
        'profile_index': profileIndex,
        'cover_index': coverIndex,
        'notification_index': notificationIndex,
        'followers': followers,
        'following': following
      };

  static UserData fromJson(Map<String, dynamic> json) => UserData.full(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        birthDate: json['date_of_birth'].toDate(),
        gender: EnumToString.fromString(GenderType.values, json['gender'])!,
        city: json['city'],
        country: json['country'],
        description: json['description'],
        profilePicture: json['profile_pic'] != null
            ? json['profile_pic']
            : 'https://firebasestorage.googleapis.com/v0/b/timeless-35302.appspot.com/o/Portrait_Placeholder%5B1%5D.png?alt=media&token=34332fa9-9bfc-4a5b-9f0f-77ba0ec387f2',
        cover: json['cover_pic'] != null
            ? json['cover_pic']
            : 'https://firebasestorage.googleapis.com/v0/b/timeless-35302.appspot.com/o/50-Beautiful-and-Minimalist-Presentation-Backgrounds-036.jpg?alt=media&token=246755ab-165f-41d8-849b-ea5f34aff659',
        profileIndex: json['profile_index'] != null ? json['profile_index'] : 0,
        coverIndex: json['cover_index'] != null ? json['cover_index'] : 0,
        notificationIndex: json['notification_index'] != null ? json['notification_index'] : 0,
        followers: json['followers'] != null
            ? List<String>.from(json['followers'])
            : [],
        following: json['following'] != null
            ? List<String>.from(json['following'])
            : [],
      );

  static UserData fromJson2(DocumentSnapshot json) => UserData.full(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      birthDate: json['date_of_birth'].toDate(),
      gender: EnumToString.fromString(GenderType.values, json['gender'])!,
      city: json['city'],
      country: json['country'],
      description: json['description'],
      profilePicture: json['profile_pic'] != null
          ? json['profile_pic']
          : 'https://firebasestorage.googleapis.com/v0/b/timeless-35302.appspot.com/o/Portrait_Placeholder%5B1%5D.png?alt=media&token=34332fa9-9bfc-4a5b-9f0f-77ba0ec387f2',
      cover: json['cover_pic'] != null
          ? json['cover_pic']
          : 'https://firebasestorage.googleapis.com/v0/b/timeless-35302.appspot.com/o/50-Beautiful-and-Minimalist-Presentation-Backgrounds-036.jpg?alt=media&token=246755ab-165f-41d8-849b-ea5f34aff659',
      profileIndex:
          json['profile_index'] != null ? int.parse(json['profile_index']) : 0,
      coverIndex:
          json['cover_index'] != null ? int.parse(json['cover_index']) : 0,
      notificationIndex: json['notification_index'] != null ? json['notification_index'] : 0,
      followers:
          json['followers'] != null ? List<String>.from(json['followers']) : [],
      following: json['following'] != null
          ? List<String>.from(json['following'])
          : []);
}
