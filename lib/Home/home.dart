import 'package:chat_app/screens/find_users_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final chats = [].obs;
  final loading = true.obs;

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final db = FirebaseFirestore.instance;
    final usersCol = db.collection('users');

    usersCol.doc(uid).collection('chats').snapshots().listen((event) async {
      chats.clear();
      for (var doc in event.docs) {
        final user = await usersCol.doc(doc.id).get();
        chats.add({
          'id': doc.id,
          'name': user.data()?['name'] ?? 'Null',
          'picture': await FirebaseStorage.instance
              .ref('users')
              .child(doc.id)
              .getDownloadURL(),
          'lastMessage': doc.data()['lastMessage'],
        });
      }
      loading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Open Talk'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(FindUsers());
          },
          child: Icon(CupertinoIcons.list_bullet),
        ),
        body: Obx(() {
          if (loading.isTrue) {
            return Center(child: CircularProgressIndicator());
          } else {
            return buildList();
          }
        }));
  }

  buildList() {
    return Obx(() {
      if (chats.isEmpty) {
        return Center(child: Text('No Chats'));
      } else {
        return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (ctx, index) {
                final chat = chats[index];
                final id = chat['name'];
                final lastMessage = chat['lastMessage'];

                return ListTile(
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(chat['picture']), radius: 24),
                  title:
                      Text(chat['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(lastMessage['messagee']),
                );
              },
            );
          }
      });
    }
  }
