import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:timeless/model/gender_type.dart';

class UserData{
  String id;
  String name;
  String email;
  DateTime birthDate;
  GenderType gender;
  String? city;
  String? country;
  String? description;

  UserData({required this.id, required this.name, required this.email, required this.birthDate, required this.gender}) : city = null, country = null, description = null;

  UserData.full({required this.id, required this.name, required this.email, required this.birthDate, required this.gender ,this.city, this.country, this.description});

  Map<String, dynamic> toJson() => {
    'name': name,
    'date_of_birth': birthDate,
    'email': email,
    'gender': EnumToString.convertToString(gender),
    'id': id,
    'city': null,
    'country': null,
    'description': null,
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
  );

}