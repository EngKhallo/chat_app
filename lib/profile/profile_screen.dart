import 'dart:io';

import 'package:chat_app/Home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final controller = TextEditingController();

  final selectedImage = ''.obs;

  void pickImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image?.path == null) {
      return;
    }

    selectedImage.value = image!.path;
  }

  void saveProfile() async {
    final name = controller.text;
    if (name.isEmpty || selectedImage.value.isEmpty) {
      return;
    }

    final picture = File(selectedImage.value);
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final db = FirebaseFirestore.instance;
    final collection = db.collection('users');
    final document = collection.doc(uid);
    await document.set({
      'name': name,
    });

    final storage = FirebaseStorage.instance;
    await storage.ref('users').child(uid).putFile(picture);

    Get.offAll(HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Profile')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              GestureDetector(
                  onTap: () => pickImage(),
                  child: Obx(() {
                    return CircleAvatar(
                      backgroundImage: selectedImage.value.isNotEmpty
                          ? FileImage(File(selectedImage.value))
                          : null,
                      radius: 42,
                      child: selectedImage.value.isEmpty
                          ? Icon(CupertinoIcons.person)
                          : null,
                    );
                  })),
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Enter Your Name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32)),
                onPressed: () => saveProfile(),
                child: Text('Save', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
