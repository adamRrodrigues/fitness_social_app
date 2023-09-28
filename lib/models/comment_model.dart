// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CommentModel {
  final String uid;
  final String comment;
  CommentModel({
    required this.uid,
    required this.comment,
  });

  

  CommentModel copyWith({
    String? uid,
    String? comment,
  }) {
    return CommentModel(
      uid: uid ?? this.uid,
      comment: comment ?? this.comment,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'comment': comment,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      uid: map['uid'] as String,
      comment: map['comment'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) => CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CommentModel(uid: $uid, comment: $comment)';

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.comment == comment;
  }

  @override
  int get hashCode => uid.hashCode ^ comment.hashCode;
}
