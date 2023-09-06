import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramclone/screens/AnonFeedScreen.dart';
import 'package:instagramclone/screens/AnonymousTweetScreen.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/widget/post_card.dart';

import 'feedpage.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 35,
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.baby_changing_station)),
              Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
          title: SvgPicture.asset(
            'assets/ic_instagram.svg',
            color: primaryColor,
            height: 32,
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.message,
                  color: primaryColor,
                ))
          ],
        ),
        body:
            TabBarView(children: [FeedPage(), TweetScreen(), AnonFeedScreen()]),
      ),
    );
  }
}
