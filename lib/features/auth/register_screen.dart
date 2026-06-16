import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../core/providers/auth_provider.dart';
import '../../widgets/common/responsive_layout.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _agreeTerms = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  int get _passwordStrength {
    final p = _passwordCtrl.text;
    int score = 0;
    if (p.length >= 8) score++;
    if (p.contains(RegExp(r'[A-Z]'))) score++;
    if (p.contains(RegExp(r'[a-z]'))) score++;
    if (p.contains(RegExp(r'[0-9]'))) score++;
    if (p.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;
    return score;
  }

  Color get _strengthColor {
    final s = _passwordStrength;
    if (s <= 1) return AppColors.error;
    if (s <= 2) return AppColors.warning;
    if (s <= 3) return const Color(0xFF3B82F6);
    return AppColors.success;
  }

  String get _strengthLabel {
    final s = _passwordStrength;
    if (s <= 1) return 'দুর্বল';
    if (s <= 2) return 'মাঝারি';
    if (s <= 3) return 'ভালো';
    return 'শক্তিশালী';
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('অনুগ্রহ করে শর্তাবলী accept করুন'), backgroundColor: AppColors.error),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      await ref.read(authNotifierProvider.notifier).registerWithEmail(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        phone: _phoneCtrl.text.trim(),
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
            'আপনার স্বপ্নের চাকরি পাওয়ার\nপ্রস্তুতি শুরু হোক আজ থেকেই',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
              height: 1.6,
            ),
          ),
          const Spacer(),
          _buildBenefitList(),
        ],
      ),
    );
  }

  Widget _buildBenefitList() {
    const benefits = [
      Icons.auto_stories_rounded,
      Icons.quiz_rounded,
      Icons.analytics_rounded,
      Icons.support_agent_rounded,
    ];
    const labels = [
      'বিশেষজ্ঞ গাইডলাইন ও নোট',
      'মডেল টেস্ট ও লাইভ এক্সাম',
      'বিস্তারিত পারফরমেন্স এনালাইসিস',
      '২৪/৭ সাপোর্ট টিম',
    ];

    return Column(
      children: List.generate(benefits.length, (i) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(benefits[i], color: Colors.white, size: 18),
            ),
            const SizedBox(width: 14),
            Text(labels[i],
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.9))),
          ],
        ),
      )),
    );
  }

  Widget _buildMobileLogo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
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
          Text('আজই যোগ দিন এবং প্রস্তুতি শুরু করুন',
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
          Text('নতুন অ্যাকাউন্ট খুলুন', style: AppTextStyles.displaySmall.copyWith(fontSize: 22)),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'পূর্ণ নাম',
                    hintText: 'আপনার নাম লিখুন',
                    prefixIcon: Icon(Icons.person_outlined),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'নাম লিখুন' : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 14),
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
                const SizedBox(height: 14),
                TextFormField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'মোবাইল নম্বর',
                    hintText: '01XXXXXXXXX',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'মোবাইল নম্বর লিখুন';
                    if (!RegExp(r'^01[3-9]\d{8}$').hasMatch(v)) return 'সঠিক মোবাইল নম্বর লিখুন';
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: 'পাসওয়ার্ড',
                    hintText: 'ন্যূনতম ৮ অক্ষর',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'পাসওয়ার্ড লিখুন';
                    if (v.length < 8) return 'পাসওয়ার্ড ন্যূনতম ৮ অক্ষর';
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                if (_passwordCtrl.text.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildStrengthBar(),
                ],
                const SizedBox(height: 14),
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    labelText: 'পাসওয়ার্ড নিশ্চিত করুন',
                    hintText: 'আবার পাসওয়ার্ড লিখুন',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      icon: Icon(_obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    ),
                  ),
                  validator: (v) {
                    if (v != _passwordCtrl.text) return 'পাসওয়ার্ড মিলছে না';
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _register(),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(
                      height: 36,
                      child: CheckboxListTile(
                        value: _agreeTerms,
                        onChanged: (v) => setState(() => _agreeTerms = v ?? false),
                        title: Text(
                          'শর্তাবলী ও গোপনীয়তা নীতিতে সম্মত আছি',
                          style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        dense: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    child: _isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('রেজিস্ট্রেশন করুন'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ইতিমধ্যে অ্যাকাউন্ট আছে? ',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray)),
              TextButton(
                onPressed: () => context.go(AppRoutes.login),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('লগইন করুন'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthBar() {
    final strength = _passwordStrength;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 4,
            child: Row(
              children: List.generate(4, (i) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  color: i < strength ? _strengthColor : AppColors.lightGray,
                ),
              )),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'পাসওয়ার্ড: $_strengthLabel',
          style: AppTextStyles.bodySmall.copyWith(
            color: _strengthColor,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
