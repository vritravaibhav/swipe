import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/Resources/auth_methods.dart';
import 'package:instagramclone/Resources/firestore_methods.dart';
import 'package:instagramclone/models/user.dart';
import 'package:instagramclone/providers/UserProvider.dart';
import 'package:instagramclone/providers/typePro.dart';
import 'package:instagramclone/screens/comments_screeens.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/widget/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/profile_screen.dart';

class PostCard extends StatefulWidget {
  final snap;
  final bool anon;
  final bool isOnPop;
  const PostCard(
      {super.key,
      required this.snap,
      required this.anon,
      required this.isOnPop});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    // getUsers(widget.snap);
    // getComments();

    // print(widget.snap);
  }

  bool isLoading = false;

  getComments() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('comments')
        .get();
    commentLen = snap.docs.length;
    if (mounted) {
      setState(() {});
    }
  }

  bool ishearing = false;
  bool callGetUser = false;
  bool user1flag = false;
  late User user1;
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    final x = Provider.of<TypeProvdier>(context);
    if (!user1flag) {
      user1 = x.userx;
      user1flag = true;
    }

    Future<User> getUsers(var snap) async {
      user1 = await AuthMethods().getUser(widget.snap["uid"]);
      if (!ishearing) {
        x.hearing();
        ishearing = true;
      }

      return user1;
    }

    if (!callGetUser) {
      getUsers(widget.snap);
      print("called");
      callGetUser = true;
    }

    return Container(
      color: !widget.anon ? mobileBackgroundColor : Colors.brown,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10)
                .copyWith(right: 0),
            child: InkWell(
              onTap: () {
                widget.anon
                    ? () {}
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                  uid: widget.snap["uid"],
                                )),
                      );
              },
              child: Row(
                children: [
                  ClipOval(
                    child: SizedBox(
                      height: 32,
                      width: 32,
                      child: widget.snap['profImage'].toString().isNotEmpty
                          ? widget.anon
                              ? CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      'https://firebasestorage.googleapis.com/v0/b/instagram-clone-6c92f.appspot.com/o/profilePics%2Fanonymousman.jpg?alt=media&token=fcef4a28-5a48-4140-9fb5-6e0da7f0122b')
                              : CachedNetworkImage(

                                  fit: BoxFit.cover,
                                  imageUrl: widget.snap['profImage'].toString())
                          : const Icon(Icons.person),

                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Text(
                      widget.anon ? "Anonymous" : user1.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
                  widget.anon
                      ? SizedBox()
                      : user.uid == widget.snap["uid"]
                          ? IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                          child: ListView(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            shrinkWrap: true,
                                            children: ['Delete']
                                                .map((e) => InkWell(
                                                      onTap: () async {
                                                        await FirestoreMethods()
                                                            .deletePost(
                                                                widget.snap[
                                                                    'postId']);
                                                        Navigator.of(context)
                                                            .pop();
                                                        widget.isOnPop == true
                                                            ? Navigator.pop(
                                                                context)
                                                            : () {};
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 12,
                                                                horizontal: 16),
                                                        child: Text(e),
                                                      ),
                                                    ))
                                                .toList(),
                                          ),
                                        ));
                              },
                              icon: Icon(Icons.more_vert))
                          : SizedBox()
                ],
              ),
            ),
          ),
          GestureDetector(
            onDoubleTap: () {
              FirestoreMethods().likesPost(widget.snap['postId'], user.uid,
                  widget.snap['likes'], widget.anon);
              if (mounted) {
                setState(() {
                  isLikeAnimating = true;
                });
              }
            },
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: widget.snap['postUrl'],
                  fit: BoxFit.cover,
                ),
                //child: Image(image: snap),
              ),
              AnimatedOpacity(
                opacity: isLikeAnimating ? 1 : 0,
                duration: const Duration(
                  milliseconds: 200,
                ),
                child: LikeAnimation(
                  isAnimating: isLikeAnimating,
                  duration: const Duration(
                    milliseconds: 400,
                  ),
                  onEnd: () {
                    if (mounted) {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    }
                  },
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
              )
            ]),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                child: IconButton(
                  onPressed: () {
                    FirestoreMethods().likesPost(widget.snap['postId'],
                        user.uid, widget.snap['likes'], widget.anon);
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite,
                          color: Colors.white,
                        ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                              postId: widget.snap['postId'],
                            )),
                  );
                },
                icon: const Icon(Icons.comment_outlined),
              ),
            ],
          ),
          // caption and comments
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      '${widget.snap['likes'].length} likes',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 8),
                    child: RichText(
                      text: TextSpan(
                          style: const TextStyle(color: primaryColor),
                          children: [
                            TextSpan(
                              text: widget.anon ? "Anonymous" : user1.username,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ' ${widget.snap['description']}',
                              // style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ]),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommentsScreen(
                                  postId: widget.snap['postId'],
                                )),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        style: const TextStyle(
                            fontSize: 16, color: secondaryColor),
                        'view all $commentLen comments',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                        style: const TextStyle(
                            fontSize: 16, color: secondaryColor),
                        DateFormat.yMMMd()
                            .format(widget.snap['datePublished'].toDate())),
                  ),
                ]),
          )
        ],
      ),
    );
  }
}
