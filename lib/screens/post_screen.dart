//import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as model;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/Resources/firestore_methods.dart';
import 'package:instagramclone/providers/UserProvider.dart';
import 'package:instagramclone/providers/typePro.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  bool uploadScreen = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final model.FirebaseAuth _auth = model.FirebaseAuth.instance;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tweetController = TextEditingController();

  void postImage(
      String uid, String username, String profImage, bool isAnonymous) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text,
          _file!,
          uid,
          username,
          profImage,
          isAnonymous);
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        clearImage();
        showSnackBar("posted", context);
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a post"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a pHOTO'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('choose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                    if (file != null) {
                      uploadScreen = true;
                    }
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      uploadScreen = false;
      _file = null;
    });
  }

  void anonymoustweet() async {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Tweet Anonimously"),
            children: [
              Container(
                height: 200,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      textAlignVertical: TextAlignVertical.center,
                      expands: true,
                      //keyboardType: TextInputType.,
                      maxLines: null,

                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      controller: _tweetController,
                      //decoration: InputDecoration(),
                    ),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () async {
                    FirestoreMethods().uploadTweets(
                      _tweetController.text,
                      
                    );
                    Navigator.pop(context);
                    showSnackBar("Successfully Tweeted", context);
                    _tweetController.clear();
                  },
                  child: const Text(
                    "Tweet",
                    style: TextStyle(
                        letterSpacing: Checkbox.width,
                        fontSize: Checkbox.width),
                  )),
            ],
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    final x = Provider.of<TypeProvdier>(context);
    return !uploadScreen
        ?
        //  Center(
        //     child: IconButton(
        //         icon: const Icon(Icons.upload),
        //         onPressed: () {
        //           _selectImage(context);
        //         }),
        //   )
        Container(
            decoration: BoxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: InkWell(
                    onTap: () {
                      x.isAnonymous = false;
                      _selectImage(context);
                    },
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/weetlogo.jpg'.toString()),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      anonymoustweet();
                    },
                    child: Text(
                      "Tap here for anonymous   tweet",
                      style: TextStyle(color: Colors.black, fontSize: 23),
                    ),
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: InkWell(
                      onTap: () {
                        x.isAnonymous = true;
                        _selectImage(context);
                      },
                    ))
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text("Post to"),
              centerTitle: false,
              actions: [
                TextButton(
                    onPressed: () => postImage(
                        user.uid, user.username, user.photoUrl, x.isAnonymous),
                    child: const Text(
                      'Post',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ),
            body: Column(children: [
              isLoading
                  ? const LinearProgressIndicator()
                  : Padding(padding: EdgeInsets.only(top: 0)),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Write a caption",
                        border: InputBorder.none,
                      ),
                      controller: _descriptionController,
                      maxLines: 8,
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: AspectRatio(
                      aspectRatio: 487 / 451,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: MemoryImage(_file!),
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              )
            ]),
          );
  }
}
