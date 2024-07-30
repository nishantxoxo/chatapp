import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Newmessage extends StatefulWidget {
  const Newmessage({super.key});

  @override
  State<Newmessage> createState() => _NewmessageState();
}

class _NewmessageState extends State<Newmessage> {
  var _enteredmessage = '';
  final controller = new TextEditingController();

  void sendmessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser;
    final userdata = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredmessage,
      'createdat': Timestamp.now(),
      'userid': user!.uid,
      'username': userdata['username'],
      'userimage': userdata['imageurl']
    });
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(label: Text('send messgage...')),
              onChanged: (value) {
                setState(() {
                  _enteredmessage = value;
                });
              },
            ),
          ),
          IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: _enteredmessage.trim().isEmpty ? null : sendmessage,
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
