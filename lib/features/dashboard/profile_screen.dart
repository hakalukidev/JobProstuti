import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../core/providers/auth_provider.dart';
import '../../repositories/user_repository.dart';
import '../../widgets/common/custom_appbar.dart';
import '../../widgets/common/custom_button.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await ref.read(userRepositoryProvider).updateProfile({
        'name': _nameCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
      });
      if (mounted) {
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('প্রোফাইল আপডেট হয়েছে'), backgroundColor: AppColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('লগআউট করবেন?'),
        content: const Text('আপনি কি লগআউট করতে চান?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('না')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('হ্যাঁ'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref.read(authNotifierProvider.notifier).logout();
      if (mounted) context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).value;

    if (user != null && !_isEditing) {
      _nameCtrl.text = user.name;
      _phoneCtrl.text = user.phone ?? '';
    }

    return Scaffold(
      appBar: AppBarWidget(
        title: 'প্রোফাইল',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar section
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: AppColors.primarySurface,
                    backgroundImage: user?.avatarUrl != null ? NetworkImage(user!.avatarUrl!) : null,
                    child: user?.avatarUrl == null
                        ? Text(
                      user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'U',
                      style: AppTextStyles.displayMedium.copyWith(color: AppColors.primary),
                    )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(user?.name ?? '', style: AppTextStyles.headlineLarge),
            Text(user?.email ?? '', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray)),
            if (user?.isPremium == true) ...[
              const SizedBox(height: 8),
              AppBadge(
                label: '✨ প্রিমিয়াম সদস্য',
                backgroundColor: AppColors.warning.withOpacity(0.1),
                textColor: AppColors.warning,
              ),
            ],
            const SizedBox(height: 28),

            // Edit form
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.lightGray),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ব্যক্তিগত তথ্য', style: AppTextStyles.headlineMedium),
                      TextButton.icon(
                        onPressed: () => setState(() => _isEditing = !_isEditing),
                        icon: Icon(_isEditing ? Icons.close : Icons.edit, size: 16),
                        label: Text(_isEditing ? 'বাতিল' : 'সম্পাদনা'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _isEditing
                      ? Column(
                    children: [
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(labelText: 'পূর্ণ নাম', prefixIcon: Icon(Icons.person_outlined)),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(labelText: 'মোবাইল নম্বর', prefixIcon: Icon(Icons.phone_outlined)),
                      ),
                      const SizedBox(height: 20),
                      GradientButton(label: 'সংরক্ষণ করুন', onPressed: _save, isLoading: _isSaving, width: double.infinity),
                    ],
                  )
                      : Column(
                    children: [
                      _InfoRow(Icons.person_outlined, 'নাম', user?.name ?? ''),
                      _InfoRow(Icons.email_outlined, 'ইমেইল', user?.email ?? ''),
                      if (user?.phone != null) _InfoRow(Icons.phone_outlined, 'মোবাইল', user!.phone!),
                      _InfoRow(Icons.calendar_today_outlined, 'যোগদানের তারিখ',
                          user?.createdAt != null ? '${user!.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}' : ''),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Menu items
            _MenuSection(
              items: [
                _MenuItem(icon: Icons.quiz_outlined, label: 'পরীক্ষার ইতিহাস', onTap: () => context.go(AppRoutes.examHistory)),
                _MenuItem(icon: Icons.bookmark_outlined, label: 'বুকমার্ক', onTap: () => context.go(AppRoutes.bookmarks)),
                _MenuItem(icon: Icons.notifications_outlined, label: 'নোটিফিকেশন সেটিংস', onTap: () {}),
                _MenuItem(icon: Icons.lock_outlined, label: 'পাসওয়ার্ড পরিবর্তন', onTap: () {}),
              ],
            ),

            const SizedBox(height: 12),

            _MenuSection(
              items: [
                _MenuItem(icon: Icons.help_outline, label: 'সাহায্য ও সাপোর্ট', onTap: () {}),
                _MenuItem(icon: Icons.privacy_tip_outlined, label: 'গোপনীয়তা নীতি', onTap: () {}),
                _MenuItem(icon: Icons.description_outlined, label: 'শর্তাবলী', onTap: () {}),
              ],
            ),

            const SizedBox(height: 20),

            // Logout
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: AppColors.error),
                label: const Text('লগআউট'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.mediumGray),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray)),
              Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          return Column(
            children: [
              e.value,
              if (e.key < items.length - 1) const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.mediumGray),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.mediumGray),
          ],
        ),
      ),
    );
  }
}