import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '.././../widgets/Auth_widgets/login.dart';

class SignIn extends StatefulWidget {
  @override
  static const routeName = '/sign-in';
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    BuildContext ctx,
  ) async {
    AuthResult authResult;
    setState(() {
      _isLoading = true;
    });
    try {
      authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('123456');
      Navigator.of(context).pop();
    } on PlatformException catch (err) {
      setState(() {
        _isLoading = false;
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
        _isLoading = false;
      });
      print('abccd');
      print(err);
    }
  }

  Widget build(BuildContext context) {
    print('sign innnnnnnnnnnnnnnnn');
    return _isLoading
        ? CircularProgressIndicator()
        : Scaffold(
            backgroundColor: Colors.grey[400],
            body: LogIn(
              _submitAuthForm,
            ),
          );
  }
}
