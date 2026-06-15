import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../repositories/course_repository.dart';
import '../../widgets/common/custom_button.dart';

class EnrollmentScreen extends ConsumerStatefulWidget {
  final String courseId;
  const EnrollmentScreen({super.key, required this.courseId});

  @override
  ConsumerState<EnrollmentScreen> createState() => _EnrollmentScreenState();
}

class _EnrollmentScreenState extends ConsumerState<EnrollmentScreen> {
  bool _isLoading = false;
  String _selectedPayment = 'bkash';

  Future<void> _enroll() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(courseRepositoryProvider);
      await repo.enrollCourse(widget.courseId);
      if (mounted) {
        context.go('/courses/${widget.courseId}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('এনরোলমেন্ট সফল হয়েছে!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
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
    final courseAsync = ref.watch(courseDetailProvider(widget.courseId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('পেমেন্ট'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: courseAsync.when(
        data: (course) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order summary
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('অর্ডার সারসংক্ষেপ', style: AppTextStyles.headlineMedium),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(course.title, style: AppTextStyles.bodyMedium)),
                        Text(
                          course.isFree ? 'বিনামূল্যে' : '৳${course.effectivePrice.toInt()}',
                          style: AppTextStyles.headlineSmall.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                    if (course.hasDiscount) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ছাড় (${course.discountPercent}%)', style: AppTextStyles.bodySmall.copyWith(color: AppColors.success)),
                          Text(
                            '-৳${(course.price - course.effectivePrice).toInt()}',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.success),
                          ),
                        ],
                      ),
                    ],
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('মোট', style: AppTextStyles.headlineSmall),
                        Text(
                          course.isFree ? 'বিনামূল্যে' : '৳${course.effectivePrice.toInt()}',
                          style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (!course.isFree) ...[
                const SizedBox(height: 28),
                Text('পেমেন্ট পদ্ধতি', style: AppTextStyles.headlineMedium),
                const SizedBox(height: 16),
                _PaymentOption(
                  value: 'bkash',
                  label: 'bKash',
                  icon: Icons.phone_android,
                  color: const Color(0xFFE2136E),
                  groupValue: _selectedPayment,
                  onChanged: (v) => setState(() => _selectedPayment = v!),
                ),
                _PaymentOption(
                  value: 'nagad',
                  label: 'Nagad',
                  icon: Icons.account_balance_wallet,
                  color: const Color(0xFFFF6B35),
                  groupValue: _selectedPayment,
                  onChanged: (v) => setState(() => _selectedPayment = v!),
                ),
                _PaymentOption(
                  value: 'card',
                  label: 'ক্রেডিট / ডেবিট কার্ড',
                  icon: Icons.credit_card,
                  color: const Color(0xFF1B8E3D),
                  groupValue: _selectedPayment,
                  onChanged: (v) => setState(() => _selectedPayment = v!),
                ),
              ],

              const SizedBox(height: 32),
              GradientButton(
                label: course.isFree ? 'বিনামূল্যে এনরোল করুন' : 'পেমেন্ট করুন',
                onPressed: _enroll,
                isLoading: _isLoading,
                width: double.infinity,
              ),
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock, size: 14, color: AppColors.mediumGray),
                    const SizedBox(width: 6),
                    Text('নিরাপদ পেমেন্ট সিস্টেম', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
        loading: () => const LoadingWidget(fullScreen: true),
        error: (e, _) => AppErrorWidget(message: e.toString(), fullScreen: true),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const _PaymentOption({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.05) : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: selected ? color : AppColors.lightGray,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: AppTextStyles.headlineSmall.copyWith(fontSize: 15))),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: color,
            ),
          ],
        ),
      ),
    );
  }
}