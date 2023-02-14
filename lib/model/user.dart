import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String? name;
  String? age;
  String? email;
  String? state;
  String? city;
  String? address;
  String? phoneNumber;
  String? nickName;
  String? profilePhotoUrl;
  String? fcmToken;

  User(
      {this.id,
      this.name,
      this.age,
      this.email,
      this.state,
      this.city,
      this.address,
      this.phoneNumber,
      this.nickName,
      this.profilePhotoUrl,
      this.fcmToken});

  User.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }

    id = map['id'];
    name = map['name'];
    age = map['age'];
    email = map['email'];
    state = map['state'];
    city = map['city'];
    address = map['address'];
    phoneNumber = map['phoneNumber'];
    nickName = map['nickName'];
    profilePhotoUrl = map['profilePhotoUrl'];
    fcmToken = map['fcmToken'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "age": age,
      "email": email,
      "state": state,
      "city": city,
      "address": address,
      "phoneNumber": phoneNumber,
      "nickName": nickName,
      "profilePhotoUrl": profilePhotoUrl,
      "fcmToken": fcmToken,
    };
  }
}
