import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fchat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chatscreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
   late User loggedInUser;

  late String messageText;

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

  void messageStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
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
                //     _auth.signOut();
                //   Navigator.pushNamed(context, LoginScreen.id);
                messageStream();
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

              final messages = snapshot.data?.docs;
              List<MessageBubble> messageBubbles = [];
              for (var message in messages!) {
                final messageText = message['text'];
                final messagesender = message['Sender'];
                final messageBubble =
                    MessageBubble(Sender: messagesender, text: messageText);
                messageBubbles.add(messageBubble);
              }
              return Expanded(
                child: ListView(children: [
                  Column(
                    children: messageBubbles,
                  ),
                ]),
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
                    //Implement send functionality.
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
  MessageBubble({required this.Sender, required this.text});
  final String Sender;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children:<Widget> [
          Text(Sender),
          Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30),
              color: Color.fromARGB(255, 145, 117, 107),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(text,style: const TextStyle(color: Colors.white),),
              )),
        ],
      ),
    );
  }
}
