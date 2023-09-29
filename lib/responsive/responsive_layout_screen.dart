import 'package:flutter/material.dart';
import 'package:instagramclone/providers/UserProvider.dart';
import 'package:instagramclone/utils/global_variable.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout(
      {required this.webScreenLayout,
      required this.mobileScreenLayout,
      super.key});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  bool userdata = false;
  addData() async {
    UserProvider userprovider = Provider.of(context, listen: false);
    userprovider.refreshUser();
    userdata = true;
    // if (mounted) {
    //   setState(() {});
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (userdata) {
      return LayoutBuilder(builder: ((context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          //web screen
          return widget.webScreenLayout;
        }
        //Mobile  screen
        return widget.mobileScreenLayout;
      }));
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
