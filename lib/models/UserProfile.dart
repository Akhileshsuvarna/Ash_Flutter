import 'package:connectycube_sdk/connectycube_sdk.dart';

import '../main.dart';

class UserProfile {
  Data? data = Data();
  CubeUser? cubeUser = CubeUser();

  UserProfile({this.data, this.cubeUser});

  UserProfile.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? Data.fromJson(Map<String, dynamic>.from(json['data']))
        : Data();
    cubeUser = json['cubeUser'] != null
        ? CubeUser.fromJson(Map<String, dynamic>.from(json['cubeUser']))
        : CubeUser();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['data'] = this.data!.toJson();
    data['cubeUser'] = cubeUser != null ? cubeUser!.toJson() : {};

    return data;
  }
}

class Data {
  String firebaseToken = "";
  String email = "";
  String firstName = "";
  String lastName = "";
  String name = "";
  String gender = "";
  String dateOfBirth = "";
  String phoneNumber = "";
  String createdAt = "";
  String updatedAt = "";
  String photoURL = "";
  String uuid = "";
  String address = "";
  bool isAdmin = false;
  String platform = "";

  Data(
      {this.firebaseToken = "",
      this.email = "",
      this.firstName = "",
      this.lastName = "",
      this.name = "",
      this.gender = "",
      this.dateOfBirth = "",
      this.phoneNumber = "",
      this.createdAt = "",
      this.updatedAt = "",
      this.photoURL = "",
      this.uuid = "",
      this.address = "",
      this.platform = ""});

  Data.fromJson(Map<String, dynamic> json) {
    firebaseToken = json['firebaseToken'] ?? prefs.get('fcmToken');
    email = json['email'] ?? 'wrap';
    firstName = json['first_name'] ?? '';
    lastName = json['last_name'] ?? '';
    name = json['name'] ?? '';
    gender = json['gender'] ?? '';
    dateOfBirth = json['date_of_birth'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    photoURL = json['photoURL'] ?? '';
    uuid = json['uuid'] ?? '';
    address = json['address'] ?? '';
    isAdmin = json['isAdmin'] ?? false;
    platform = json['platform'];
  }

  Map<String, dynamic> toJson() => {
        'firebaseToken': firebaseToken,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'name': name,
        'gender': gender,
        'date_of_birth': dateOfBirth,
        'phoneNumber': phoneNumber,
        'photoURL': photoURL,
        'uuid': uuid,
        'address': address,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'platform': platform
      };
}
