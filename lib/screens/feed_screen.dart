import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramclone/screens/AnonFeedScreen.dart';
import 'package:instagramclone/screens/AnonymousTweetScreen.dart';
import 'package:instagramclone/screens/chat_list.dart';
import 'package:instagramclone/utils/colors.dart';

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
            height: 32,
            color: primaryColor,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatList()),
                  );
                },
                icon: const Icon(
                  Icons.message,
                  color: primaryColor,
                ))
          ],
        ),
        body: TabBarView(
          children: [
            FeedPage(),
            TweetScreen(),
            AnonFeedScreen(),
          ],
        ),
      ),
    );
  }
}
