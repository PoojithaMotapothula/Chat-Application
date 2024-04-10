// ignore_for_file: library_private_types_in_public_api
import 'package:connect_box/navbar/home.dart';
import 'package:connect_box/navbar/contacts.dart';
import 'package:connect_box/navbar/settings.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;
  List<Widget> tabItems = [
    const Chat(),
    ContactListScreen(),
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: tabItems[_selectedIndex],
      ),
      bottomNavigationBar: FlashyTabBar(
        backgroundColor: Colors.black,
        animationCurve: Curves.linear,
        selectedIndex: _selectedIndex,
        iconSize: 25,
        showElevation: false,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            activeColor: Colors.white,
            inactiveColor: Colors.white60,
            icon: const Icon(Icons.chat),
            title: const Text(
              'Chats',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          FlashyTabBarItem(
            activeColor: Colors.white,
            inactiveColor: Colors.white60,
            icon: const Icon(Icons.person),
            title: const Text(
              'Contacts',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          FlashyTabBarItem(
            activeColor: Colors.white,
            inactiveColor: Colors.white60,
            icon: const Icon(Icons.settings),
            title: const Text(
              'Settings',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class Tab1 extends StatelessWidget {
  const Tab1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Homescreen Content"),
    );
  }
}

class Tab2 extends StatelessWidget {
  const Tab2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Homescreen Content"),
    );
  }
}
