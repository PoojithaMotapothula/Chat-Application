import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_box/chats/chat.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  Iterable<Contact> _allContacts = [];
  Iterable<Contact> _displayedContacts = [];
  bool _isMounted = false;
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _checkPhoneNumber(String phone_number) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('users').doc(phone_number).get();

      if (snapshot.exists) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Chat ()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Phone number not found in user data.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error checking phone number: $e");
      // Display error message if any error occurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error checking phone number. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _getContacts();
  }

  @override
  void dispose() {
    _isMounted = false;
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getContacts() async {
    var status = await Permission.contacts.request();

    if (status.isGranted) {
      try {
        Iterable<Contact> contacts = await ContactsService.getContacts();
        if (_isMounted) {
          setState(() {
            _allContacts = contacts;
            _displayedContacts = _allContacts;
            _isLoading = false;
          });
        }
      } catch (e) {
        print("Error fetching contacts: $e");
        if (_isMounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      print("Permission denied");
      if (_isMounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterContacts(String query) {
    Iterable<Contact> filteredContacts = _allContacts.where((contact) {
      return contact.displayName?.toLowerCase().contains(query.toLowerCase()) ??
          false;
    }).toList();

    setState(() {
      _displayedContacts = filteredContacts;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _displayedContacts = _allContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Contacts",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'WorkSans',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterContacts,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search contacts',
                      hintStyle: const TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      filled: true,
                      fillColor: Colors.white12,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _displayedContacts.length,
              itemBuilder: (context, index) {
                if (index >= 0 && index < _displayedContacts.length) {
                  Contact contact = _displayedContacts.elementAt(index);
                  String profileLetter = contact.displayName?[0] ?? '';
                  Color randomColor = _generateRandomColor();
                  return GestureDetector(
                    onTap: () {
                       String phone_number =
                      contact.phones?.isNotEmpty == true ? contact.phones!.first.value ?? '' : '';
                  _checkPhoneNumber(phone_number);
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: randomColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  profileLetter.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    contact.displayName ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'WorkSans',
                                    ),
                                  ),
                                  subtitle: Text(
                                    contact.phones?.isNotEmpty == true
                                        ? contact.phones!.first.value ?? ''
                                        : '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'WorkSans',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.0),
                          child: Divider(
                            // Add a Divider after each contact
                            color: Colors.white70, // Adjust color as needed
                            thickness: 0.3, // Adjust thickness as needed
                            height: 0, // Default height
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _generateRandomColor() {
    // Generate a random color using RGB values
    return Color.fromARGB(
      255,
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
    );
  }
}
