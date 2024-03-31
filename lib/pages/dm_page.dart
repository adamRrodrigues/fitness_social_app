import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_social_app/components/chat_bubble.dart';
import 'package:fitness_social_app/models/user_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/services/chat_services.dart';
import 'package:fitness_social_app/services/fallback_services.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DmPage extends StatefulWidget {
  final String username;
  final String receiverID;

  const DmPage({
    super.key,
    required this.username,
    required this.receiverID,
  });

  @override
  State<DmPage> createState() => _DmPageState();
}

class _DmPageState extends State<DmPage> {
  final TextEditingController _messageController = TextEditingController();

  // chat service
  final ChatService _chatService = ChatService();

  // for textfiled focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    myFocusNode.addListener(
      () {
        if (myFocusNode.hasFocus) {
          //  cause a delay so that the keyboard has time to show up
          // then calculate the amount of remaining space
          // and scroll down

          Future.delayed(
              const Duration(
                milliseconds: 500,
              ),
              () => scrollDown());
        }
      },
    );

    // wait for the listview to be built then scroll down
    // Future.delayed(
    //   const Duration(
    //     milliseconds: 500,
    //   ),
    //   () => scrollDown(),
    // );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // Scroll controller
  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      // send the message
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);

      // clear the text controller
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.username),
      ),
      body: Column(
        children: [
          // displaying all the messages
          Expanded(
            child: _buildMessageList(),
          ),

          // display user input
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _chatService.getCurrentUser()!.uid;

    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        // errors
        if (snapshot.hasError) {
          return const Text("Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    bool isCurrent = data['senderID'] == _chatService.getCurrentUser()!.uid;

    var alignment = isCurrent ? Alignment.centerRight : Alignment.centerLeft;

    // align messages to the righ if sender is the current user, otherwise left

    if (data['isShared'] ?? false) {
      return Container(
        alignment: alignment,
        child: harambe(
          imgUrl: data["imgUrl"],
          postTitle: data["postTitle"],
          // senderId: data["senderID"],
          postId: data['postId'],
        ),
      );
    } else {
      return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              isCurrent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Text(data["message"]),
            ChatBubble(message: data["message"], isCurrentUser: isCurrent)
          ],
        ),
      );
    }
  }

  Widget myImager(String imgUrl) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          imgUrl,
          fit: BoxFit.cover,

          alignment: Alignment.center,
          height: 100.0,
          // height: double.infinity,
          width: double.infinity,
          // width: imageWidth,
        ),
      ),
    );
  }

  Widget harambe({
    required String imgUrl,
    required String postTitle,
    required String postId,
  }) {
    double widgetWidth = MediaQuery.of(context).size.width - 100;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16.0),
      // height: 266,
      width: widgetWidth,
      decoration: BoxDecoration(
        color: Color.fromARGB(153, 48, 47, 47),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          myImager(imgUrl),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              postTitle,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () async {
              // Navigator.pushNamed(context, RouteConstants.userPage,
              // arguments: {"extra": senderId});

              // FallbackService().test(senderId);
              // return;

              // var gay = await UserServices().getUser(senderId);

              context.pushNamed(
                RouteConstants.fetchingWorkoutScreen,
                extra: postId,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Visit'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              obscureText: false,
              focusNode: myFocusNode,
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "Type a message",
              ),
            ),
          ),
          IconButton(onPressed: sendMessage, icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
