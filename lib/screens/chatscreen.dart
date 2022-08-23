import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fchat/constants.dart';
import 'package:fchat/screens/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chatscreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  late String messageText;
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                  _auth.signOut();
                  Navigator.pushNamed(context, LoginScreen.id);
                
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('messages').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blueAccent,
                  ),
                );
              }

              final messages = snapshot.data?.docs.reversed;
              List<MessageBubble> messageBubbles = [];
              for (var message in messages!) {
                final messageText = message['text'];
                final messagesender = message['Sender'];

                final currentUser = loggedInUser.email;
                if (currentUser == messagesender) {}

                final messageBubble = MessageBubble(
                    Sender: messagesender,
                    text: messageText,
                    me: currentUser == messagesender);
                messageBubbles.add(messageBubble);
              }
              return Expanded(
                child: ListView(
                  reverse: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  children: messageBubbles,
                ),
              );
            },
          ),
          Container(
            decoration: kMessageContainerDecoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageTextController,
                    onChanged: (value) {
                      messageText = value;
                    },
                    decoration: kMessageTextFieldDecoration,
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    messageTextController.clear();
                    _firestore.collection('messages').add(
                        {'text': messageText, 'Sender': loggedInUser.email});
                  },
                  child: const Text(
                    'Send',
                    style: kSendButtonTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({required this.Sender, required this.text, required this.me});
  final String Sender;
  final String text;
  final bool me;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        //mainAxisAlignment: me?MainAxisAlignment.end:MainAxisAlignment.start,
        children: <Widget>[
          Text(
            Sender,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
            ),
          ),
          Material(
              elevation: 5.0,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color:
                  me ? const Color.fromARGB(255, 145, 117, 107) : Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(text,
                    style:
                        TextStyle(color: me ? Colors.white : Colors.black54)),
              )),
        ],
      ),
    );
  }
}
