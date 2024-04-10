import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_box/features/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              color: Colors.teal,
              width: screenWidth,
              height: screenHeight * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            Map<String, dynamic>? userData =
                                snapshot.data?.data() as Map<String, dynamic>?;

                            if (userData != null) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const profile_screen()));
                                  },
                                  child: Container(
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                      child: userData.containsKey("photoURL")
                                      ? Image.network(
                                        userData["photoURL"],
                                        fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                              const Icon(
                                                Icons.person,
                                                size: 40,
                                                color: Colors.white,
                                              )
                                      )
                                      :const Icon(Icons.person,
                                              size: 40,
                                              color: Colors.white,
                                    )
                                    )
                                  ),
                                ),
                              );
                            } else {
                              return const Text('User data not found.');
                            }
                          }
                        },
                      ),
                      const Text(
                        "Home",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'WorkSans',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search,
                              size: 30,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.3,
            left: 0,
            child: Container(
              width: screenWidth * 1.0,
              height: screenHeight * 0.7,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
