import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/commons/commons.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/comment_model.dart';
import 'package:fitness_social_app/models/generic_post_model.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:fitness_social_app/widgets/comment_widget.dart';
import 'package:fitness_social_app/widgets/image_widget.dart';
import 'package:fitness_social_app/widgets/mini_profie.dart';
import 'package:fitness_social_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewPost extends ConsumerStatefulWidget {
  const ViewPost({Key? key, required this.post, required this.postId})
      : super(key: key);
  final GenericPost post;
  final String postId;

  @override
  _ViewPostState createState() => _ViewPostState();
}

class _ViewPostState extends ConsumerState<ViewPost> {
  User? user;

  bool isLiked = false;
  int likeCount = 0;
  GenericPostServices? genericPostServices;
  var comments = [];
  @override
  void initState() {
    user = ref.read(userProvider);
    genericPostServices = ref.read(genericPostServicesProvider);
    isLiked = widget.post.likes.contains(user!.uid);
    likeCount = widget.post.likeCount;
    comments = widget.post.comments.reversed.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final imageProvier =
        MultiImageProvider([ExtendedImage.network(widget.post.image).image]);

    TextEditingController commentField = TextEditingController();

    void like() {
      setState(() {
        genericPostServices!.likePost(widget.postId, user!.uid, isLiked);
        isLiked = !isLiked;

        if (isLiked) {
          likeCount++;
        } else {
          likeCount--;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.post.postName,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.post.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;

                final thisUser = UserServices().mapSingleUser(data);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MiniProfie(userId: thisUser.uid),
                );
              } else {
                return Container();
              }
            },
          ),
          GestureDetector(
            onTap: () {
              showImageViewerPager(context, imageProvier);
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                height: 500,
                width: double.infinity,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ImageWidget(
                      url: widget.post.image,
                    )),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      like();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: isLiked
                          ? Icon(
                              Icons.favorite,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : const Icon(Icons.favorite_outline),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text(likeCount.toString()))
                ],
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    showDragHandle: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          height: 600,
                          child: Stack(
                            fit: StackFit.expand,
                            clipBehavior: Clip.antiAlias,
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: comments.isNotEmpty
                                    ? SizedBox(
                                        height: 520,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          // physics:
                                          //     NeverScrollableScrollPhysics(),

                                          itemCount: comments.length,
                                          // reverse: true,
                                          itemBuilder: (context, index) {
                                            CommentModel comment = CommentModel(
                                                uid: comments[index]['uid'],
                                                comment: comments[index]
                                                    ['comment']);
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onLongPress: () {
                                                  setState(() {
                                                    if (comment.uid ==
                                                        user!.uid) {
                                                      GenericPostServices()
                                                          .deleteComment(
                                                              widget.postId,
                                                              comment);
                                                      comments.removeAt(index);
                                                    }
                                                  });
                                                },
                                                child: CommentWidget(
                                                    commentModel: comment),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : const Center(
                                        child: Text('No Comments on This Post'),
                                      ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: double.infinity,
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.only(bottom: 22.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: CustomTextField(
                                            textController: commentField,
                                            hintText:
                                                'Add a Comment to this post'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (commentField.text.isNotEmpty) {
                                              setState(() {
                                                comments.insert(0, {
                                                  'uid': user!.uid,
                                                  'comment': commentField.text
                                                });
                                              });
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              await genericPostServices!
                                                  .comment(
                                                      widget.postId,
                                                      user!.uid,
                                                      commentField.text);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(Commons()
                                                      .snackBarMessage(
                                                          'comment cannot be empty',
                                                          Colors.red));
                                            }
                                            commentField.text = '';
                                          },
                                          child: Icon(
                                            Icons.post_add_rounded,
                                            size: 32,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.0),
                      child: Icon(Icons.comment_outlined),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text(comments.length.toString()),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.share_outlined),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
