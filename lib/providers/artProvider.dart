import 'package:flutter/material.dart';
import 'package:our_voice/modules/art.dart';
import 'package:our_voice/services/auth.dart';
import 'package:our_voice/services/database.dart';

class ArtProvider extends ChangeNotifier {
  List<Art> _arts = [];

  List<Art> get arts => _arts;

  set arts(List<Art> value) {
    _arts = value;
    notifyListeners();
  }

  Future<void> fetchArts() async {
    final firebaseService = Database();
    arts = await firebaseService.loadarts();
  }


  List<Art> get myart {
    return arts.where((art) => art.ownerId == Auth().currentUser?.uid).toList();
  }
}
