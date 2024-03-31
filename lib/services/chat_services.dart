import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/message.dart';
import 'package:fitness_social_app/models/message_share.dart';

class ChatService {
  // Get instance of firestore

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  // get user stream
  Future getFollowers() async {
    var uid = getCurrentUser()?.uid;
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("following")
        .snapshots()
        .map((doc) => doc.docs.map((asdf) => asdf.id).toList());
  }

  // // send message

  Future<void> sharePost(
      {required String receiverId, postId, postImgUrl, postTitle}) async {
    //

    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timeStamp = Timestamp.now();

    MessageShare newSharedMessage = MessageShare(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverId,
      postTitle: postTitle,
      timestamp: timeStamp,
      imgUrl: postImgUrl,
      postId: postId,
    );

    // construct chat room id for the two users ( sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverId];
    ids.sort();
    String chatRoomID = ids.join('_');

    // await fire

    // add new messages
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newSharedMessage.toMap());
  }

  Future<void> sendMessage(String receiverID, message) async {
    // get current user info

    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timeStamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timeStamp,
    );

    // construct chat room id for the two users ( sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // add new messages
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // construct a chatroom ID for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
