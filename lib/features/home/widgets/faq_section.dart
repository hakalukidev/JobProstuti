import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../repositories/user_repository.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/responsive_layout.dart';

class FaqSection extends ConsumerWidget {
  const FaqSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqAsync = ref.watch(faqProvider);
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 48 : 80,
        horizontal: isMobile ? 20 : 40,
      ),
      child: MaxWidthBox(
        maxWidth: 800,
        child: Column(
          children: [
            Text('সাধারণ প্রশ্নসমূহ', style: AppTextStyles.displaySmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'আমাদের সম্পর্কে প্রায়শই জিজ্ঞাসিত প্রশ্নের উত্তর',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mediumGray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            faqAsync.when(
              data: (faqs) => Column(
                children: faqs.map((faq) => _FaqItem(faq: faq)).toList(),
              ),
              loading: () => Column(
                children: List.generate(
                  5,
                      (_) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SkeletonBox(height: 60, borderRadius: AppRadius.lg),
                  ),
                ),
              ),
              error: (e, _) => AppErrorWidget(message: e.toString()),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final dynamic faq;
  const _FaqItem({required this.faq});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _ctrl;
  late Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _rotate = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: _expanded ? AppColors.primary.withOpacity(0.3) : AppColors.lightGray,
        ),
        boxShadow: _expanded ? AppShadows.subtle : [],
      ),
      child: InkWell(
        onTap: _toggle,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.faq.question ?? '',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: _expanded ? AppColors.primary : AppColors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  RotationTransition(
                    turns: _rotate,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _expanded ? AppColors.primary : AppColors.primarySurface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: _expanded ? Colors.white : AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _expanded
                    ? Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Text(
                    widget.faq.answer ?? '',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.mediumGray,
                      height: 1.7,
                    ),
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}