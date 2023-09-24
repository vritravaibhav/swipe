import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/Resources/auth_methods.dart';
import 'package:instagramclone/widget/receiver_row_view.dart';
import 'package:instagramclone/widget/sender_row_view.dart';

import '../models/user.dart' as model;

class ChatPage extends StatefulWidget {
  List<dynamic>? messages = [];
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  //  z=  FirebaseFirestore.instance.collection('users').doc('GlobalChat').get(chat(['address', 'postcode']));

  var x;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    vaibhav();
  }

  bool goodies = true;
  bool userAccess = false;
  model.User? user;

  Future<void> vaibhav() async {
    // });
    // await Future.delayed(const Duration(seconds: 2));
    await FirebaseFirestore.instance
        .collection('users')
        .doc("GlobalChat")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        x = documentSnapshot.data();
        widget.messages = x["Chat"];

        // print("pragma");
        goodies = false;
      }
    });
    if (!userAccess) {
      user =
          await AuthMethods().getUser(FirebaseAuth.instance.currentUser!.uid);
      userAccess = true;
    }
    isLoading = true;
    setState(() {});
  }

  void sendMessage() {
    FirebaseFirestore.instance.collection("users").doc("GlobalChat").update({
      "Chat": FieldValue.arrayUnion([
        {
          "chatData": _messageController.text,
          "datetime": DateTime.now(),
          "uid": FirebaseAuth.instance.currentUser!.uid,
          "photoUrl": user!.photoUrl
        }
      ])
    });
    _messageController.clear();
  }

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    //  var m = Provider.of<TypeProvdier>(context).messages;
    if (goodies) {
      FirebaseFirestore.instance
          .collection('users')
          .doc("GlobalChat")
          .snapshots()
          .listen((event) {
        //List<dynamic> manoj = [];
        // manoj = event.data()!["Chat"];

        // vaibhav();
        print("loove");
        vaibhav();

        //  print(widget.messages.length);
      });
    }
    goodies = true;

    if (!isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.messages?.length ?? 0,
                  itemBuilder: (context, index) {
                    return widget.messages![widget.messages!.length - index - 1]
                                ["uid"] ==
                            FirebaseAuth.instance.currentUser!.uid
                        ? SenderRowView(
                            senderMessage: widget
                                .messages![widget.messages!.length - index - 1],
                          )
                        : ReceiverRowView(
                            receiverMessage: widget
                                .messages![widget.messages!.length - index - 1],
                          );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                        ),
                      ),
                    ),
                    //

                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (_messageController.text.isNotEmpty) {
                          sendMessage();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
