import 'package:flutter/material.dart';
import 'package:instagramclone/responsive/mobile_screen_layout.dart';
import 'package:instagramclone/screens/login_screens.dart';
import 'package:instagramclone/screens/signup_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late final PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  List<Widget> _page(double height) => [
        Column(
          children: [
            Lottie.asset('assets/lottie/decentralised.json', height: height),
            const Text(
              'A decentralised web3 app',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Experience the future of data: Our web3 app ensures your information stays decentralized and in your control',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 93, 90, 90),
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Lottie.asset('assets/lottie/match.json', height: height),
            const Text(
              'A new way to connect',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Discover connections naturally: Send date in secret, and when fate aligns, unveil mutual interest',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 93, 90, 90),
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: height,
                child: Lottie.asset('assets/lottie/anon.json', height: height)),
            const Text(
              'Anonymous Post and Confession',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Unlock the power of anonymity: Share your posts and thought fearlessly with our app, where your identity remains a well-kept secret',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 93, 90, 90),
                ),
              ),
            ),
          ],
        )
      ];

  bool last = false;

  @override
  Widget build(BuildContext context) {
    final Size sz = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              // height: sz.height * 0.7,
              child: PageView.builder(
                  controller: _controller
                    ..addListener(() {
                      if (_controller.page == 2) {
                        setState(() {
                          last = true;
                        });
                      } else {
                        setState(() {
                          last = false;
                        });
                      }
                    }),
                  itemCount: _page(sz.height * 0.6).length,
                  itemBuilder: (context, index) {
                    return _page(sz.height * 0.6)[index];
                  }),
            ),
            SmoothPageIndicator(
              controller: _controller,
              count: _page(sz.height * 0.6).length,
              effect: const WormEffect(
                  dotHeight: 12,
                  dotColor: Color.fromARGB(255, 248, 150, 150),
                  activeDotColor: Colors.red,
                  type: WormType.thin),
            ),
            SizedBox(height: sz.height * 0.1),
            TextButton(
              onPressed: () {
                _controller.nextPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceIn);

                if (last) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }
              },
              child: last ? const Text('Continue') : const Text('Next'),
            ),
            SizedBox(height: sz.height * 0.05),
          ],
        ),
      ),
    );
  }
}
