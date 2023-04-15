




import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:our_voice/modules/art.dart';

class Database {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String docId = FirebaseFirestore.instance.collection("art").doc().id;
  // save art's info to firestore
  Future<void> saveart({
    required String artName,
    required String artSize,
    required String artDescription,
    required File artImage,
  }) async {
    final user = _auth.currentUser;

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('art_images/${DateTime.now().toIso8601String()}}');
    final uploadTask = storageRef.putFile(artImage);
    final downloadUrl = await (await uploadTask).ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('Art').doc().set({
      'ownerId': user?.uid,
      'artId': docId,
      'artName': artName,
      'artSize': artSize,
      'artDescription': artDescription,
      'petImage': downloadUrl,
      'favorites': [],
    });
  }

  // Future<List<Art>> loadArt() async {
  //   try {
  //     final artSnapshot =
  //         await FirebaseFirestore.instance.collection('pets').get();
  //     return artSnapshot.docs
  //         .map((doc) => Art(
  //           artId: 
  //             ))
  //         .toList();
  //   } catch (e) {
  //     return [];
  //   }
  // }

  Future<void> addFavorites(String petId) async {
    final user = _auth.currentUser;
    String petDocId = '';

    await FirebaseFirestore.instance
        .collection('art')
        .where('art', isEqualTo: petId)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        petDocId = doc.reference.id;
      }
    });

    return FirebaseFirestore.instance.collection('art').doc(petDocId).update({
      "favorites": FieldValue.arrayUnion([user?.uid]),
    });
  }

  // Future<List<Pet>> loadFavorites() async {
  //   final user = _auth.currentUser;

  //   try {
  //     final petsSnapshot =
  //         await FirebaseFirestore.instance.collection('pets').where("favorites", arrayContains:user?.uid).get();
  //     return petsSnapshot.docs
  //         .map((doc) => Pet(
  //               name: doc.get('petName'),
  //               breed: doc.get('petBreed'),
  //               age: doc.get('petAge'),
  //               description: doc.get('petDescription'),
  //               favorites: doc.get('favorites'),
  //               gender: doc.get('petGender'),
  //               size: doc.get('petSize'),
  //               image: doc.get('petImage'),
  //               latitude: doc.get('latitude'),
  //               longitude: doc.get('longitude'),
  //               ownerId: doc.get('ownerId'),
  //               petId: doc.get('petId'),
  //               type: doc.get('petType'),
  //             ))
  //         .toList();
  //   } catch (e) {
  //     return [];
  //   }
  // }
}
