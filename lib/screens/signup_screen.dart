import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/Resources/auth_methods.dart';
import 'package:instagramclone/responsive/responsive_layout_screen.dart';
import 'package:instagramclone/utils/utils.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../widget/text_field_input.dart';
import 'login_screens.dart';

// void selectimage() async {
//     Uint8List? v = await pickImage(ImageSource.gallery);
//     setState(() {
//       _image = v;
//     });
//   }
class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String vaibhav =
      "https://i.pinimg.com/originals/f1/0f/f7/f10ff70a7155e5ab666bcdd1b45b726d.jpg";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  //lol
  void selectimage() async {
    Uint8List? v = await pickImage(ImageSource.gallery);
    if (v != null) {
      setState(() {
        _image = v;
      });
    }
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().SignUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text.isNotEmpty ? _bioController.text : "",
      file: _image != null ? _image! : null,
    );
    if (res != 'Success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: MobileScreenLayout(),
        ),
      ));
    }

    setState(() {
      _isLoading = false;
    });
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(

                  //text field for input and all things
                  children: [
                    const Spacer(),
                    Image.asset(
                      'assets/swipe.png',
                      height: 70,
                    ),
                    const Spacer(),
                    //Circular widget to show our selected files
                    Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(vaibhav),
                              ),
                        Positioned(
                            bottom: -10,
                            left: 80,
                            child: IconButton(
                              onPressed: () {
                                selectimage();
                              },
                              icon: const Icon(Icons.add_a_photo),
                            ))
                      ],
                    ),
                    const Spacer(),
                    TextFieldInput(
                        textEditingController: _usernameController,
                        hintText: "Enter your username",
                        textInputType: TextInputType.text),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                        textEditingController: _passwordController,
                        hintText: "Enter your password",
                        ispass: true,
                        textInputType: TextInputType.text),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                        textEditingController: _emailController,
                        hintText: "Enter your email",
                        textInputType: TextInputType.emailAddress),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                        textEditingController: _bioController,
                        hintText: "Enter your bio",
                        textInputType: TextInputType.text),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: // () {
                          //  if (_image != null) {
                          signUpUser,
                      //    } else {
                      //     showSnackBar("please upload picture", context);
                      //   }
                      //   },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const ShapeDecoration(
                            color: blueColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            )),
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                            : const Text("Sign up"),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text("Already have an account?"),
                        ),
                        // SizedBox(width: 20,),
                        GestureDetector(
                          onTap: () {
                            if (_emailController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Enter Email')));
                            }
                            if (_passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Enter Password')));
                            }
                            if (_usernameController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Enter Username')));
                            }
                            navigateToLogin();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: const Text(
                              "Login",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
