import 'package:fitness_social_app/components/user_tile.dart';
import 'package:fitness_social_app/pages/dm_page.dart';
import 'package:fitness_social_app/services/chat_services.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => ChatState();
}

void haha() {
  print("haha");
}

class ChatState extends State<Chat> {
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Chat",
        ),
        // actions: [IconButton(onPressed: haha, icon: Icon(Icons.chat))],
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        // return list view
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  // Build Individual items
  Widget _buildUserListItem(
    Map<String, dynamic> userData,
    BuildContext context,
  ) {
    // display all users except current user

    String username = userData['username'];

    if (userData['uid'] != _chatService.getCurrentUser()!.uid) {
      return UserTile(
        text: username,
        profileUrl: userData['profileUrl'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DmPage(
                username: username,
                receiverID: userData['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
