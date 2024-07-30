import 'dart:io';

import 'package:chatapp/widget/authform.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var isloading = false;

  void _submitAuthForm(String email, String name, String password,File? image , bool islogin,
      BuildContext ctx) async {
    UserCredential authresult;
    try {    
      setState(() {
        isloading = true;
      });
      if (islogin) {
        print('login attempt');
        authresult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        print('signup attempt');
        authresult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);


        final ref = FirebaseStorage.instance.ref().child('userimages').child(authresult.user!.uid + '.jpg');
        await ref.putFile(image!);

        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authresult.user!.uid)
            .set({'username': name, 'email': email, 'imageurl' : url});
        
      }
    } on PlatformException catch (err) {
      var messages = 'an error occured';
      if (err.message != null) {
        messages = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(messages)));
      setState(() {
        isloading = false;
      });
    } catch (err) {
      print(err); 
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Authform(_submitAuthForm));
  }
}
