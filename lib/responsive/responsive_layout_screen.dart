import 'package:flutter/material.dart';
import 'package:instagramclone/providers/UserProvider.dart';
import 'package:instagramclone/utils/global_variable.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget WebScreenLayout;
  final Widget MobileScreenLayout;
  const ResponsiveLayout(
      {required this.WebScreenLayout,
      required this.MobileScreenLayout,
      super.key});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  bool userdata = false;
  addData() async {
    UserProvider _userprovider = Provider.of(context, listen: false);
    await _userprovider.refreshUser();
    userdata = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (userdata) {
      return LayoutBuilder(builder: ((context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          //web screen
          return widget.WebScreenLayout;
        }
        //Mobile  screen
        return widget.MobileScreenLayout;
      }));
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
