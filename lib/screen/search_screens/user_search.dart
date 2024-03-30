import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:fitness_social_app/widgets/mini_profie.dart';
import 'package:fitness_social_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSearch extends ConsumerStatefulWidget {
  const UserSearch({Key? key}) : super(key: key);

  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends ConsumerState<UserSearch> {
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  User? user;
  List<String> ids = [];
  TextEditingController searchController = TextEditingController();
  ValueNotifier<String> searchTerm = ValueNotifier("");

  changeTerm(String hello) {
    searchTerm.value = searchController.text;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = ref.read(userProvider);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: StreamBuilder(
              stream: users.doc(user!.uid).collection('following').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.active) {
                  final docs = snapshot.data!.docs.toList();
                  List<String> ids = [user!.uid];
                  for (var i = 0; i < docs.length; i++) {
                    ids.add(docs[i].id);
                  }
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTextField(
                            onChange: changeTerm,
                            textController: searchController,
                            hintText: "Search Users"),
                      ),
                      ValueListenableBuilder(
                          valueListenable: searchTerm,
                          builder: (context, searchTerm, child) {
                            return StreamBuilder(
                                stream: searchController.text == ""
                                    ? users
                                        .where("uid", whereNotIn: ids)
                                        .limit(5)
                                        .snapshots()
                                    : users
                                        .where("username",
                                            isGreaterThanOrEqualTo:
                                                searchTerm.trim())
                                        .where("username",
                                            isLessThanOrEqualTo:
                                                "${searchTerm.trim()}\uf7ff")
                                        .limit(5)
                                        .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.connectionState ==
                                          ConnectionState.active) {
                                    final data = snapshot.data!.docs.toList();
                                    return ListView.builder(
                                      padding: const EdgeInsets.all(8),
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return MiniProfie(
                                                userId: data[index].id)
                                            .animate()
                                            .shimmer();
                                      },
                                    );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                });
                          }),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
    );
  }
}
