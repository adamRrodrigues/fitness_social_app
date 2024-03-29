import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:fitness_social_app/widgets/mini_profie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowageScreen extends ConsumerStatefulWidget {
  const FollowageScreen({Key? key, required this.type, required this.uid})
      : super(key: key);
  final String type;
  final String uid;

  @override
  _FollowageScreenState createState() => _FollowageScreenState();
}

class _FollowageScreenState extends ConsumerState<FollowageScreen> {
  User? user;
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  List<String> ids = [];

  @override
  void initState() {
    super.initState();
    user = ref.read(userProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              StreamBuilder(
                stream: widget.type == "following"
                    ? users.doc(widget.uid).collection('following').snapshots()
                    : users.doc(widget.uid).collection('followers').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.active) {
                    final docs = snapshot.data!.docs.toList();
                    // List<String> ids = [widget.uid];
                    for (var i = 0; i < docs.length; i++) {
                      ids.add(docs[i].id);

                      print(docs[i].id);
                    }
                    return StreamBuilder(
                      stream: users.where("uid", whereIn: ids).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.connectionState ==
                                ConnectionState.active) {
                          final data = snapshot.data!.docs.toList();
                          if (data.isNotEmpty) {
                            return ListView.builder(
                              padding: const EdgeInsets.all(8),
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final user =
                                    UserServices().mapDocUser(data[index]);
                                return Expanded(
                                  child: MiniProfie(
                                    userId: data[index].id,
                                    userModel: user,
                                  ).animate().shimmer(),
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: Text("No ${widget.type}"),
                            );
                          }
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
