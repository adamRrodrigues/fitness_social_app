// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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

  factory GenericPost.fromMap(Map<String, dynamic> map) {
    return GenericPost(
      postName: map['postName'] as String,
      uid: map['uid'] as String,
      image: map['image'] as String,
      likes: List<String>.from((map['likes'] as List<dynamic>)),
      createdAt: map['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GenericPost.fromJson(String source) =>
      GenericPost.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GenericPost(postName: $postName, uid: $uid, image: $image, likes: $likes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant GenericPost other) {
    if (identical(this, other)) return true;

    return other.postName == postName &&
        other.uid == uid &&
        other.image == image &&
        listEquals(other.likes, likes) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return postName.hashCode ^
        uid.hashCode ^
        image.hashCode ^
        likes.hashCode ^
        createdAt.hashCode;
  }
}
