import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/screens/GlobalNotification.dart';

import 'package:instagramclone/screens/feed_screen.dart';
import 'package:instagramclone/screens/post_screen.dart';
import 'package:instagramclone/screens/profile_screen.dart';
import 'package:instagramclone/screens/search_screen.dart';

const webScreenSize = 600;
//String uid = FirebaseAuth.instance.currentUser!.uid;
Map<String , User>? userList;

List<Widget> homeScreenItems = [
  FeedScreen(), //-- Add it later
  // AddPostScreen(),
  SearchScreen(),
  const AddPostScreen(),
  const GlobalNotification(),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid)
];
