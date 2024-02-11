import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/generic_post_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:fitness_social_app/widgets/image_widget.dart';
import 'package:fitness_social_app/widgets/mini_profie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GenericPostWidget extends ConsumerStatefulWidget {
  const GenericPostWidget(
      {Key? key, required this.post, required this.postId, this.mini})
      : super(key: key);

  final GenericPost post;
  final String postId;
  final bool? mini;

  @override
  _GenericPostWidgetState createState() => _GenericPostWidgetState();
}

class _GenericPostWidgetState extends ConsumerState<GenericPostWidget> {
  User? user;

  GenericPostServices? genericPostServices;

  bool isLiked = false;

  @override
  void initState() {
    user = ref.read(userProvider);
    genericPostServices = ref.read(genericPostServicesProvider);
    isLiked = widget.post.likes.contains(user!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void like() {
      genericPostServices!.likePost(widget.postId, user!.uid, isLiked);
      isLiked = !isLiked;
    }

    return GestureDetector(
      onTap: () {
        context.pushNamed(RouteConstants.viewPostScreen,
            extra: widget.post, pathParameters: {'id': widget.postId});
      },
      onLongPress: () {
        if (widget.post.uid == user!.uid) {
          genericPostServices!.deletePost(widget.postId, user!.uid);
        }
      },
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(10),
              border: Border(
                bottom:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              color: Theme.of(context).colorScheme.secondary),
          child: SizedBox(
            // height: 250,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.mini == false
                    ? StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.post.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.active) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;

                            final thisUser = UserServices().mapSingleUser(data);

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MiniProfie(
                                  user: thisUser,
                                  optionalSubText:
                                      '${widget.post.createdAt.toDate().day.toString()}/${widget.post.createdAt.toDate().month.toString()}/${widget.post.createdAt.toDate().year.toString()} '),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 50,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    Text('user'),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return const Text('Error Loading');
                          }
                        },
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.post.postName,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: ClipRRect(
                    // borderRadius: BorderRadius.circular(10),
                    child: ImageWidget(url: widget.post.image),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: like,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: isLiked
                                  ? Icon(
                                      Icons.favorite,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                  : const Icon(Icons.favorite_outline),
                            ),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Text(widget.post.likeCount.toString()))
                        ],
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(Icons.comment_outlined),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Text(widget.post.comments.length.toString()),
                          ),
                        ],
                      ),
                      const Icon(Icons.share_outlined),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
