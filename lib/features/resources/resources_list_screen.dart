import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../repositories/user_repository.dart';
import '../../widgets/common/custom_appbar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/responsive_layout.dart';

class ResourcesListScreen extends ConsumerWidget {
  const ResourcesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourcesAsync = ref.watch(resourcesProvider);
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      appBar: const AppBarWidget(title: 'ফ্রি রিসোর্স'),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
            child: Column(
              children: [
                Text('বিনামূল্যের রিসোর্সসমূহ', style: AppTextStyles.headlineLarge.copyWith(color: Colors.white), textAlign: TextAlign.center),
                const SizedBox(height: 4),
                Text('গাইডলাইন, হিটম্যাপ বিশ্লেষণ ডাউনলোড করুন', style: AppTextStyles.bodySmall.copyWith(color: Colors.white70), textAlign: TextAlign.center),
              ],
            ),
          ),
          Expanded(
            child: resourcesAsync.when(
              data: (resources) {
                if (resources.isEmpty) {
                  return const EmptyStateWidget(title: 'কোনো রিসোর্স নেই', icon: Icons.folder_open);
                }
                return GridView.builder(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 1 : (ResponsiveLayout.isDesktop(context) ? 3 : 2),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: isMobile ? 2.5 : 1.6,
                  ),
                  itemCount: resources.length,
                  itemBuilder: (_, i) => _ResourceCard(resource: resources[i]),
                );
              },
              loading: () => GridView.count(
                padding: const EdgeInsets.all(16),
                crossAxisCount: 1,
                childAspectRatio: 2.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: List.generate(5, (_) => const SkeletonBox(height: 110, borderRadius: 16)),
              ),
              error: (e, _) => AppErrorWidget(message: e.toString(), onRetry: () => ref.invalidate(resourcesProvider)),
            ),
          ),
        ],
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.lightGray),
        boxShadow: AppShadows.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  resource.type == 'video' ? Icons.play_circle_outline : Icons.picture_as_pdf,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(resource.title ?? '', style: AppTextStyles.headlineSmall.copyWith(fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                    Text(resource.subject ?? '', style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (resource.fileSizeKb != null && resource.fileSizeKb > 0)
                Text(resource.fileSizeFormatted ?? '', style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray)),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.download, size: 13, color: AppColors.mediumGray),
                  const SizedBox(width: 4),
                  Text('${resource.downloadCount}', style: AppTextStyles.bodySmall),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: 'দেখুন',
                  onPressed: () => context.go(
                    AppRoutes.pdfViewer,
                    extra: {'url': resource.fileUrl ?? '', 'title': resource.title ?? ''},
                  ),
                  height: 38,
                  icon: const Icon(Icons.open_in_new, size: 15),
                ),
              ),
              if (resource.hitMapUrl != null) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: SecondaryButton(
                    label: 'হিটম্যাপ',
                    onPressed: () => context.go(
                      AppRoutes.pdfViewer,
                      extra: {'url': resource.hitMapUrl!, 'title': '${resource.title} - হিটম্যাপ'},
                    ),
                    height: 38,
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