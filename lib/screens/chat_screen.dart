import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/providers/typePro.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  List<dynamic> messages = [];
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
    // vaibhav();
  }

  bool goodies = false;

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
        isLoading = true;
        // print("pragma");

        setState(() {});
      }
    });
  }

  ScrollController _scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    //  var m = Provider.of<TypeProvdier>(context).messages;

    FirebaseFirestore.instance
        .collection('users')
        .doc("GlobalChat")
        .snapshots()
        .listen((event) {
      //List<dynamic> manoj = [];
      // manoj = event.data()!["Chat"];
      // vaibhav();

      vaibhav();
      //  print(widget.messages.length);
    });

    if (!isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Chat App'),
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
                  itemCount: widget.messages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Align(
                          alignment: widget.messages[index]["uid"] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Alignment.topRight
                              : Alignment.topLeft,

                          // alignment: Alignment.bottomRight,

                          // _messages[index]["uid"]==FirebaseAuth.instance.currentUser.uid?
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7))),

                            //
                            child: SizedBox(
                              width: (MediaQuery.of(context).size.width) / 1.4,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: SizedBox(
                                      child: Text(
                                        widget.messages[widget.messages.length -
                                            index -
                                            1]["chatData"],
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        //  overflow: TextOverflow.clip,
                                        // textDirection: TextDirection.rtl,
                                        // textAlign: TextAlign.justify,
                                        //softWrap: true,
                                        // maxLines: 5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                        ),
                      ),
                    ),
                    //

                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if (_messageController.text.isNotEmpty) {
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc("GlobalChat")
                              .update({
                            "Chat": FieldValue.arrayUnion([
                              {
                                "chatData": _messageController.text,
                                "datetime": DateTime.now(),
                                "uid": FirebaseAuth.instance.currentUser!.uid,
                              }
                            ])
                          });
                          _messageController.clear();
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
