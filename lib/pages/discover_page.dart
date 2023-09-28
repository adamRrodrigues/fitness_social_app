import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/user_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:fitness_social_app/widgets/mini_profie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Discover"), backgroundColor: Theme.of(context).colorScheme.background, elevation: 0,),
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

                return GestureDetector(
                    onTap: () {
                      context.pushNamed(RouteConstants.userPage,
                          extra: thisUser);
                    },
                    child: MiniProfie(user: thisUser));
              }).toList());
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      )),
    );
  }
}
