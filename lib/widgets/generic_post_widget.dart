import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/generic_post_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:fitness_social_app/widgets/image_widget.dart';
import 'package:fitness_social_app/widgets/mini_profie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GenericPostWidget extends StatefulWidget {
  const GenericPostWidget({Key? key, required this.post, required this.postId})
      : super(key: key);

  final GenericPost post;
  final String postId;

  @override
  _GenericPostWidgetState createState() => _GenericPostWidgetState();
}

class _GenericPostWidgetState extends State<GenericPostWidget> {
  final user = FirebaseAuth.instance.currentUser;

  GenericPostServices genericPostServices = GenericPostServices();

  bool isLiked = false;
  int likeCount = 0;

  @override
  void initState() {
    isLiked = widget.post.likes.contains(user!.uid);
    likeCount = widget.post.likes.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void like() {
      // setState(() {
      genericPostServices.likePost(widget.postId, user!.uid, isLiked);
      isLiked = !isLiked;

      if (isLiked) {
        likeCount++;
      } else {
        likeCount--;
      }
      // });
    }

    return GestureDetector(
      onTap: () {
        context.pushNamed(RouteConstants.viewPostScreen,
            extra: widget.post, pathParameters: {'id': widget.postId});
      },
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.background,
          elevation: 4,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: Theme.of(context).colorScheme.primary, width: 2)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                // height: 250,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.post.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;

                          final thisUser = UserServices().mapSingleUser(data);

                          return MiniProfie(user: thisUser);
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                              height: 50,
                              child: Text(
                                'loading...',
                              ));
                        } else {
                          return const Text('Error Loading');
                        }
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ImageWidget(url: widget.post.image),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(widget.post.postName),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                like();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: isLiked
                                    ? Icon(Icons.favorite, color: Theme.of(context).colorScheme.primary,)
                                    : const Icon(Icons.favorite_outline),
                              ),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Text(likeCount.toString()))
                          ],
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(Icons.comment_outlined),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child:
                                  Text(widget.post.comments.length.toString()),
                            ),
                          ],
                        ),
                        const Icon(Icons.share_outlined),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
