import 'package:flutter/material.dart';
import 'package:instagramclone/screens/chat_screen.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

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
            subtitle: Text("thanks"),
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
            subtitle: Text("okay i will update"),
            onTap: () {
              // Navigate to the chat page for this user
              // You can implement this navigation as needed
            },
          )
        ]),
      ),
    );
  }
}
