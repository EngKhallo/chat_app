import 'dart:async';

import 'package:chat_app/Home/home.dart';
import 'package:chat_app/auth/welcome_screen.dart';
import 'package:chat_app/profile/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    final auth = FirebaseAuth.instance;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (auth.currentUser == null) {
        Get.offAll(WelcomePage());
      } else {
        final db = FirebaseFirestore.instance;
        final collection = db.collection('users');
        final uid = auth.currentUser!.uid;
        final document = collection.doc(uid);

        document.get().then((value) { 
          if (!value.exists) {
            Get.off(ProfilePage());
          } else {
            Get.offAll(HomeScreen());
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
