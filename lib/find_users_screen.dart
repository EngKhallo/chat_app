import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class FindUsers extends StatefulWidget {
  const FindUsers({super.key});

  @override
  State<FindUsers> createState() => _FindUsersState();
}

class _FindUsersState extends State<FindUsers> {
  final users = [].obs;

  void getAllUsers() async {
    final db = FirebaseFirestore.instance;
    final collection = db.collection('users');
    final results = await collection.get();

    print(results.size);

    final storage = FirebaseStorage.instance;

    // loping through the results
    for (final document in results.docs) {
      if(document.id == FirebaseAuth.instance.currentUser!.uid) {
        continue;
      }
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
      appBar: AppBar(title: Text('All Connects')),
      body: Obx(
        () {
          if (users.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (ctx, index) {
                final user = users[index];
                final name = user['name'];
                final picture = user['picture'];

                return ListTile(
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(picture), radius: 24),
                  title:
                      Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Chatting Details'),
                  trailing: Icon(CupertinoIcons.trash_fill),
                );
              },
            );
          }
        },
      ),
    );
  }
}
