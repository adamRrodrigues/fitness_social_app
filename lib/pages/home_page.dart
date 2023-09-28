import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/generic_post_model.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/widgets/generic_post_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with KeepAliveParentDataMixin {
  var scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {}
    });
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('generic_posts')
                .where('uid',
                    isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active &&
                  snapshot.hasData) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return ListView(
                      controller: scrollController,
                      children: snapshot.data!.docs.map((e) {
                        // Map<String, dynamic> data = e as Map<String, dynamic>;
                        GenericPost thisPost =
                            GenericPostServices().mapDocPost(e);
                        return GenericPostWidget(post: thisPost);
                      }).toList());
                } else {
                  return Center(
                    child: Text('No Posts'),
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
  
  @override
  void detach() {
    // TODO: implement detach
  }
  
  @override
  // TODO: implement keptAlive
  bool get keptAlive => true;
}
