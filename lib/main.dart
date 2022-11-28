import 'package:chat_app/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAOe1byGcFLFPkEFhgicY9MmuNQH7G2a-s",
          authDomain: "chat-app-27f56.firebaseapp.com",
          projectId: "chat-app-27f56",
          storageBucket: "chat-app-27f56.appspot.com",
          messagingSenderId: "695569355132",
          appId: "1:695569355132:web:bb89dea3896aa4c40b14f9",
          measurementId: "G-B79H2SBT1E"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}