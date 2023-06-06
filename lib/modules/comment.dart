import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String artId;
  final String commentor;
  final String url;
  final List praises;
  final List critics;

  Comment({
    required this.artId,
    required this.commentor,
    required this.url,
    required this.praises,
    required this.critics,
  });

  factory Comment.fromFirestore(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Comment(
      artId: data['ArtID'],
      commentor: data['Commentor'],
      url: data['url'],
      praises: data['praises'],
      critics: data['critics'],
    );
  }
}
