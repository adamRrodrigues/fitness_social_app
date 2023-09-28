import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/comment_model.dart';
import 'package:fitness_social_app/models/generic_post_model.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:fitness_social_app/widgets/comment_widget.dart';
import 'package:fitness_social_app/widgets/mini_profie.dart';
import 'package:fitness_social_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ViewPost extends StatelessWidget {
  const ViewPost({Key? key, required this.post, required this.postId})
      : super(key: key);
  final GenericPost post;
  final String postId;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final imageProvier = MultiImageProvider([Image.network(post.image).image]);

    TextEditingController commentField = TextEditingController();
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  title: Text(
                    post.postName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  snap: true,
                  floating: true,
                )
              ],
          body: SafeArea(
            child: Column(
              children: [
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(post.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;

                      final thisUser = UserServices().mapSingleUser(data);

                      return MiniProfie(user: thisUser);
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
                    padding: EdgeInsets.all(8),
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            post.image,
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.favorite_outline),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.comment_outlined),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.share_outlined),
                    ),
                  ],
                ),
                Center(
                  child: Text(
                    'Comments',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: post.comments.length,
                    itemBuilder: (context, index) {
                      String comment = post.comments[index]['comment'];
                      return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(post.comments[index]['uid'])
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;

                            final thisUser = UserServices().mapSingleUser(data);

                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CommentWidget(
                                    userModel: thisUser,
                                    commentModel: CommentModel(
                                        comment: comment,
                                        uid: post.comments[index]['uid'])));
                          } else {
                            return Center(
                              child: Text('Loading Comment'),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                          child: CustomTextField(
                              textController: commentField,
                              hintText: 'Comment something')),
                      GestureDetector(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );
                          if (commentField.text != '') {
                            await GenericPostServices()
                                .comment(postId, user!.uid, commentField.text);
                          }

                          Navigator.pop(context);
                          commentField.text = '';
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.publish_rounded,
                            size: 36,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
