import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/providers/typePro.dart';

import 'package:instagramclone/screens/Edit_profile_Screen.dart';
import 'package:instagramclone/screens/chatScreenPersonal.dart';

import 'package:instagramclone/utils/utils.dart';
import 'package:instagramclone/widget/post_card.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:instagramclone/models/user.dart' as model;

import '../Resources/auth_methods.dart';
import '../Resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../widget/follow_button.dart';
import 'chat_list.dart';
import 'login_screens.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = true;
  bool matched = false;
  List matchedList = [];
  final TextEditingController _name = TextEditingController();
  TextEditingController _bio = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      matchedList = userSnap['matched'];
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      matched =
          userData["matched"].contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }

    setState(() {
      isLoading = false;
    });
  }

  onSend(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Yo!!!!!!!"),
            children: [
              Lottie.network(
                  'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json'),
              // SimpleDialogOption(
              //   padding: const EdgeInsets.all(20),
              //   child: const Text('Cancel'),
              //   onPressed: () async {
              //     Navigator.of(context).pop();
              //   },
              // )
            ],
          );
        });
  }

  editname(BuildContext context) {
    //
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Enter your new name"),
            children: [
              TextField(
                controller: _name,
                decoration: const InputDecoration(),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //  print(FirebaseAuth.instance.currentUser!.uid == userData["uid"]);
    final x = Provider.of<TypeProvdier>(context);
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                userData['username'],
              ),
              centerTitle: false,
              actions: [
                userData["uid"] != FirebaseAuth.instance.currentUser!.uid
                    ? const SizedBox()
                    : IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileScreen()),
                          );
                          return;
                          showModalBottomSheet<void>(
                            isScrollControlled: true,
                            // enableDrag: true,

                            context: context,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: SizedBox(
                                  height: 200,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          TextField(
                                            decoration: InputDecoration(
                                              hintText: "Enter Your Name",
                                            ),
                                            controller: _name,
                                            autofocus: true,
                                          ),
                                          ElevatedButton(
                                            child: const Text(' Save'),
                                            onPressed: () async {
                                              if (_name.text == "") {
                                                showSnackBar(
                                                    "We can't change your name",
                                                    context);
                                                return;
                                              }
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(userData["uid"])
                                                  .update(
                                                      {"username": _name.text});
                                              Navigator.pop(context);
                                              await getData();
                                              x.hearing();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.edit))
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          userData['photoUrl'].toString().isNotEmpty
                              ? ClipOval(
                                  child: SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: CachedNetworkImage(
                                      imageUrl: userData['photoUrl'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : const CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.blue,
                                ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? Row(
                                            children: [
                                              matchedList.isNotEmpty
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        showModalBottomSheet(
                                                          context: context,
                                                          builder: (context) =>
                                                              Container(
                                                            color: const Color
                                                                .fromARGB(
                                                                255, 255, 2, 2),
                                                            constraints: BoxConstraints(
                                                                minHeight: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.4),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  width: 50,
                                                                  height: 5,
                                                                  margin: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          10),
                                                                  decoration: BoxDecoration(
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          193,
                                                                          142,
                                                                          159),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20)),
                                                                ),
                                                                const Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                10),
                                                                    child: Text(
                                                                        'You finally matched with'),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Stack(
                                                                    children: [
                                                                      Positioned.fill(
                                                                          child:
                                                                              Container()),
                                                                      Positioned(
                                                                        right:
                                                                            0,
                                                                        child: Lottie.network(
                                                                            'https://lottie.host/dfacd21c-c989-4589-a69d-2b43b61692f0/0cnbUaJHEo.json',
                                                                            height:
                                                                                MediaQuery.of(context).size.height * 0.4),
                                                                      ),
                                                                      Column(
                                                                        children:
                                                                            List.generate(
                                                                          matchedList
                                                                              .length,
                                                                          (index) {
                                                                            return FutureBuilder<model.User>(
                                                                                future: AuthMethods().getUser(matchedList[index]),
                                                                                builder: (context, snapshot) {
                                                                                  if (snapshot.hasData) {
                                                                                    var user = snapshot.data;
                                                                                    return Container(
                                                                                      margin: const EdgeInsets.all(10),
                                                                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                                                      decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.amber), borderRadius: BorderRadius.circular(20)),
                                                                                      child: Column(
                                                                                        children: [
                                                                                          Row(
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              user!.photoUrl.isNotEmpty
                                                                                                  ? SizedBox(
                                                                                                      height: 30,
                                                                                                      child: ClipOval(child: CachedNetworkImage(imageUrl: user.photoUrl.toString())),
                                                                                                    )
                                                                                                  : Container(),
                                                                                              const SizedBox(
                                                                                                width: 12,
                                                                                              ),
                                                                                              Text(user.username.toString()),
                                                                                              const Spacer(),
                                                                                              ElevatedButton(
                                                                                                  onPressed: () async {
                                                                                                    String docid = FirebaseAuth.instance.currentUser!.uid.toString() + matchedList[index].toString();
                                                                                                    final doc = await FirebaseFirestore.instance.collection('chats').doc(docid).get();

                                                                                                    if (doc.exists) {
                                                                                                      Navigator.push(
                                                                                                          context,
                                                                                                          MaterialPageRoute(
                                                                                                              builder: (context) => ChatPagePersonal(
                                                                                                                    snap: docid,
                                                                                                                    user: user,
                                                                                                                  )));
                                                                                                    } else {
                                                                                                      String docid = matchedList[index].toString() + FirebaseAuth.instance.currentUser!.uid.toString();

                                                                                                      Navigator.push(
                                                                                                          context,
                                                                                                          MaterialPageRoute(
                                                                                                              builder: (context) => ChatPagePersonal(
                                                                                                                    snap: docid,
                                                                                                                    user: user,
                                                                                                                  )));
                                                                                                    }
                                                                                                  },
                                                                                                  child: const Text('Chat')),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    );
                                                                                  }
                                                                                  return Container();
                                                                                });
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10,
                                                                vertical: 10),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .red)),
                                                        child: const Text(
                                                          'Matched List',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                              FollowButton(
                                                text: 'Sign Out',
                                                backgroundColor:
                                                    mobileBackgroundColor,
                                                textColor: primaryColor,
                                                borderColor: Colors.grey,
                                                function: () async {
                                                  await AuthMethods().signOut();

                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginScreen(),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          )
                                        : matched
                                            ? const FollowButton(
                                                backgroundColor: Colors.grey,
                                                borderColor: Colors.black,
                                                text: "Matched",
                                                textColor: Colors.black38)
                                            : isFollowing
                                                ? FollowButton(
                                                    text: 'Unsend Super Like',
                                                    backgroundColor:
                                                        Colors.white,
                                                    textColor: Colors.black,
                                                    borderColor: Colors.grey,
                                                    function: () async {
                                                      bool x =
                                                          await FirestoreMethods()
                                                              .followUser(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        userData['uid'],
                                                      );
                                                      if (x) {
                                                        onSend(context);
                                                      }

                                                      setState(() {
                                                        isFollowing = false;
                                                        followers--;
                                                      });
                                                    },
                                                  )
                                                : FollowButton(
                                                    text: 'Send Super like',
                                                    backgroundColor:
                                                        Colors.blue,
                                                    textColor: Colors.white,
                                                    borderColor: Colors.blue,
                                                    function: () async {
                                                      bool x =
                                                          await FirestoreMethods()
                                                              .followUser(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        userData['uid'],
                                                      );
                                                      if (x) {
                                                        setState(() {
                                                          matched = true;
                                                        });
                                                        onSend(context);
                                                      }

                                                      setState(() {
                                                        isFollowing = true;
                                                        followers++;
                                                      });
                                                    },
                                                  )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          userData['bio'],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 3,
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    //  print("$snapshot ssddda");
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    int length = (snapshot.data! as dynamic).docs.length;

                    return length != 0
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 1.5,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap =
                                  (snapshot.data! as dynamic).docs[index];
                              return InkWell(
                                onTap: () {
                                  showDialog(
                                      //contentPadding: EdgeInsets.zero,
                                      context: context,
                                      builder: (context) {
                                        return SimpleDialog(
                                          insetPadding: const EdgeInsets.all(0),
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          children: [
                                            PostCard(
                                                snap: snap,
                                                anon: false,
                                                isOnPop: true)
                                          ],
                                        );
                                      });
                                },
                                child: CachedNetworkImage(
                                  imageUrl: snap['postUrl'],
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.2),
                              child: const Text(
                                'No post yet...Try it..',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          );
                  },
                )
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
