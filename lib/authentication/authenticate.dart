import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_assignment/screen/home_screen.dart';
import 'package:todo_assignment/screen/login_screen.dart';

class Authenticate extends StatelessWidget {
  Authenticate({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return HomeScreen();
    }
    else {
      return LoginScreen();
    }
  }
}