// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_social_app/models/comment_model.dart';
import 'package:fitness_social_app/models/user_model.dart';
import 'package:flutter/foundation.dart';

class GenericPost {
  final String postName;
  final String uid;
  final String image;
  final List<String> likes;
  final List<dynamic> comments;
  final Timestamp createdAt;
  GenericPost({
    required this.postName,
    required this.uid,
    required this.image,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  GenericPost copyWith({
    String? postName,
    String? uid,
    String? image,
    List<String>? likes,
    List<dynamic>? comments,
    Timestamp? createdAt,
  }) {
    return GenericPost(
      postName: postName ?? this.postName,
      uid: uid ?? this.uid,
      image: image ?? this.image,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postName': postName,
      'uid': uid,
      'image': image,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt,
    };
  }

  factory GenericPost.fromMap(Map<String, dynamic> map) {
    return GenericPost(
      postName: map['postName'] as String,
      uid: map['uid'] as String,
      image: map['image'] as String,
      likes: List<String>.from((map['likes'] as List<dynamic>)),
      comments: List<dynamic>.from((map['comments'] as List<dynamic>)),
      createdAt: map['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());

}
