import 'package:flutter/material.dart';
import 'package:instagramclone/providers/post_provider.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/UserProvider.dart';
import '../utils/colors.dart';

class FinalPostPage extends StatelessWidget {
  const FinalPostPage({super.key, required this.isAnonymous});

  final bool isAnonymous;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // onPressed: clearImage,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Post to"),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  context.read<PostProvider>().postImage(
                      context: context,
                      uid: user.uid,
                      username: user.username,
                      profImage: user.photoUrl,
                      isAnonymous: isAnonymous);
                },
                child: const Text(
                  'Post >',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )),
          )
        ],
      ),
      body: Column(children: [
        context.watch<PostProvider>().isLoading
            ? const LinearProgressIndicator()
            : const Padding(padding: EdgeInsets.only(top: 0)),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              user.photoUrl.isNotEmpty
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    )
                  : const CircleAvatar(
                      backgroundColor: Colors.amber,
                    ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: context.watch<PostProvider>().captionController,
                    decoration: const InputDecoration(
                      hintText: "Write a caption",
                      border: InputBorder.none,
                    ),
                    maxLines: 8,
                  ),
                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487 / 451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: context.watch<PostProvider>().image != null
                          ? DecorationImage(
                              image: MemoryImage(
                                  context.read<PostProvider>().image!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              const Divider(),
            ],
          ),
        )
      ]),
    );
  }
}
