// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class LikesList extends StatelessWidget {
//   final snap;
//   const LikesList({
//     Key? key,
//     required this.snap,
//   }) : super(key: key);
  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(Icons.arrow_back)),
//         title: Text("Likes"),
//       ),
//       body: Column(children: [
//         Text("Liked by"),
//         Divider(),
//       StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection('users').where("uid" , arrayContains: snap).snapshots(),
//       builder: (context,
//           AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         return ListView.builder(
//           itemCount: snapshot.data!.docs.length,
//           itemBuilder: (context, index) => Row(
//             children: [
//               CircleAvatar(
//                 foregroundImage: NetworkImage(snapshot.data!.docs[index].data()["photoUrl"]),
//               )
//             ],
//           )
//         );
//       },
//     )
//       ]),
//     );
//   }
// }
