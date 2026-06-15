import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../core/providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await ref.read(authNotifierProvider.notifier).loginWithEmail(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
      if (mounted) context.go(AppRoutes.home);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _googleLogin() async {
    setState(() => _isGoogleLoading = true);
    try {
      await ref.read(authNotifierProvider.notifier).loginWithGoogle();
      if (mounted) context.go(AppRoutes.home);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 440),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  // Logo
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.school, color: Colors.white, size: 32),
                        ),
                        const SizedBox(height: 12),
                        Text('Job Prostuti', style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  Text('লগইন করুন', style: AppTextStyles.displaySmall.copyWith(fontSize: 26)),
                  const SizedBox(height: 6),
                  Text(
                    'আপনার অ্যাকাউন্টে প্রবেশ করুন',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
                  ),
                  const SizedBox(height: 32),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'ইমেইল',
                            hintText: 'আপনার ইমেইল লিখুন',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'ইমেইল লিখুন';
                            if (!v.contains('@')) return 'সঠিক ইমেইল লিখুন';
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'পাসওয়ার্ড',
                            hintText: 'আপনার পাসওয়ার্ড লিখুন',
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'পাসওয়ার্ড লিখুন';
                            if (v.length < 6) return 'পাসওয়ার্ড ন্যূনতম ৬ অক্ষর';
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _login(),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => context.go(AppRoutes.forgotPassword),
                            child: const Text('পাসওয়ার্ড ভুলে গেছেন?'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GradientButton(
                          label: 'লগইন করুন',
                          onPressed: _login,
                          isLoading: _isLoading,
                          width: double.infinity,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('অথবা', style: AppTextStyles.bodySmall),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Google sign in
                  OutlinedButton(
                    onPressed: _isGoogleLoading ? null : _googleLogin,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkGray,
                      side: const BorderSide(color: AppColors.lightGray),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isGoogleLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.g_mobiledata, size: 22),
                        const SizedBox(width: 8),
                        Text('Google দিয়ে লগইন', style: AppTextStyles.labelLarge.copyWith(color: AppColors.darkGray)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('অ্যাকাউন্ট নেই? ', style: AppTextStyles.bodyMedium),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.register),
                        child: const Text('রেজিস্ট্রেশন করুন'),
                      ),
                    ],
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