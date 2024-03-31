import 'package:cloud_firestore/cloud_firestore.dart';

class MessageShare {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String postTitle;
  final String postId;
  final String imgUrl;
  final Timestamp timestamp;

  MessageShare({
    required this.senderID,
    required this.senderEmail,
    required this.receiverID,
    required this.postTitle,
    required this.timestamp,
    required this.imgUrl,
    required this.postId,
  });

  // covnert to a map
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': receiverID,
      'postTitle': postTitle,
      'postId': postId,
      'timestamp': timestamp,
      'imgUrl': imgUrl,
      'isShared': true
    };
  }
}
