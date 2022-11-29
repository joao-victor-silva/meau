class User {
  late String uid;
  late String fullName;
  late int age;
  late String email;
  late String state;
  late String country;
  late String address;
  late String phoneNumber;
  late String userName;
  late String password;
  late String? photo;

  User(this.uid, this.fullName, this.age, this.email, this.state, this.country,
      this.address, this.phoneNumber, this.userName, this.password, this.photo);

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
