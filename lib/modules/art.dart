
import 'package:cloud_firestore/cloud_firestore.dart';

class Art {
  final String artId;
  final String name;
  final int height;
  final int width;
  final String type;
  final String image;
  final String description;
  final String ownerId;

  Art({
    required this.artId,
    required this.name,
    required this.type,
    required this.image,
    required this.description,
    required this.ownerId,
    required this.height,
    required this.width,
  });

  // factory Art.fromFirestore(DocumentSnapshot snapshot) {
  //   Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //   return Art(
  //   );
  // }
}


