

import 'package:chaw/home_screen.dart';
import 'package:chaw/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailControler = TextEditingController();
  TextEditingController _passwordControler = TextEditingController();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _emailControler.dispose();
    _passwordControler.dispose();
  }

  register() async {
    var userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailControler.text, password: _passwordControler.text);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("3 MORE CHAT FROM CHAT"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          height: 400,
          margin: EdgeInsets.only(left: 34),
          child: Column(
            children: [
              TextField(
                controller: _emailControler,
                decoration: InputDecoration(
                    hintText: "Email", prefixIcon: Icon(Icons.email)),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: _passwordControler,
                decoration: InputDecoration(
                    hintText: "Password", prefixIcon: Icon(Icons.lock)),
              ),
              SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: () {
                  register();
                },
                child: Text("Sign Up"),
              ),
              SizedBox(
                height: 12,
              ),
              InkWell(
                child: Text("Register"),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
