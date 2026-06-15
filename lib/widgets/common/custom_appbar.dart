import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../core/providers/auth_provider.dart';
import 'responsive_layout.dart';

class AppBarWidget extends ConsumerWidget implements PreferredSizeWidget {
  final bool showSearch;
  final String? title;

  const AppBarWidget({
    super.key,
    this.showSearch = false,
    this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isMobile = ResponsiveLayout.isMobile(context);

    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: AppColors.lightGray,
      toolbarHeight: 64,
      titleSpacing: 0,
      leading: isMobile && title != null ? null : const SizedBox.shrink(),
      leadingWidth: isMobile && title != null ? 56 : 0,
      title: MaxWidthBox(
        child: Row(
          children: [
            if (isMobile && title != null) ...[
              const SizedBox(width: 8),
            ] else ...[
              // Logo
              GestureDetector(
                onTap: () => context.go(AppRoutes.home),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.school,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Job Prostuti',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.primary,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (isDesktop) ...[
              const SizedBox(width: 40),
              _NavLink(label: 'হোম', route: AppRoutes.home),
              const SizedBox(width: 24),
              _NavLink(label: 'কোর্স', route: AppRoutes.courses),
              const SizedBox(width: 24),
              _NavLink(label: 'লাইভ পরীক্ষা', route: AppRoutes.liveExams),
              const SizedBox(width: 24),
              _NavLink(label: 'প্রশ্নব্যাংক', route: AppRoutes.questionBank),
              const SizedBox(width: 24),
              _NavLink(label: 'রিসোর্স', route: AppRoutes.resources),
              const SizedBox(width: 24),
              _NavLink(label: 'মূল্য তালিকা', route: AppRoutes.pricing),
            ],

            if (title != null && isMobile) ...[
              Text(
                title!,
                style: AppTextStyles.headlineMedium,
              ),
            ],

            const Spacer(),

            // Right actions
            _buildActions(context, ref, isDesktop),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref, bool isDesktop) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final user = ref.watch(authNotifierProvider).value;

    if (isAuthenticated && user != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isDesktop) ...[
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined),
              color: AppColors.mediumGray,
              tooltip: 'নোটিফিকেশন',
            ),
            const SizedBox(width: 8),
          ],
          GestureDetector(
            onTap: () => context.go(AppRoutes.dashboard),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primarySurface,
              backgroundImage: user.avatarUrl != null
                  ? NetworkImage(user.avatarUrl!)
                  : null,
              child: user.avatarUrl == null
                  ? Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              )
                  : null,
            ),
          ),
          if (isDesktop) ...[
            const SizedBox(width: 8),
            Text(
              user.name.split(' ').first,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () => context.go(AppRoutes.login),
          child: Text(
            'লগইন',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (isDesktop) ...[
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.register),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              minimumSize: Size.zero,
            ),
            child: const Text('রেজিস্ট্রেশন'),
          ),
        ],
      ],
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final String route;

  const _NavLink({required this.label, required this.route});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).matchedLocation;
    final isActive = currentRoute == route ||
        (route != '/' && currentRoute.startsWith(route));

    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isActive ? AppColors.primary : AppColors.darkGray,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// Web footer
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A2535),
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: MaxWidthBox(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.school, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Job Prostuti',
                            style: AppTextStyles.headlineMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'বাংলাদেশের সকল চাকরির পরীক্ষার প্রস্তুতিতে আমরা আপনার পাশে আছি।',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _SocialIcon(Icons.facebook, 'Facebook'),
                          _SocialIcon(Icons.telegram, 'Telegram'),
                          _SocialIcon(Icons.youtube_searched_for, 'YouTube'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 48),
                // Links
                Expanded(
                  child: _FooterSection(
                    title: 'কোর্সসমূহ',
                    links: [
                      'বিসিএস প্রস্তুতি',
                      'প্রাইমারি শিক্ষক',
                      'NTRCA প্রস্তুতি',
                      'ব্যাংক প্রস্তুতি',
                      'সকল কোর্স দেখুন',
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _FooterSection(
                    title: 'সহায়তা',
                    links: [
                      'আমাদের সম্পর্কে',
                      'যোগাযোগ',
                      'গোপনীয়তা নীতি',
                      'শর্তাবলী',
                      'FAQ',
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            const Divider(color: Colors.white12),
            const SizedBox(height: 24),
            Text(
              '© ${DateTime.now().year} Job Prostuti. সর্বস্বত্ব সংরক্ষিত।',
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;

  const _SocialIcon(this.icon, this.tooltip);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white70, size: 18),
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  final String title;
  final List<String> links;

  const _FooterSection({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.headlineSmall.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 16),
        ...links.map((link) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            link,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white60),
          ),
        )),
      ],
    );
  }
}