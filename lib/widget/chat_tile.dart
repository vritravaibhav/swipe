// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:instagramclone/Resources/auth_methods.dart';

import '../models/user.dart';
import '../screens/chatScreenPersonal.dart';

class ChatTile extends StatefulWidget {
  final String uid;
  final data;
  const ChatTile({
    Key? key,
    required this.data,
    required this.uid,
  }) : super(key: key);

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  bool isLoading = false;
  User? user;
  getUser() async {
    user = await AuthMethods().getUser(widget.uid);
    isLoading = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey,
          backgroundImage: NetworkImage(
              user!.photoUrl), // Display the first letter of the name
        ),
        title: Text(user!.username),
        subtitle: Text(
            widget.data["Chat"][widget.data["Chat"].length - 1]["chatData"]),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPagePersonal(
                      snap: widget.data["docId"],
                      user: user,
                    )),
          );
        },
      );
    }
  }
}
