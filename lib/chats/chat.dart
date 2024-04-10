// import 'package:flutter/material.dart';

// class ChatScreen extends StatefulWidget {
//   final Map<String, dynamic> userData;

//   const ChatScreen({Key? key, required this.userData}) : super(key: key);

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   List<String> _messages = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.userData['name'] ?? 'Chat'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(_messages[index]),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     onSubmitted: (message) {
//                       _sendMessage(message);
//                     },
//                     decoration: InputDecoration(
//                       hintText: 'Type your message...',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     // You can also send the message when the button is pressed
//                     // Assuming there's a message typed, otherwise handle accordingly
//                     String message = ''; // Get the message from the TextField
//                     _sendMessage(message);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _sendMessage(String message) {
//     setState(() {
//       _messages.add(message);
//     });
//     // Here you can implement the logic to send the message to the recipient
//   }
// }

import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}