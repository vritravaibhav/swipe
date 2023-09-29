import 'package:flutter/material.dart';
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
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Feed'),
              Tab(text: 'Chirp'),
              Tab(text: 'Anon Feed'),
            ],
          ),
          title: Image.asset(
            'assets/swipe.png',
            height: 30,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatList()),
                  );
                },
                icon: const Icon(
                  Icons.message,
                  color: primaryColor,
                ))
          ],
        ),
        body: const TabBarView(
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
