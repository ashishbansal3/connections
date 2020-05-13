import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';

import '.././../widgets/Auth_widgets/signup.dart';

class SignUpWithEmail extends StatefulWidget {
  @override
  static const routeName = '/sign-up';
  _SignUpWithEmailState createState() => _SignUpWithEmailState();
}

class _SignUpWithEmailState extends State<SignUpWithEmail> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading=false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    String city1,
    String city2,
    BuildContext ctx,
  ) async {
    AuthResult authResult;
    setState(() {
      _isLoading=true;
    });
    try {
    
      authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String key='';
      var value=city1.compareTo(city2);
      if(value>0)
      key=city1+city2;
      else
      key=city2+city1;
       await Firestore.instance.collection('groups').document(key).setData({
        'username': username,
        'id': authResult.user.uid,
      });

      await Firestore.instance
          .collection('users')
          .document(authResult.user.uid)
          .setData({
        'username': username,
        'email': email,
        'city1': city1,
        'city2': city2,
      });
      Navigator.of(context).pop();
    } on PlatformException catch (err) {
      setState(() {
        _isLoading=false;
      });
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
   
    } catch (err) {
      setState(() {
        _isLoading=false;
      });
      print(err);
     
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading?CircularProgressIndicator(): Scaffold(
      backgroundColor: Colors.grey[400],
      body: SignUp(
        _submitAuthForm,
  
      ),
    );
  }
}
