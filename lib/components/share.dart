import 'package:fitness_social_app/components/user_tile.dart';
import 'package:fitness_social_app/pages/dm_page.dart';
import 'package:fitness_social_app/services/chat_services.dart';
import 'package:flutter/material.dart';

ChatService chatService = ChatService();

class ShareGeneric extends StatefulWidget {
  final bool onlyIcon;

  final String postTitle, postId, postImg;

  const ShareGeneric({
    super.key,
    required this.onlyIcon,
    required this.postTitle,
    required this.postId,
    required this.postImg,
  });

  @override
  State<ShareGeneric> createState() => ShareGenericState();
}

class ShareGenericState extends State<ShareGeneric> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("TESTOR ${widget.postId} ${widget.postImg} ${widget.postImg}");

    if (widget.onlyIcon) {
      return GestureDetector(
        onTap: () {
          handleShare(context);
        },
        child: const Icon(Icons.share),
      );
    } else {
      return GestureDetector(
        onTap: () {
          handleShare(
            context,
            postTitle: widget.postTitle,
            postId: widget.postId,
            postImg: widget.postImg,
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0, bottom: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Share",
                style: TextStyle(fontSize: 16.0),
              ),
              Container(),
              const Icon(Icons.share),
            ],
          ),
        ),
      );
    }
  }
}

void handleShare(BuildContext context, {String? postId, postTitle, postImg}) {
  // print("Hello world");

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) {
        return _buildUserList(
          postId: postId,
          postTitle: postTitle,
          postImg: postImg,
        );
      });
}

Widget _buildUserList({String? postId, postTitle, postImg}) {
  return StreamBuilder(
    stream: chatService.getUsersStream(),
    builder: (context, snapshot) {
      // error
      if (snapshot.hasError) {
        return const Text("Error");
      }

      // loading
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Text("Loading...");
      }

      print(snapshot.data);

      // return list view
      return ListView(
        children: snapshot.data!
            .map<Widget>((userData) => _buildUserListItem(
                  userData,
                  context,
                  postId: postId,
                  postImg: postImg,
                  postTitle: postTitle,
                ))
            .toList(),
      );
    },
  );
}

// Build Individual items
Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context,
    {String? postId, postTitle, postImg}) {
  // display all users except current user

  String username = userData['username'];

  if (userData['uid'] != chatService.getCurrentUser()!.uid) {
    return UserTile(
      text: username,
      profileUrl: userData['profileUrl'],
      onTap: () {
        print("$postTitle, $postImg, $postId");
        ChatService().sharePost(
          //
          receiverId: userData['uid'],
          postId: postId,
          postImgUrl: postImg,
          postTitle: postTitle,
          // postId,
          // postImg,
          // postTitle,
        );

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
