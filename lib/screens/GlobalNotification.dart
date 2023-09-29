import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GlobalNotification extends StatelessWidget {
  const GlobalNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('GlobalNotification')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Global Notifications"),
          ),
          body: ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              // appBar: AppBar(
              //   title: Text("Global Notification"),
              // ),
              return Column(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    // height: 100,
                    child: CachedNetworkImage(imageUrl: data["image"]),
                  ),
                  const Divider()
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
