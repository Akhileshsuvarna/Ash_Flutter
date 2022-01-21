import 'package:health_connector/main.dart';

class UserProfile {
  Data data = Data();

  UserProfile({required this.data});

  UserProfile.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : Data();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['data'] = this.data.toJson();

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
  bool isVIP = false;

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
      this.address = ""});

  Data.fromJson(Map<String, dynamic> json) {
    firebaseToken = json['firebaseToken'] ?? prefs.get('_fcmToken');
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
    isVIP = json['isVIP'] ?? false;
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
        'updated_at': updatedAt
      };
}
