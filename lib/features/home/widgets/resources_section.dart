import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../app/theme.dart';
import '../../../repositories/user_repository.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/responsive_layout.dart';

class ResourcesSection extends ConsumerWidget {
  const ResourcesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourcesAsync = ref.watch(resourcesProvider);
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      color: AppColors.primarySurface,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 48 : 80,
        horizontal: isMobile ? 20 : 40,
      ),
      child: MaxWidthBox(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        'বিনামূল্যে',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('ফ্রি রিসোর্সসমূহ', style: AppTextStyles.displaySmall),
                    const SizedBox(height: 6),
                    Text(
                      'গাইডলাইন, হিটম্যাপ বিশ্লেষণ এবং আরও অনেক কিছু',
                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mediumGray),
                    ),
                  ],
                ),
                if (!isMobile)
                  TextButton(
                    onPressed: () => context.go(AppRoutes.resources),
                    child: const Text('সব রিসোর্স →'),
                  ),
              ],
            ),
            const SizedBox(height: 36),
            resourcesAsync.when(
              data: (resources) {
                final displayed = resources.take(3).toList();
                return isMobile
                    ? ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayed.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (_, i) => _ResourceCard(resource: displayed[i]),
                )
                    : Row(
                  children: displayed
                      .map((r) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: displayed.indexOf(r) < displayed.length - 1 ? 20 : 0,
                      ),
                      child: _ResourceCard(resource: r),
                    ),
                  ))
                      .toList(),
                );
              },
              loading: () => const LoadingWidget(),
              error: (e, _) => AppErrorWidget(message: e.toString()),
            ),
            if (isMobile) ...[
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'সব রিসোর্স দেখুন',
                onPressed: () => context.go(AppRoutes.resources),
                width: double.infinity,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final dynamic resource;
  const _ResourceCard({required this.resource});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.subtle,
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.picture_as_pdf, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource.title ?? '',
                      style: AppTextStyles.headlineSmall.copyWith(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      resource.subject ?? '',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (resource.description?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            Text(
              resource.description,
              style: AppTextStyles.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: 'ডাউনলোড',
                  onPressed: () => context.go(
                    AppRoutes.pdfViewer,
                    extra: {'url': resource.fileUrl ?? '', 'title': resource.title ?? ''},
                  ),
                  icon: const Icon(Icons.download, size: 16),
                  height: 40,
                ),
              ),
              if (resource.hitMapUrl != null) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: SecondaryButton(
                    label: 'হিটম্যাপ',
                    onPressed: () {},
                    height: 40,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}