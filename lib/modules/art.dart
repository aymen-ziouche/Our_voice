import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class Art {
  final String ownerId;
  final String artId;
  final String name;
  final double height;
  final double width;
  final double length;
  final String type;
  final String image;
  final String descriptionEn;
  final DateTime dateCreated;
  final String technique;
  final String style;
  final String subject;
  final String copy;
  final double price;
  final String currency;
  final bool toSell;
  final String certificate;
  final List rewards;
  final String links;
  final String descriptionAr;
  final String descriptionFr;
  final String descriptionSp;
  final String descriptionGr;
  final List favorites;
  final List praises;
  final List critics;

  Art({
    required this.ownerId,
    required this.artId,
    required this.name,
    required this.height,
    required this.width,
    required this.length,
    required this.type,
    required this.image,
    required this.descriptionEn,
    required this.dateCreated,
    required this.technique,
    required this.style,
    required this.subject,
    required this.copy,
    required this.price,
    required this.currency,
    required this.toSell,
    required this.certificate,
    required this.rewards,
    required this.links,
    required this.descriptionAr,
    required this.descriptionFr,
    required this.descriptionSp,
    required this.descriptionGr,
    required this.favorites,
    required this.praises,
    required this.critics,
  });

  factory Art.fromFirestore(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Art(
      artId: data['artId'],
      ownerId: data['ownerId'],
      name: data['name'],
      height: data['height'],
      width: data['width'],
      length: data['length'],
      type: data['type'],
      image: data['image'],
      descriptionEn: data['descriptionEn'],
      dateCreated: data['dateCreated'].toDate(),
      technique: data['technique'],
      style: data['style'],
      subject: data['subject'],
      copy: data['copy'],
      price: data['price'],
      currency: data['currency'],
      toSell: data['toSell'],
      certificate: data['certificate'],
      rewards: data['rewards'],
      links: data['links'],
      descriptionAr: data['descriptionAr'],
      descriptionFr: data['descriptionFr'],
      descriptionSp: data['descriptionSp'],
      descriptionGr: data['descriptionGr'],
      favorites: data['favorites'],
      praises: data['praises'],
      critics: data['critics'],
    );
  }
}
