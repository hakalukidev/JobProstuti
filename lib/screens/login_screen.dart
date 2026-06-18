// lib/screens/login_screen.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in_web/google_sign_in_web.dart' as gsi_web;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../app/theme.dart';
import 'register_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('🟢 Google Sign-In started');
      final String webClientId = dotenv.env['WEB_CLIENT_ID'] ?? '';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: kIsWeb ? webClientId : null,
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print('🟡 User cancelled sign-in');
        setState(() { _isLoading = false; });
        return;
      }

      print('🟢 User: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('🟢 Firebase signing in...');
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      print('🟢 Login successful! User: ${userCredential.user?.email}');

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      print('🔴 Firebase Auth Error: ${e.code} - ${e.message}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Firebase Error: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('🔴 General Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google লগইন ব্যর্থ হয়েছে: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                )
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          'স্বাগতম',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF022C22),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'আপনার অ্যাকাউন্টে লগইন করুন',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  const Text('ইমেইল বা নাম', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _identifierController,
                    decoration: InputDecoration(
                      hintText: 'আপনার ইমেইল বা নাম লিখুন',
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    validator: (value) => value!.isEmpty ? 'অনুগ্রহ করে এটি পূরণ করুন' : null,
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('পাসওয়ার্ড', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                      TextButton(
                        onPressed: () {},
                        child: const Text('পাসওয়ার্ড ভুলে গেছেন?', style: TextStyle(fontSize: 12, color: Color(0xFF0095FF))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'আপনার পাসওয়ার্ড লিখুন',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    validator: (value) => value!.length < 6 ? 'পাসওয়ার্ড অন্তত ৬ অক্ষরের হতে হবে' : null,
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                        if (_formKey.currentState!.validate()) {
                          // Email Login
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                          : const Text('লগইন করুন', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('অথবা', style: TextStyle(color: Colors.grey, fontSize: 12))),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ✅ Google Login Button (সঠিক UI)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google Button
                      SizedBox(
                        width: 140,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : _signInWithGoogle,
                          icon: _isLoading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                              : const Icon(Icons.g_mobiledata_rounded, size: 20),
                          label: Text(_isLoading ? '' : 'Google'),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Facebook Button
                      SizedBox(
                        width: 140,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.facebook_rounded, size: 18, color: Color(0xFF1877F2)),
                          label: const Text('Facebook'),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('অ্যাকাউন্ট নেই? ', style: TextStyle(color: Color(0xFF64748B))),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                          },
                          child: Text('নতুন অ্যাকাউন্ট তৈরি করুন', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}