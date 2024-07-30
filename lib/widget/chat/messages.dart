import 'package:chatapp/widget/chat/messagebubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!userSnapshot.hasData) {
          return const Center(
            child: Text('Could not fetch user data.'),
          );
        }

        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chat')
              .orderBy('createdat', descending: true)
              .snapshots(),
          builder: (context, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No messages available.'),
              );
            }

            final chatDocs = chatSnapshot.data!.docs;

            return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (context, index) {
                return Messagebubble( key: ValueKey(chatDocs[index].id),
                  chatDocs[index]['text'],
                  chatDocs[index]['username'],
                  chatDocs[index]['userimage'],
                  chatDocs[index]['userid'] == userSnapshot.data!.uid,
                );
              },
            );
          },
        );
      },
    );
  }
}
