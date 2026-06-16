import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../core/providers/auth_provider.dart';
import '../../widgets/common/responsive_layout.dart';

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
  bool _rememberMe = false;

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
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop) _buildBrandPanel(),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isDesktop) _buildMobileLogo(),
                        _buildFormCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandPanel() {
    return Container(
      width: 480,
      padding: const EdgeInsets.all(48),
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.school, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 32),
          Text(
            'Job Prostuti',
            style: AppTextStyles.displayMedium.copyWith(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'বিসিএস, ব্যাংক, প্রাইমারি সহ\nসকল চাকরির প্রস্তুতি এক প্ল্যাটফর্মে',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
              height: 1.6,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              _BrandStat('৫০k+', 'সক্রিয়\nব্যবহারকারী'),
              const SizedBox(width: 40),
              _BrandStat('১০k+', 'মডেল\nটেস্ট'),
              const SizedBox(width: 40),
              _BrandStat('৯৮%', 'সাফল্যের\nহার'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLogo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.school, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 10),
          Text('Job Prostuti', style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary)),
          const SizedBox(height: 4),
          Text('আপনার অ্যাকাউন্টে প্রবেশ করুন',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray)),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.elevated,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('লগইন করুন', style: AppTextStyles.displaySmall.copyWith(fontSize: 24)),
          const SizedBox(height: 28),
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
                const SizedBox(height: 4),
                Row(
                  children: [
                    SizedBox(
                      height: 40,
                      child: CheckboxListTile(
                        value: _rememberMe,
                        onChanged: (v) => setState(() => _rememberMe = v ?? false),
                        title: Text('মনে রাখুন', style: AppTextStyles.bodySmall.copyWith(fontSize: 13)),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        dense: true,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.forgotPassword),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text('পাসওয়ার্ড ভুলে গেছেন?',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('লগইন করুন'),
                  ),
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
                child: Text('অথবা', style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray)),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: _isGoogleLoading ? null : _googleLogin,
            icon: _isGoogleLoading
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : Image.network(
                    'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                    width: 18,
                    height: 18,
                    errorBuilder: (_, _, _) => const Icon(Icons.g_mobiledata, size: 22),
                  ),
            label: Text('Google দিয়ে লগইন করুন',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkGray, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.darkGray,
              side: const BorderSide(color: AppColors.lightGray),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('অ্যাকাউন্ট নেই? ', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray)),
              TextButton(
                onPressed: () => context.go(AppRoutes.register),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('রেজিস্ট্রেশন করুন'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BrandStat extends StatelessWidget {
  final String value;
  final String label;
  const _BrandStat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.displayMedium.copyWith(color: Colors.white, fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.7)),
        ),
      ],
    );
  }
}
