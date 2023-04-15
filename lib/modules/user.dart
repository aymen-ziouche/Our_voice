import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String username;
  final String email;
  final String usertype;
  final String fullname;
  final String gender;
  final String birthdate;
  final String bio;
  final String phone;
  final bool showphone;
  final String city;
  final String postalcode;
  final bool pending;
  final int canvas;
  final String profilePicture;
  final String coverPicture;

  User({
    this.uid = "",
    this.username = "",
    this.email = "",
    this.usertype = "",
    this.fullname = "",
    this.gender = "",
    this.birthdate = "",
    this.bio = "",
    this.phone = "",
    this.showphone = false,
    this.city = "",
    this.postalcode = "",
    this.pending = false,
    this.canvas = 0,
    this.profilePicture = "",
    this.coverPicture = "",
  });

  factory User.fromFirestore(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return User(
      uid: snapshot.id,
      username: data["username"],
      email: data["email"],
      usertype: data["usertype"],
      fullname: data["fullname"],
      gender: data["gender"],
      birthdate: data["birthdate"],
      bio: data["bio"],
      phone: data["phone"],
      showphone: data["showphone"] as bool,
      city: data["city"],
      postalcode: data["postalcode"],
      pending: data["pending"] as bool,
      profilePicture: data["profile_picture"],
      coverPicture: data["cover_picture"],
    );
  }
}
