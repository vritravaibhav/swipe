import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart' as model;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/Resources/firestore_methods.dart';
import 'package:instagramclone/providers/post_provider.dart';
import 'package:instagramclone/providers/typePro.dart';
import 'package:instagramclone/screens/final_post_screen.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tweetController = TextEditingController();

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  void postImage(
      String uid, String username, String profImage, bool isAnonymous) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text,
          _file!,
          uid,
          username,
          profImage,
          isAnonymous);
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        clearImage();
        showSnackBar("posted", context);
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  // _selectImage(BuildContext context) async {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return SimpleDialog(
  //           title: const Text("Create a post"),
  //           children: [
  //             SimpleDialogOption(
  //               padding: const EdgeInsets.all(20),
  //               child: const Text('Take a pHOTO'),
  //               onPressed: () async {
  //                 Navigator.of(context).pop();
  //                 Uint8List? file = await pickImage(
  //                   ImageSource.camera,
  //                 );
  //                 setState(() {
  //                   _file = file;
  //                 });
  //               },
  //             ),
  //             SimpleDialogOption(
  //               padding: const EdgeInsets.all(20),
  //               child: const Text('choose from gallery'),
  //               onPressed: () async {
  //                 Navigator.of(context).pop();
  //                 Uint8List? file = await pickImage(
  //                   ImageSource.gallery,
  //                 );
  //                 setState(() {
  //                   _file = file;
  //                   if (file != null) {
  //                     uploadScreen = true;
  //                   }
  //                 });
  //               },
  //             ),
  //             SimpleDialogOption(
  //               padding: const EdgeInsets.all(20),
  //               child: const Text('Cancel'),
  //               onPressed: () async {
  //                 Navigator.of(context).pop();
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }

  // void anonymoustweet() async {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return SimpleDialog(
  //           title: const Text("Tweet Anonimously"),
  //           children: [
  //             Container(
  //               height: 200,
  //               color: Colors.white,
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Center(
  //                   child: TextField(
  //                     textCapitalization: TextCapitalization.sentences,
  //                     textAlignVertical: TextAlignVertical.center,
  //                     expands: true,
  //                     //keyboardType: TextInputType.,
  //                     maxLines: null,
  //                     style: const TextStyle(
  //                         color: Colors.black, fontWeight: FontWeight.bold),
  //                     controller: _tweetController,
  //                     //decoration: InputDecoration(),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             TextButton(
  //                 onPressed: () async {
  //                   FirestoreMethods().uploadTweets(
  //                     _tweetController.text,
  //                   );
  //                   Navigator.pop(context);
  //                   showSnackBar("Successfully Tweeted", context);
  //                   _tweetController.clear();
  //                 },
  //                 child: const Text(
  //                   "Tweet",
  //                   style: TextStyle(
  //                       letterSpacing: Checkbox.width,
  //                       fontSize: Checkbox.width),
  //                 )),
  //           ],
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    final x = Provider.of<TypeProvdier>(context);
    // return SafeArea(
    //   child: !uploadScreen
    //       ?
    //       //  Center(
    //       //     child: IconButton(
    //       //         icon: const Icon(Icons.upload),
    //       //         onPressed: () {
    //       //           _selectImage(context);
    //       //         }),
    //       //   )
    //       Container(
    //           decoration: const BoxDecoration(),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               SizedBox(
    //                 height: MediaQuery.of(context).size.height * 0.25,
    //                 child: InkWell(
    //                   onTap: () {
    //                     x.isAnonymous = false;
    //                     _selectImage(context);
    //                   },
    //                   child: const Text(
    //                     'Post',
    //                     style: TextStyle(color: Colors.white),
    //                   ),
    //                 ),
    //               ),
    //               Container(
    //                 height: MediaQuery.of(context).size.height * 0.25,
    //                 width: MediaQuery.of(context).size.width * 1,
    //                 decoration: BoxDecoration(
    //                   image: DecorationImage(
    //                     fit: BoxFit.cover,
    //                     image: AssetImage('assets/weetlogo.jpg'.toString()),
    //                   ),
    //                 ),
    //                 child: InkWell(
    //                   onTap: () {
    //                     anonymoustweet();
    //                   },
    //                   child: const Text(
    //                     "Tap here for anonymous   tweet",
    //                     style: TextStyle(color: Colors.black, fontSize: 23),
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(
    //                   height: MediaQuery.of(context).size.height * 0.25,
    //                   child: InkWell(
    //                     onTap: () {
    //                       x.isAnonymous = true;
    //                       _selectImage(context);
    //                     },
    //                   ))
    //             ],
    //           ),
    //         )
    //       : Scaffold(
    //           appBar: AppBar(
    //             backgroundColor: mobileBackgroundColor,
    //             leading: IconButton(
    //               icon: const Icon(Icons.arrow_back),
    //               onPressed: clearImage,
    //             ),
    //             title: const Text("Post to"),
    //             centerTitle: false,
    //             actions: [
    //               TextButton(
    //                   onPressed: () => postImage(user.uid, user.username,
    //                       user.photoUrl, x.isAnonymous),
    //                   child: const Text(
    //                     'Post',
    //                     style: TextStyle(
    //                         color: Colors.blueAccent,
    //                         fontWeight: FontWeight.bold,
    //                         fontSize: 16),
    //                   ))
    //             ],
    //           ),
    //           body: Column(children: [
    //             isLoading
    //                 ? const LinearProgressIndicator()
    //                 : const Padding(padding: EdgeInsets.only(top: 0)),
    //             const Divider(),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceAround,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 CircleAvatar(
    //                   backgroundImage: NetworkImage(user.photoUrl),
    //                 ),
    //                 SizedBox(
    //                   width: MediaQuery.of(context).size.width * 0.4,
    //                   child: TextField(
    //                     decoration: const InputDecoration(
    //                       hintText: "Write a caption",
    //                       border: InputBorder.none,
    //                     ),
    //                     controller: _descriptionController,
    //                     maxLines: 8,
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   height: 45,
    //                   width: 45,
    //                   child: AspectRatio(
    //                     aspectRatio: 487 / 451,
    //                     child: Container(
    //                       decoration: BoxDecoration(
    //                         image: DecorationImage(
    // image: MemoryImage(_file!),
    //                           fit: BoxFit.fill,
    //                           alignment: FractionalOffset.topCenter,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 const Divider(),
    //               ],
    //             )
    //           ]),
    //         ),
    // );

    // anon---
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: context.watch<PostProvider>().controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const PostWidget(
                  postType: 'Post',
                  isAnonymous: false,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 18, bottom: 20),
                          child: Text(
                            'Anonymous Chirp',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: TextButton(
                            onPressed: () {
                              FirestoreMethods().uploadTweets(
                                _tweetController.text,
                              );
                              showSnackBar("Successfully Chirped", context);
                              _tweetController.clear();
                            },
                            child: const Text('Post >'),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      color: const Color.fromARGB(137, 51, 51, 51),
                      child: TextField(
                        controller: _tweetController,
                        maxLines: null,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Confess your thought...'),
                      ),
                    ),
                    // const SizedBox(height: 100),
                    // GestureDetector(
                    //   onTap: () {
                    //     FirestoreMethods().uploadTweets(
                    //       _tweetController.text,
                    //     );
                    //     showSnackBar("Successfully Tweeted", context);
                    //     _tweetController.clear();
                    //   },
                    //   child: Center(
                    //     child: Container(
                    //       padding: const EdgeInsets.symmetric(
                    //           horizontal: 20, vertical: 10),
                    //       decoration: BoxDecoration(
                    //         color: const Color.fromARGB(255, 171, 181, 189),
                    //         borderRadius: BorderRadius.circular(8),
                    //       ),
                    //       child: const Text(
                    //         'Tweet it..',
                    //         style: TextStyle(
                    //             fontSize: 20, fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
                const PostWidget(
                  postType: 'Anonymous Post',
                  isAnonymous: true,
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              right: context.watch<PostProvider>().selectedPage != 2
                  ? context.watch<PostProvider>().selectedPage == 0
                      ? -MediaQuery.of(context).size.width * 0.5
                      : -MediaQuery.of(context).size.width * 0.1
                  : 10,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(115, 205, 47, 47)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          context.read<PostProvider>().selectPage(0);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Text(
                            'Post',
                            style:
                                context.watch<PostProvider>().selectedPage == 0
                                    ? const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400)
                                    : const TextStyle(
                                        color: Colors.grey, fontSize: 13),
                          ),
                        )),
                    GestureDetector(
                        onTap: () {
                          context.read<PostProvider>().selectPage(1);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Text(
                            'Anonymous Chirp',
                            style:
                                context.watch<PostProvider>().selectedPage == 1
                                    ? const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400)
                                    : const TextStyle(
                                        color: Colors.grey, fontSize: 13),
                          ),
                        )),
                    GestureDetector(
                        onTap: () {
                          context.read<PostProvider>().selectPage(2);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Text(
                            'Anonymous Post',
                            style:
                                context.watch<PostProvider>().selectedPage == 2
                                    ? const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400)
                                    : const TextStyle(
                                        color: Colors.grey, fontSize: 13),
                          ),
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  const PostWidget(
      {super.key, required this.postType, required this.isAnonymous});

  final String postType;
  final bool isAnonymous;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 18, bottom: 20),
              child: Text(
                postType,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            context.watch<PostProvider>().image != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FinalPostPage(isAnonymous: isAnonymous)));
                      },
                      child: const Text('Next >'),
                    ),
                  )
                : Container(),
          ],
        ),
        AspectRatio(
          aspectRatio: 1,
          child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              color: const Color.fromARGB(31, 138, 214, 209),
              child: context.watch<PostProvider>().image != null
                  ? Image.memory(
                      context.watch<PostProvider>().image!,
                      fit: BoxFit.cover,
                    )
                  : null),
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                context.read<PostProvider>().selectImage(ImageSource.gallery);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(16)),
                child: const Text(
                  'Gallery',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 30),
            GestureDetector(
              onTap: () {
                context.read<PostProvider>().selectImage(ImageSource.camera);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(16)),
                child: const Text(
                  'Camera',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
