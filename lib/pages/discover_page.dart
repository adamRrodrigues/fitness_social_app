import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/user_model.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:fitness_social_app/widgets/mini_profie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscoverPage extends ConsumerStatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends ConsumerState<DiscoverPage>
    with AutomaticKeepAliveClientMixin {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  User? user;

  @override
  void initState() {
    user = ref.read(userProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Discover"),
            backgroundColor: Theme.of(context).colorScheme.background,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: users.get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView(
                      children: snapshot.data!.docs
                          .where((element) => element.id != user!.uid)
                          .map((e) {
                    // Map<String, dynamic> data = e as Map<String, dynamic>;
                    UserModel thisUser = UserServices().mapDocUser(e);

                    return MiniProfie(user: thisUser);
                  }).toList());
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
