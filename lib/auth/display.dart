// ignore_for_file: use_build_context_synchronously, deprecated_member_use, unnecessary_nullable_for_final_variable_declarations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_box/auth/login.dart';
import 'package:connect_box/auth/signup.dart';
import 'package:connect_box/navbar/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_apps/device_apps.dart';

class Screen extends StatefulWidget {
  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _slideAnimation = Tween<Offset>(
            begin: const Offset(-1.0, 0.0), end: const Offset(0.0, 0.0))
        .animate(_controller);

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: screenWidth,
            height: screenHeight * 1.1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.black],
                stops: [0.0, 0.66],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenHeight * 0.1,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.18),
                          child: Text(
                            "Connect",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'WorkSans',
                              fontSize: screenWidth * 0.1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.18),
                          child: Text(
                            "Friends",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'WorkSans',
                              fontSize: screenWidth * 0.1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.18),
                          child: Text(
                            "Easily  &",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'WorkSans',
                              fontSize: screenWidth * 0.1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.18),
                          child: Text(
                            "Quickly",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'WorkSans',
                              fontSize: screenWidth * 0.1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.08,
                  ),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      child: Text(
                        "Our Connect Box is the perfect way to stay connected with Friends and Family.",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'WorkSans',
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Center(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await signInWithGoogle();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 140.0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: screenWidth * 0.004,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: screenWidth * 0.05,
                                backgroundColor: Colors.transparent,
                                child: Image.asset(
                                  'assets/icons/ic_search.png',
                                  height: screenWidth * 0.06,
                                  width: screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.05,
                        ),
                        GestureDetector(
                          onTap: () {
                            _launchURL();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: screenWidth * 0.004,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: screenWidth * 0.05,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                'assets/icons/ic_facebook.png',
                                height: screenWidth * 0.06,
                                width: screenWidth * 0.06,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.035),
                            child: const Divider(
                              color: Colors.white60,
                              thickness: 0.5,
                              height: 3,
                            ),
                          ),
                        ),
                        Text(
                          "Or",
                          style: TextStyle(
                            color: Colors.white60,
                            fontFamily: 'WorkSans',
                            fontSize: screenWidth * 0.038,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.035),
                            child: const Divider(
                              color: Colors.white60,
                              thickness: 0.5,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Signup(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign up with Email",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'WorkSans',
                            fontSize: screenWidth * 0.038,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Already have an Account? ",
                          style: TextStyle(
                              fontFamily: 'WorkSans',
                              color: Colors.white,
                              fontSize: screenWidth * 0.04),
                          children: [
                            TextSpan(
                              text: 'Log In',
                              style: TextStyle(
                                fontFamily: 'WorkSans',
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Login(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void identifyMailAccounts() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: true,
      includeAppIcons: true,
    );

    List<String> mailApps = [];

    for (var app in apps) {
      if (app.packageName.contains('com.google.android.gm') ||
          app.packageName.contains('com.microsoft.office.outlook') ||
          app.packageName.contains('com.yahoo.mobile.client.android.mail')) {
        mailApps.add(app.appName);
      }
    }

    if (mailApps.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Mail Accounts Detected'),
            content: Column(
              children: mailApps
                  .map((appName) => ListTile(
                        title: Text(appName),
                      ))
                  .toList(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No Mail Accounts Detected'),
            content: const Text('No mail accounts found on the device.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  _launchURL() async {
    const url =
        'https://www.facebook.com/login/?privacy_mutation_token=...'; // Your URL here
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final userExists = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get()
          .then((doc) => doc.exists);

      if (userExists) {
        Fluttertoast.showToast(
          msg: "Account already exists. Please sign in.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': userCredential.user!.email,
        'displayName': userCredential.user!.displayName,
        'photoURL': userCredential.user!.photoURL,
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Navbar(),
        ),
      );
    } on Exception catch (e) {
      print('exception->$e');
    }
  }
}
