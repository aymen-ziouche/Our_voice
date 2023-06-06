import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:our_voice/modules/art.dart';
import 'package:our_voice/modules/comment.dart';
import 'package:random_string/random_string.dart';

class Database {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // save art's info to firestore
  Future<void> saveart({
    String? artId,
    required String name,
    required double height,
    required double width,
    required double length,
    required String type,
    required String image,
    required String descriptionEn,
    String? ownerId,
    required DateTime dateCreated,
    required String technique,
    required String style,
    required String subject,
    required String support,
    required String? copy,
    required double price,
    required String currency,
    required bool toSell,
    required String certificate,
    required List rewards,
    required String links,
    required String descriptionAr,
    required String descriptionFr,
    required String descriptionSp,
    required String descriptionGr,
  }) async {
    final user = _auth.currentUser;
    String docId = randomAlpha(15);

    await FirebaseFirestore.instance.collection('Art').doc().set({
      'ownerId': user?.uid,
      'artId': docId,
      "name": name,
      "height": height,
      "width": width,
      "length": length,
      "type": type,
      "image": image,
      "descriptionEn": descriptionEn,
      "dateCreated": dateCreated,
      "technique": technique,
      "style": style,
      "subject": subject,
      "copy": copy,
      "price": price,
      "currency": currency,
      "toSell": toSell,
      "certificate": certificate,
      "rewards": rewards,
      "links": links,
      "descriptionAr": descriptionAr,
      "descriptionFr": descriptionFr,
      "descriptionSp": descriptionSp,
      "descriptionGr": descriptionGr,
      'favorites': [],
      'praises': [],
      'critics': [],
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

  Future<List<Art>> loadarts() async {
    try {
      final artsSnapshot =
          await FirebaseFirestore.instance.collection('Art').get();
      return artsSnapshot.docs
          .map((doc) => Art(
                artId: doc.get('artId'),
                ownerId: doc.get('ownerId'),
                name: doc.get('name'),
                height: doc.get('height'),
                width: doc.get('width'),
                length: doc.get('length'),
                type: doc.get('type'),
                image: doc.get('image'),
                descriptionEn: doc.get('descriptionEn'),
                dateCreated: doc.get('dateCreated').toDate(),
                technique: doc.get('technique'),
                style: doc.get('style'),
                subject: doc.get('subject'),
                copy: doc.get('copy'),
                price: doc.get('price'),
                currency: doc.get('currency'),
                toSell: doc.get('toSell'),
                certificate: doc.get('certificate'),
                rewards: doc.get('rewards'),
                links: doc.get('links'),
                descriptionAr: doc.get('descriptionAr'),
                descriptionFr: doc.get('descriptionFr'),
                descriptionSp: doc.get('descriptionSp'),
                descriptionGr: doc.get('descriptionGr'),
                favorites: doc.get('favorites'),
                praises: doc.get('praises'),
                critics: doc.get('critics'),
              ))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Stream<QuerySnapshot> loadmyart(String ownerId) {
    return FirebaseFirestore.instance
        .collection('Art')
        .where("ownerId", isEqualTo: ownerId)
        .snapshots();
  }

  Stream<QuerySnapshot> loadComments() {
    return FirebaseFirestore.instance.collection('Comments').snapshots();
  }

  Stream<QuerySnapshot> loadcmnt(String artid) {
    return FirebaseFirestore.instance
        .collection('Comments')
        .where("ArtID", isEqualTo: artid)
        .snapshots();
  }

  Stream<QuerySnapshot> loadmycmnt(String uid) {
    return FirebaseFirestore.instance
        .collection('Comments')
        .where("Commentor", isEqualTo: uid)
        .snapshots();
  }

  Stream<QuerySnapshot> loadusr(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .where("uid", isEqualTo: uid)
        .snapshots();
  }

  Future<void> addFavorites(String artId) async {
    final user = _auth.currentUser;
    String artDocId = '';

    await FirebaseFirestore.instance
        .collection('Art')
        .where('artId', isEqualTo: artId)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        artDocId = doc.reference.id;
      }
    });

    return FirebaseFirestore.instance.collection('Art').doc(artDocId).update({
      "favorites": FieldValue.arrayUnion([user?.uid]),
    });
  }

  Future<void> praise(String artId) async {
    final user = _auth.currentUser;
    String artDocId = '';

    await FirebaseFirestore.instance
        .collection('Art')
        .where('artId', isEqualTo: artId)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        artDocId = doc.reference.id;
      }
    });

    await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
      "praises": FieldValue.arrayUnion([artId]),
    });

    return FirebaseFirestore.instance.collection('Art').doc(artDocId).update({
      "praises": FieldValue.arrayUnion([user.uid]),
    });
  }

  Future<void> critics(String artId) async {
    final user = _auth.currentUser;
    String artDocId = '';

    await FirebaseFirestore.instance
        .collection('Art')
        .where('artId', isEqualTo: artId)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        artDocId = doc.reference.id;
      }
    });

    await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
      "critics": FieldValue.arrayUnion([artId]),
    });

    return FirebaseFirestore.instance.collection('Art').doc(artDocId).update({
      "critics": FieldValue.arrayUnion([user.uid]),
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
