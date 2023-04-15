import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signUp(
    String email,
    String password,
    String username,
    String usertype,
    String fullname,
    String gender,
    String birthdate,
    String bio,
    String phone,
    bool showphone,
    String city,
    String postalcode,
    bool pending,
    int canvas,
    String profile_picture,
    String cover_picture,
  ) async {
    final authResult = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    final user = authResult.user;

    // Save the user's information on Firestore
    await _firestore.collection('users').doc(user?.uid).set({
      'uid': user!.uid,
      'username': username,
      'email': email,
      'usertype': usertype,
      'fullname': fullname,
      'gender': gender,
      'birthdate': birthdate,
      'bio': bio,
      'phone': phone,
      'showphone': showphone,
      'city': city,
      'postalcode': postalcode,
      "pending": pending,
      'profile_picture': profile_picture,
      'cover_picture': cover_picture
    });
    return authResult;
  }

  Future<UserCredential> signIn(String email, String password) async {
    final authResult = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return authResult;
  }

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> logout() async {
    await _auth.signOut();
  }
}
