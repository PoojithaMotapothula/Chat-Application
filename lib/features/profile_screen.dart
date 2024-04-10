// ignore_for_file: camel_case_types, use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

class profile_screen extends StatefulWidget {
  const profile_screen({super.key});

  @override
  State<profile_screen> createState() => _profile_screenState();
}

class _profile_screenState extends State<profile_screen> {
  late String userUid;
  String locationInfo = 'Loading...';
  File? _profileImage;
  String? _profileImageurl;
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final _picker = ImagePicker();

  Future<void> getUserUid() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        userUid = user.uid;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserUid();
  }

  void _updateProfileDetails() async {
    try {
      String profileImageUrl = '';

      if (_profileImage != null) {
        final profileImageRef =
            FirebaseStorage.instance.ref().child('profile_images/$userUid');

        await profileImageRef.putFile(_profileImage!);
        profileImageUrl = await profileImageRef.getDownloadURL();
      }
      await FirebaseFirestore.instance.collection('users').doc(userUid).update({
        'photoURL': profileImageUrl,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
        ),
      );
    } catch (e) {
      print('Error updating artist details: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });

      _updateProfileDetails();
    }
  }

  Future<void> _showImagePickerDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose an option'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _pickImage(ImageSource.camera);

                        Navigator.pop(context);
                      },
                      child: const Text('Pick Profile Image from Camera'),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        _pickImage(ImageSource.gallery);
                        Navigator.pop(context);
                      },
                      child: const Text('Pick Profile Image from Gallery'),
                    ),
                    const SizedBox(width: 8.0),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'WorkSans',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Map<String, dynamic> userData =
                snapshot.data!.data() as Map<String, dynamic>;
            _profileImageurl = userData['photoURL'];
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      if (_profileImage != null)
                        Stack(children: [
                          GestureDetector(
                            onTap: () => _showFullScreenImage(context),
                            child: Hero(
                              tag: 'profileImage',
                              child: Container(
                                width: 160.0,
                                height: 160.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1.5, color: Colors.white),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: Image.file(_profileImage!).image,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: -10,
                              right: -10,
                              child: IconButton(
                                icon: const Icon(
                                  Ionicons.camera,
                                  color: Colors.white,
                                  size: 45,
                                ),
                                onPressed: () {
                                  _showImagePickerDialog();
                                },
                              ))
                        ])
                      else
                        InkWell(
                          child: Stack(children: [
                            if (_profileImageurl == null ||
                                _profileImageurl!.isEmpty)
                              GestureDetector(
                                onTap: () => _showFullScreenImage(context),
                                child: Hero(
                                  tag: 'profileImage',
                                  child: Container(
                                    width: 140.0,
                                    height: 140.0,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                  ),
                                ),
                              )
                            else
                              GestureDetector(
                                onTap: () => _showFullScreenImage(context),
                                child: Hero(
                                  tag: 'profileImage',
                                  child: Container(
                                    width: 160.0,
                                    height: 160.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            _profileImageurl.toString()),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Positioned(
                                bottom: -10,
                                right: -5,
                                child: IconButton(
                                  icon: const Icon(
                                    Ionicons.camera,
                                    color: Colors.white,
                                    size: 45,
                                  ),
                                  onPressed: () {
                                    _showImagePickerDialog();
                                  },
                                ))
                          ]),
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Update Username',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              TextField(
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter new username',
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              ElevatedButton(
                                onPressed: () async {
                                  String newUsername = usernameController.text;
                                  print('New Username: $newUsername');
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .update({
                                    'displayName': newUsername,
                                  });
                                  setState(() {
                                    usernameController.clear();
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text('Update'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "Name",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'WorkSans',
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                          // fontWeight: FontWeight.bold,
                          ),
                    ),
                    subtitle: Text(
                      "${userData["displayName"]}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'WorkSans',
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        size: 25,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Enter your Update number',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              TextField(
                                controller: phoneController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter new username',
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              ElevatedButton(
                                onPressed: () async {
                                  String newphonenumber = phoneController.text;
                                  print('Phonee: $newphonenumber');
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .update({
                                    'phone': newphonenumber,
                                  });
                                  setState(() {
                                    usernameController.clear();
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text('Update'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: ListTile(
                    leading: const Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "Phone",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'WorkSans',
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                          // fontWeight: FontWeight.bold,
                          ),
                    ),
                    subtitle: Text(
                      "${userData["phone"]}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'WorkSans',
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        size: 25,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _showFullScreenImage(BuildContext context) {
    if (_profileImage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(
                "Profile Photo",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'WorkSans',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            backgroundColor: Colors.black,
            body: Center(
              child: Hero(
                tag: 'profileImage',
                child: Image.file(_profileImage!),
              ),
            ),
          ),
        ),
      );
    }
  }
}
