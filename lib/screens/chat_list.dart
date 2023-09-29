import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/Resources/auth_methods.dart';
import 'package:instagramclone/providers/typePro.dart';
import 'package:instagramclone/screens/chatScreenPersonal.dart';
import 'package:instagramclone/screens/chat_screen.dart';
import 'package:instagramclone/widget/chat_tile.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as Model;
import '../providers/UserProvider.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  // Future<void> sauravs() async {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        title: Text("Chat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Text("G.C."), // Display the first letter of the name
            ),
            title: const Text("Global Chat"),
            subtitle: const Text(""),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage()),
              );
            },
          ),
          // Divider(
          //   //color: Colors.white,
          //   thickness: 0.1,
          // ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Text("D"), // Display the first letter of the name
            ),
            title: const Text("Developer"),
            subtitle: Text(""),
            onTap: () {
              print("good");
              //  sauravs();
              // Navigate to the chat page for this user
              // You can implement this navigation as needed
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .where("uid",
                    arrayContains: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final flag = Provider.of<TypeProvdier>(context);
              return ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  String user1uid;
                  // // Model.User? user;
                  // Model.User usert = flag.createUser();
                  if (data["uid"][0] ==
                      FirebaseAuth.instance.currentUser!.uid) {
                    user1uid = data["uid"][1];
                  } else {
                    user1uid = data["uid"][0];
                  }
                  // getUser1() async {
                  //   usert = await AuthMethods().getUser(user1uid);
                  //   flag.hearing();
                  //   if (!flag.chatlistflaging) {
                  //     flag.chatlistflaging = true;
                  //   }

                  //   flag.chatlistflag1 = true;
                  // }

                  // getUser1();

                  // return ListTile(
                  //   leading: CircleAvatar(
                  //     backgroundColor: Colors.blueGrey,
                  //     backgroundImage: NetworkImage(usert
                  //         .photoUrl), // Display the first letter of the name
                  //   ),
                  //   title: Text(usert.username),
                  //   subtitle:
                  //       Text(data["Chat"][data["Chat"].length - 1]["chatData"]),
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => ChatPagePersonal(
                  //                 snap: data["docId"],
                  //               )),
                  //     );
                  //   },
                  // );
                  return ChatTile(data: data, uid: user1uid);

                  //}
                }).toList(),
              );
            },
          ),
        ]),
      ),
    );
  }
}
