import 'package:connect_box/features/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          // IconButton(
          //   icon: const Icon(
          //     Icons.search,
          //     size: 35,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {},
          // )
        ],
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'WorkSans',
          ),
        ),
        // backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
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
              Map<String, dynamic>? userData =
                  snapshot.data?.data() as Map<String, dynamic>?;

              if (userData != null) {
                // String? displayName = userData['displayName'];
                // String? photoURL = userData['photoURL'];
                // if (displayName != null && photoURL != null) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const profile_screen()));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                        child: Container(
                                            width: 80,
                                            height: 80,
                                            child: userData
                                                    .containsKey("photoURL")
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                FullImageScreen(
                                                                  imageUrl:
                                                                      userData[
                                                                          "photoURL"],
                                                                )),
                                                      );
                                                    },
                                                    child: Image.network(
                                                        userData["photoURL"],
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (_, __,
                                                                ___) =>
                                                            const Icon(
                                                              Icons.person,
                                                              size: 40,
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                  )
                                                : const Icon(
                                                    Icons.person,
                                                    size: 40,
                                                    color: Colors.black,
                                                  )))),
                                // const SizedBox(width: 10),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${userData['displayName']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'WorkSans',
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        'About.... Feeling Good in App',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'WorkSans',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // IconButton(
                                //   onPressed: () {},
                                //   icon: const Icon(
                                //     Icons.arrow_drop_down_circle_outlined,
                                //     size: 30,
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomListTile(
                        title: "Account",
                        subtitle: "Security Password, Change phone number",
                        icon: Icons.key,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                color: const Color(0xFF8D99a2),
                                title: 'Account',
                                message: 'Security Password Change phone nuber',
                                contentType: ContentType.success,
                              ),
                            ),
                          );
                        },
                      ),
                      CustomListTile(
                        title: "Privacy",
                        subtitle: "Block contacts, disappearing message",
                        icon: Icons.lock,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                color: const Color(0xFF8D99a2),
                                title: 'Privacy',
                                message: 'Security Password Change phone nuber',
                                contentType: ContentType.success,
                              ),
                            ),
                          );
                        },
                      ),
                      CustomListTile(
                        title: "Avatar",
                        subtitle: "Create, Edit, profile photo",
                        icon: Icons.person,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                color: const Color(0xFF8D99a2),
                                title: 'Avatar',
                                message: 'Security Password Change phone nuber',
                                contentType: ContentType.success,
                              ),
                            ),
                          );
                        },
                      ),
                      CustomListTile(
                        title: "Chats",
                        subtitle: "Theme, wallpapers, chat history",
                        icon: Icons.chat,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                color: const Color(0xFF8D99a2),
                                title: 'Chats',
                                message: 'Security Password Change phone nuber',
                                contentType: ContentType.success,
                              ),
                            ),
                          );
                        },
                      ),
                      CustomListTile(
                        title: "Notifications",
                        subtitle: "Message, group & call tones",
                        icon: Icons.notifications,
                        onTap: () {},
                      ),
                      CustomListTile(
                        title: "Storage and data ",
                        subtitle: "Network usage, auto-download",
                        icon: Icons.data_saver_off_outlined,
                        onTap: () {},
                      ),
                      CustomListTile(
                        title: "App language",
                        subtitle: "English(device's language)",
                        icon: Icons.language,
                        onTap: () {},
                      ),
                      CustomListTile(
                        title: "Help",
                        subtitle: "Help center, contant us, privacy policy",
                        icon: Icons.help,
                        onTap: () {},
                      ),
                      CustomListTile(
                        title: "Invite a friend",
                        subtitle: "",
                        icon: Icons.group,
                        onTap: () {},
                      ),
                    ],
                  ),
                );
                // } else {
                // return const Text('User data not found.');
                // }
              }
            }
            return Text("Error");
          },
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  final VoidCallback onTap;

  const CustomListTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

class FullImageScreen extends StatelessWidget {
  final String imageUrl;

  const FullImageScreen({Key? key, required this.imageUrl}) : super(key: key);

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
          "Profile Photo",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'WorkSans',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Hero(
            tag: imageUrl,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
