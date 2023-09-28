import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/generic_post_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GenericPostWidget extends StatefulWidget {
  const GenericPostWidget({Key? key, required this.post}) : super(key: key);

  final GenericPost post;

  @override
  _GenericPostWidgetState createState() => _GenericPostWidgetState();
}

class _GenericPostWidgetState extends State<GenericPostWidget> {
  final user = FirebaseAuth.instance.currentUser;

  GenericPostServices genericPostServices = GenericPostServices();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(RouteConstants.viewPostScreen, extra: widget.post);
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
                        if (snapshot.hasData) {
                          Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;

                          final thisUser = UserServices().mapSingleUser(data);

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(thisUser.profileUrl),
                              ),
                              Text("  ${thisUser.username}"),
                            ],
                          );
                        } else {
                          return Text('error');
                        }
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.post.image,

                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              height: 150,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            print(error);
                            return (const Center(
                              child: Text('This Image is Invalid'),
                            ));
                          },
                          // width: double.infinity,
                          // height: double.maxFinite,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(widget.post.postName),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: widget.post.likes.contains(user!.uid)
                                      ? Icon(Icons.favorite)
                                      : Icon(Icons.favorite_outline),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: widget.post.likes.contains(user!.uid)
                                    ? Text(widget.post.likes.length.toString())
                                    : Text('0'),
                              )
                            ],
                          ),
                          Icon(Icons.comment_outlined),
                          Icon(Icons.share_outlined),
                        ],
                      ),
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
