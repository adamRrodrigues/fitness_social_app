import 'package:cloud_firestore/cloud_firestore.dart';

class GenericPost {
  final String postName;
  final String uid;
  final String image;
  final List<String> likes;
  final Timestamp createdAt;
  GenericPost({
    required this.postName,
    required this.uid,
    required this.image,
    required this.likes,
    required this.createdAt,
  });



  GenericPost copyWith({
    String? postName,
    String? uid,
    String? image,
    List<String>? likes,
    Timestamp? createdAt,
  }) {
    return GenericPost(
      postName: postName ?? this.postName,
      uid: uid ?? this.uid,
      image: image ?? this.image,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postName': postName,
      'uid': uid,
      'image': image,
      'likes': likes,
      'createdAt': createdAt,
    };
  }
}
