import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Resources/firestore_methods.dart';
import '../utils/utils.dart';

class PostProvider with ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  Uint8List? image;
  selectImage(ImageSource source) async {
    final file = await _picker.pickImage(source: source);
    if (file == null) return;
    image = await file.readAsBytes();
    notifyListeners();
  }

  final PageController controller = PageController();
  int selectedPage = 0;

  selectPage(int index) {
    selectedPage = index;
    controller.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
    notifyListeners();
  }

  final TextEditingController captionController = TextEditingController();
  bool isLoading = false;

  void postImage(
      {required BuildContext context,
      required String uid,
      required String username,
      required String profImage,
      required bool isAnonymous}) async {
    isLoading = true;
    notifyListeners();
    try {
      String res = await FirestoreMethods().uploadPost(captionController.text,
          image!, uid, username, profImage, isAnonymous);
      if (res == "success") {
        isLoading = false;
        captionController.clear();
        selectPage(0);
        showSnackBar('Successfully posted', context);
        Navigator.pop(context);
        image = null;
        notifyListeners();
      } else {
        isLoading = false;
        showSnackBar(res, context);
        notifyListeners();
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
      notifyListeners();
    }
    notifyListeners();
  }
}
