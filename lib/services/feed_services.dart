import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_social_app/models/generic_post_model.dart';

class FeedServices {
  // final postQuery = FirebaseFirestore.instance
  //     .collection('generic_posts')
  //     .orderBy('createdAt', descending: true)
  //     .withConverter(
  //       fromFirestore: (snapshot, _) => GenericPost.fromMap(snapshot.data()!),
  //       toFirestore: (post, _) => post.toMap(),
  //     );

  Query<GenericPost> fetchPosts(uid) {
    final postQuery = FirebaseFirestore.instance
        .collection('generic_posts')
        .orderBy('uid')
        .orderBy('createdAt', descending: true)
        .where('uid', isNotEqualTo: uid)
        .withConverter(
          fromFirestore: (snapshot, _) => GenericPost.fromMap(snapshot.data()!),
          toFirestore: (post, _) => post.toMap(),
        );

    return postQuery;
  }

  Query<GenericPost> fetchUserPosts(uid) {
    final postQuery = FirebaseFirestore.instance
        .collection('generic_posts')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .withConverter(
          fromFirestore: (snapshot, _) => GenericPost.fromMap(snapshot.data()!),
          toFirestore: (post, _) => post.toMap(),
        );

    return postQuery;
  }
}
