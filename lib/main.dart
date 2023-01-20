import 'package:chaw/home_screen.dart';
import 'package:chaw/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _usernameConrtoler = TextEditingController();
  TextEditingController _emailControler = TextEditingController();
  TextEditingController _passwordControler = TextEditingController();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _usernameConrtoler.dispose();
    _emailControler.dispose();
    _passwordControler.dispose();
  }

  register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailControler.text, password: _passwordControler.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    _firestore.collection("users").doc(_auth.currentUser!.uid).set({
      "username": _usernameConrtoler.text,
      "uid": FirebaseAuth.instance.currentUser!.uid
    });
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
                controller: _usernameConrtoler,
                decoration: InputDecoration(
                    hintText: "user name", prefixIcon: Icon(Icons.person)),
              ),
              SizedBox(
                height: 5,
              ),
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
                child: Text("Login"),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Login()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
