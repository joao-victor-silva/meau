class LocalUser {
  late String uid;
  late String fullName;
  late String age;
  late String email;
  late String state;
  late String country;
  late String address;
  late String phoneNumber;
  late String userName;
  late String password;
  late String? photo;

  LocalUser(this.uid, this.fullName, this.age, this.email, this.state,
      this.country,
      this.address, this.phoneNumber, this.userName, this.password, this.photo);

  LocalUser.fromMap(Map<String, dynamic> map) {
    LocalUser(
        map['uid'], map['fullName'], map['age'], map['email'], map['state'],
        map['country'], map['address'], map['phoneNumber'], map['userName'], map['password'], map['photo']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "uid": uid,
      "fullName": fullName,
      "age": age,
      "email": email,
      "state": state,
      "country": country,
      "address": address,
      "phoneNumber": phoneNumber,
      "userName": userName,
      "photo": photo,
    };
  }
}
