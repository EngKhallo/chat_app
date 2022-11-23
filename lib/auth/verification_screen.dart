import 'package:chat_app/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationScreen extends StatelessWidget {
  VerificationScreen({super.key, required this.verificationId});

  final controller = TextEditingController();

  final String verificationId;

  void SignIn() async {
    final auth = FirebaseAuth.instance;
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: controller.text,
    );
      print(verificationId);

    try {
      await auth.signInWithCredential(credential);
      Get.offAll(SplashScreen());
      print('enter successfully');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
                controller: controller,
                decoration: InputDecoration(hintText: '#####')),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: SignIn,
              child: Text('Verify'),
            )
          ],
        ),
      ),
    );
  }
}
