import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../core/services/auth_service.dart';
import '../../widgets/common/custom_button.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.forgotPassword(_emailCtrl.text.trim());
      if (mounted) setState(() => _sent = true);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go(AppRoutes.login)),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 440),
          padding: const EdgeInsets.all(24),
          child: _sent ? _SuccessView() : _FormView(
            formKey: _formKey,
            emailCtrl: _emailCtrl,
            isLoading: _isLoading,
            onSend: _send,
          ),
        ),
      ),
    );
  }
}

class _FormView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final bool isLoading;
  final VoidCallback onSend;

  const _FormView({
    required this.formKey,
    required this.emailCtrl,
    required this.isLoading,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(36),
          ),
          child: const Icon(Icons.lock_reset, color: AppColors.primary, size: 36),
        ),
        const SizedBox(height: 24),
        Text('পাসওয়ার্ড রিসেট', style: AppTextStyles.displaySmall.copyWith(fontSize: 24)),
        const SizedBox(height: 8),
        Text(
          'আপনার ইমেইল দিন। আমরা পাসওয়ার্ড রিসেট লিংক পাঠাবো।',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
        ),
        const SizedBox(height: 32),
        Form(
          key: formKey,
          child: TextFormField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'ইমেইল',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'ইমেইল লিখুন';
              if (!v.contains('@')) return 'সঠিক ইমেইল লিখুন';
              return null;
            },
          ),
        ),
        const SizedBox(height: 24),
        GradientButton(
          label: 'রিসেট লিংক পাঠান',
          onPressed: onSend,
          isLoading: isLoading,
          width: double.infinity,
        ),
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(Icons.mark_email_read, color: AppColors.success, size: 40),
        ),
        const SizedBox(height: 24),
        Text('ইমেইল পাঠানো হয়েছে!', style: AppTextStyles.displaySmall.copyWith(fontSize: 22)),
        const SizedBox(height: 12),
        Text(
          'আপনার ইমেইলে পাসওয়ার্ড রিসেট লিংক পাঠানো হয়েছে। ইমেইল চেক করুন।',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        PrimaryButton(
          label: 'লগইন পেজে যান',
          onPressed: () => context.go(AppRoutes.login),
          width: 200,
        ),
      ],
    );
  }
}