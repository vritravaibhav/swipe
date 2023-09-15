import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/Resources/auth_methods.dart';
import 'package:instagramclone/providers/typePro.dart';
import 'package:instagramclone/screens/chatScreenPersonal.dart';
import 'package:instagramclone/screens/chat_screen.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as Model;
import '../providers/UserProvider.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});
  // Future<void> sauravs() async {
  //   print("gpd");
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       print(doc["ggg"]);
  //     });
  //   });
  // }

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
            leading: CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Text("G.C."), // Display the first letter of the name
            ),
            title: Text("Global Chat"),
            subtitle: Text(""),
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
            leading: CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Text("D"), // Display the first letter of the name
            ),
            title: Text("Developer"),
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
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
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
                  // Model.User? user;
                  if (data["uid"][0] ==
                      FirebaseAuth.instance.currentUser!.uid) {
                    user1uid = data["uid"][0];
                  } else {
                    user1uid = data["uid"][1];
                  }
                  getUser1() async {
                    flag.user = await AuthMethods().getUser(user1uid);
                    if (!flag.chatlistflaging) {
                      flag.chatlistflaging = true;
                      flag.hearing();
                    }

                    flag.chatlistflag1 = true;
                  }

                  getUser1();

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueGrey,
                      backgroundImage: NetworkImage(flag.user
                          .photoUrl), // Display the first letter of the name
                    ),
                    title: Text(flag.user.username),
                    subtitle:
                        Text(data["Chat"][data["Chat"].length - 1]["chatData"]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPagePersonal(
                                  snap: data["docId"],
                                )),
                      );
                    },
                  );
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
