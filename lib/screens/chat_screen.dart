import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User? loggedInUser;
  String? messageText;
  final _messageTextController = TextEditingController();

  void getCurrentUser() async {
    final user = _auth.currentUser;
    loggedInUser = user;
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _firestore.collection('/messages').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }

                return Expanded(
                  child: ListView(
                    reverse: true,
                    children: snapshot.data!.docs.reversed
                        .map(
                          (doc) => MessageBubble(
                            text: doc.data()['text'],
                            sender: doc.data()['sender'],
                            isUser: loggedInUser?.email == doc.data()['sender'],
                          ),
                        )
                        .toList(),
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
                      controller: _messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      style: TextStyle(color: Colors.black54),
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _messageTextController.clear();
                      _firestore.collection('/messages').add({
                        'text': messageText,
                        'sender': loggedInUser?.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _messageTextController.dispose();
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isUser;

  MessageBubble(
      {required this.sender, required this.text, this.isUser = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 12.0),
          ),
          Material(
            elevation: 5.0,
            borderRadius: isUser
                ? BorderRadius.all(Radius.circular(30.0))
                    .copyWith(topRight: Radius.zero)
                : BorderRadius.all(Radius.circular(30.0))
                    .copyWith(topLeft: Radius.zero),
            color: isUser ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                '$text',
                style: TextStyle(
                    fontSize: 15.0,
                    color: isUser ? Colors.white : Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
