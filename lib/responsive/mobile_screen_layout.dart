import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/global_variable.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

String username = "";

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getUsername();
  // }

  // getUsername() async {
  //   DocumentSnapshot snap = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   setState(() {
  //     username = (snap.data()as Map<String,dynamic>)['username'];
  //   });
  //   //showSnackBar("done", context);
  // }

  int _page = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
    // setState(() {
    //   _page = page;
    // });
  }

  onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  List<BottomNavigationBarItem> _navItems() => [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: _page == 0 ? blueColor : secondaryColor,
          ),
          backgroundColor: primaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            color: _page == 1 ? blueColor : secondaryColor,
          ),
          backgroundColor: primaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_circle,
            color: _page == 2 ? blueColor : secondaryColor,
          ),
          backgroundColor: primaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.favorite,
            color: _page == 3 ? blueColor : secondaryColor,
          ),
          backgroundColor: primaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: _page == 4 ? blueColor : secondaryColor,
          ),
          backgroundColor: primaryColor,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    // model.User user = Provider.of<UserProvider>(context).getUse;
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: _navItems(),
        onTap: navigationTapped,
      ),
    );
  }
}
