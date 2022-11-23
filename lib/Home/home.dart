import 'package:cloud_firestore/cloud_firestore.dart';
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
  final users = [].obs;

  void getAllUsers() async {
    final db = FirebaseFirestore.instance;
    final collection = db.collection('users');
    final results = await collection.get();

    print(results.size);

    final storage = FirebaseStorage.instance;

    // loping through the results
    for (final document in results.docs) {
      final user = {
        'name': document.data()['name'],
        'picture':
            await storage.ref('users').child(document.id).getDownloadURL(),
      };

      users.add(user);

      print(user);
    }
  }

  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Open Talk')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(CupertinoIcons.list_bullet),
        ),
        body: Obx(() {
          if (users.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (ctx, index) {
              final user = users[index];
              final name = user['name'];
              final picture = user['picture'];

              return ListTile(
                leading: CircleAvatar(backgroundImage: NetworkImage(picture), radius: 24),
                title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Chatting Details'),
                trailing: Icon(CupertinoIcons.trash_fill),
              );
            },
          );
        }));
  }
}
