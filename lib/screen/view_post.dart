import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/comment_model.dart';
import 'package:fitness_social_app/models/generic_post_model.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:fitness_social_app/widgets/comment_widget.dart';
import 'package:fitness_social_app/widgets/image_widget.dart';
import 'package:fitness_social_app/widgets/mini_profie.dart';
import 'package:fitness_social_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ViewPost extends StatefulWidget {
  const ViewPost({Key? key, required this.post, required this.postId})
      : super(key: key);
  final GenericPost post;
  final String postId;

  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  final user = FirebaseAuth.instance.currentUser;

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
    final imageProvier =
        MultiImageProvider([ExtendedImage.network(widget.post.image).image]);

    TextEditingController commentField = TextEditingController();

    GenericPostServices genericPostServices = GenericPostServices();

    void like() {
      setState(() {
        genericPostServices.likePost(widget.postId, user!.uid, isLiked);
        isLiked = !isLiked;

        if (isLiked) {
          likeCount++;
        } else {
          likeCount--;
        }
      });
    }

    void showComments() {
      showModalBottomSheet(
        enableDrag: false,
        useSafeArea: true,
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                border:
                    Border.all(color: Theme.of(context).colorScheme.primary),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Center(
                    child: Text(
                      'Comments',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                widget.post.comments.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: widget.post.comments.length,
                          itemBuilder: (context, index) {
                            CommentModel comment = CommentModel(
                                uid: widget.post.comments[index]['uid'],
                                comment: widget.post.comments[index]
                                    ['comment']);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CommentWidget(commentModel: comment),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Text('No Comments on This Post'),
                      ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                              textController: commentField,
                              hintText: 'Add a Comment to this post'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            );
                            if (commentField.text.isNotEmpty) {
                              await genericPostServices.comment(widget.postId,
                                  user!.uid, commentField.text);
                            } else {}

                            Navigator.pop(context);
                            commentField.text = '';
                          },
                          child: Icon(
                            Icons.post_add_rounded,
                            size: 32,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.post.postName),
          elevation: 0,
        ),
        body: SafeArea(
            child: Stack(
          children: [
            Column(
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
                        child: MiniProfie(user: thisUser),
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
                      height: 300,
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
                            child: Text(likeCount.toString()))
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        showComments();
                      },
                      child: Row(
                        children: [
                          const Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(Icons.comment_outlined),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Text(widget.post.comments.length.toString()),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.share_outlined),
                  ],
                ),
              ],
            ),
          ],
        )));
  }
}
