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

  UserData(this.id, this.name, this.email, this.birthDate, this.gender) : city = '', country = '', description = '';

  UserData.full({required this.id, required this.name, required this.email, required this.birthDate, required this.gender ,this.city, this.country, this.description});

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

class NewUser {
  String id;
  final String name;
  final DateTime birthDate;
  final String gender;
  final String email;

  NewUser({
    this.id = '',
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'date_of_birth': birthDate,
    'email': email,
    'gender': gender,
    'id': id,
    'city': 'City',
    'country': 'Country',
    'description': '',
    'friends': {
      'email': '',
    },
  };

  static NewUser fromJson(Map<String, dynamic> json) => NewUser(
    id: json['id'],
    name: json['name'],
    birthDate: json['date_of_birth'].toDate(),
    gender: json['gender'],
    email: json['email'],
  );
}