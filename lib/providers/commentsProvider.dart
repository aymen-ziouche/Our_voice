import 'package:flutter/material.dart';
import 'package:our_voice/modules/comment.dart';
import 'package:our_voice/services/auth.dart';
import 'package:our_voice/services/database.dart';

class CommentsProvider extends ChangeNotifier {
  List<Comment> _comments = [];

  List<Comment> get comments => _comments;

  set comments(List<Comment> value) {
    _comments = value;
    notifyListeners();
  }

  Future<void> fetchComments() async {
    final firebaseService = Database();
    // comments = await firebaseService.loadComments();
  }

  List<Comment> get mycomnt {
    return _comments
        .where((cmnt) => cmnt.commentor == Auth().currentUser?.uid)
        .toList();
  }
}
