import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_assignment/screen/login_screen.dart';

Future<User?> createAccount(String name, String email, String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    User? user = (
      await auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      )
    ).user;

    if (user != null) {
      print('Account created successfully');
      
      user.updateProfile(displayName: name);

      await firestore.collection('users').doc(auth.currentUser!.uid).set({
        'name' : name,
        'email' : email,
        'status' : 'Unavailable',
        'uid' : auth.currentUser!.uid
      });
      return user;
    }
    else {
      print('Account creation failed');
    }
  } catch (e) {
    print(e);
    return null;
  }
  return null;
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  try {
    User? user = (
      await auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      )
    ).user;

    if (user != null) {
      print('Login Successgul');
      return user;
    }
    else {
      print('Login Failed');
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future logOut(BuildContext context) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await auth.signOut().then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  } catch (e) {
    print('error');
  }
}