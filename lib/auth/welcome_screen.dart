import 'package:chat_app/auth/request_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 150),
          SizedBox(
            child: Image.asset('assets/images/splash.png'),
          ),
          // SizedBox(height: 200),
          Column(
            children: [
              Text('OpenTalk',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: () {
                  Get.to(RequestScreen());
                },
                child: Text('Lets Start Talking'),
              ),
            ],
          )
        ],
      ),
    );
  }
}