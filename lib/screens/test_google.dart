// lib/test_google.dart (একটা separate test file বানাও)
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class TestGoogleSignIn extends StatelessWidget {
  const TestGoogleSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Test')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final GoogleSignIn googleSignIn = GoogleSignIn();
              final GoogleSignInAccount? user = await googleSignIn.signIn();
              print('User: ${user?.email}');
            } catch (e) {
              print('Error: $e');
            }
          },
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}