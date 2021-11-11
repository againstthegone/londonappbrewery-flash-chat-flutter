import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../action_button.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool _showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
                onChanged: (value) {
                  email = value;
                },
                decoration: createTextFieldDecoration(
                  hintText: 'Enter your email',
                  borderSideColor: Colors.lightBlueAccent,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                style: TextStyle(color: Colors.black54),
                onChanged: (value) {
                  password = value;
                },
                decoration: createTextFieldDecoration(
                  hintText: 'Enter your password',
                  borderSideColor: Colors.lightBlueAccent,
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              ActionButton(
                'Log In',
                backgroundColor: Colors.lightBlueAccent,
                onPressed: () async {
                  setState(() {
                    _showSpinner = true;
                  });
                  try {
                    await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    Navigator.pushNamed(context, ChatScreen.id);
                  } catch (e) {
                    print(e);
                  } finally {
                    setState(() {
                      _showSpinner = false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        inAsyncCall: _showSpinner,
      ),
    );
  }
}
