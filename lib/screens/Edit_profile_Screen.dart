import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/Resources/auth_methods.dart';
import 'package:instagramclone/Resources/storage_methods.dart';
import 'package:instagramclone/responsive/mobile_screen_layout.dart';

import '../models/user.dart' as model;
import '../utils/utils.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Define controller for text fields
  final TextEditingController _nameController = TextEditingController();
  // TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  model.User? user;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  String uid = FirebaseAuth.instance.currentUser!.uid;
  var _image;
  void selectimage() async {
    Uint8List? v = await pickImage(ImageSource.gallery);
    if (v != null) {
      setState(() {
        _image = v;
      });
    }
  }

  Future<void> getUserDetails() async {
    user = await AuthMethods().getUser(uid);
    isloading = true;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isloading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Edit Profile'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () async {
                    if (_bioController.text == "" ||
                        _nameController.text == "") {
                      showSnackBar("Please fill some value", context);
                      return;
                    }
                    isloading = false;
                    setState(() {});
                    if (_image == null) {
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(uid)
                          .update({
                        "username": _nameController.text,
                        "bio": _bioController.text,
                      });
                    } else {
                      String profileurl = await StorageMethods()
                          .uploadImageToStorage('profilePics', _image, false);
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(uid)
                          .update({
                        "username": _nameController.text,
                        "bio": _bioController.text,
                        "photoUrl": profileurl,
                      });
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MobileScreenLayout()),
                        (route) => false);
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: InkWell(
                        onTap: () {
                          selectimage();
                        },
                        child: _image == null
                            ? user!.photoUrl.isNotEmpty
                                ? ClipOval(
                                    child: SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: CachedNetworkImage(
                                        imageUrl: user!.photoUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    //  backgroundImage: AssetImage('assets/profile_image.jpg'), // Replace with user's profile image
                                  )
                                : ClipOval(
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      color: Colors.amber,
                                    ),
                                  )
                            : CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(_image!),
                              )),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  TextFormField(
                    controller: _nameController..text = user!.username,
                    decoration: InputDecoration(
                      hintText: user!.username,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Text(
                  //   'Username',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 16.0,
                  //   ),
                  // ),
                  // TextFormField(
                  //   controller: _usernameController,
                  //   decoration: InputDecoration(
                  //     hintText: 'Enter your username',
                  //   ),
                  // ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Bio',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  TextFormField(
                    controller: _bioController..text = user!.bio,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: user!.bio,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
