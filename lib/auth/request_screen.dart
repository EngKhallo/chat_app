import 'package:chat_app/auth/verification_screen.dart';
import 'package:chat_app/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestScreen extends StatelessWidget {
  RequestScreen({super.key});

  final phone_controller = TextEditingController();

  final loading = false.obs;

  void verifyPhoneNumber() {
    loading.value = true;
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone_controller.text,
      verificationCompleted: (PhoneAuthCredential credential) {
        // credential.smsCode
        FirebaseAuth.instance.signInWithCredential(credential).then((value) {
          Get.to(
              SplashScreen()); // this function automatically enters smsCode data to the verify Textfield of the next Page
        });
      },
      verificationFailed: (FirebaseAuthException error) {
        print(error.message);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      codeSent: (String verificationId, int? resendToken) {
        print('Code is Sent');
        Get.to(VerificationScreen(verificationId: verificationId));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Obx(() {
              return TextField(
                enabled: loading.isFalse,
                controller: phone_controller,
                decoration: InputDecoration(hintText: 'Phone Number '),
              );
            }),
            // SizedBox(height: 32),
            Obx(() {
              return ElevatedButton(
                onPressed: loading.isTrue ? null : verifyPhoneNumber,
                child:
                    loading.isTrue ? CircularProgressIndicator() : Text('Next'),
              );
            })
          ],
        ),
      ),
    );
  }
}
