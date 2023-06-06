import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:our_voice/modules/user.dart';

class OwnerProvider with ChangeNotifier {
  String? id;
  User? _user;

  OwnerProvider(this.id) {
    _getOwner();
  }

  void _getOwner() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) async {
      _user = User.fromFirestore(documentSnapshot);


      notifyListeners();
    });
  }
  User? get user => _user;
}
