import 'dart:io';

import 'package:chatapp/widget/pickers/userimagpicker.dart';
import 'package:flutter/material.dart';

class Authform extends StatefulWidget {
  const Authform(this.submitfn);
  final void Function(String email, String name, String password, File? image,
      bool islogin, BuildContext ctx) submitfn;

  @override
  State<Authform> createState() => _AuthformState();
}

class _AuthformState extends State<Authform> {
  final _formkey = GlobalKey<FormState>();
  var _islogin = false;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File? _userimagefile;
  void _pickedimage(File image) {
    _userimagefile = image;
  }

  void _trysubmit() {
    final isvalid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userimagefile == null && !_islogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('please pick an image'),
        ),
      );
      return;
    }

    if (isvalid) {
      _formkey.currentState!.save();

      widget.submitfn(_userEmail, _userName, _userPassword, _userimagefile,
          _islogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_islogin) Userimagpicker(_pickedimage),
                  TextFormField(
                    key: ValueKey('email'),
                    onSaved: (newValue) {
                      _userEmail = newValue!;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  !_islogin
                      ? TextFormField(
                          key: ValueKey('username'),
                          onSaved: (newValue) {
                            _userName = newValue!;
                          },
                          decoration: InputDecoration(labelText: 'username'),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4) {
                              return 'password error';
                            }
                            return null;
                          },
                        )
                      : SizedBox(
                          height: 1,
                        ),
                  TextFormField(
                    key: ValueKey('password'),
                    onSaved: (newValue) {
                      _userPassword = newValue!;
                    },
                    decoration: InputDecoration(labelText: 'pass'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'passwrd error';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                      onPressed: _trysubmit,
                      child: Text(_islogin ? 'login' : 'signup')),
                  TextButton(
                      onPressed: () {
                        setState(
                          () {
                            _islogin = !_islogin;
                          },
                        );
                      },
                      child:
                          Text(_islogin ? 'signup instead' : 'login instead'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
