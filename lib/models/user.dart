class UserModel {
  String? id;
  String? name;
  DateTime? birthDate;
  String? email;
  String? state;
  String? city;
  String? address;
  String? phoneNumber;
  String? nickName;
  String? profilePhotoUrl;
  String? fcmToken;

  UserModel(
      {this.id,
      this.name,
      this.birthDate,
      this.email,
      this.state,
      this.city,
      this.address,
      this.phoneNumber,
      this.nickName,
      this.profilePhotoUrl,
      this.fcmToken});

  UserModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }

    id = map['id'];
    name = map['name'];
    birthDate = map['birthDate'];
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
      "birthDate": birthDate,
      "email": email,
      "state": state,
      "city": city,
      "address": address,
      "phoneNumber": phoneNumber,
      "nickName": nickName,
      "profilePhotoUrl": profilePhotoUrl,
      "notificationToken": fcmToken,
    };
  }
}
