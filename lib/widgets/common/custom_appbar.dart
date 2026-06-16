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

  const AppBarWidget({super.key, this.showSearch = false, this.title});

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

            if (isDesktop) ...[
              const SizedBox(width: 40),
              _NavLink(label: 'হোম', route: AppRoutes.home),
              const SizedBox(width: 24),
              _NavLink(label: 'ফিচার', route: AppRoutes.features),
              const SizedBox(width: 24),
              _NavLink(label: 'প্যাকেজ প্ল্যান', route: AppRoutes.pricing),
              const SizedBox(width: 24),
              _NavLink(label: 'ব্লগ', route: AppRoutes.blog),
              const SizedBox(width: 24),
              _NavLink(label: 'ডাউনলোড অ্যাপ', route: AppRoutes.downloadApp),
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
    final isActive =
        currentRoute == route ||
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

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0D1B2A),
            Color(0xFF1B2838),
            Color(0xFF0D1B2A),
          ],
        ),
      ),
      child: Column(
        children: [
          MaxWidthBox(
            maxWidth: 1200,
            padding: EdgeInsets.fromLTRB(
              isMobile ? 16 : 32,
              isMobile ? 32 : 56,
              isMobile ? 16 : 32,
              isMobile ? 24 : 40,
            ),
            child: Column(
              children: [
                if (isMobile) ...[
                  _buildMobileLayout(context),
                  const SizedBox(height: 32),
                  _StoreBadgesRow(),
                  const SizedBox(height: 32),
                  _SocialRow(),
                ] else ...[
                  _buildDesktopLayout(context),
                  const SizedBox(height: 32),
                  _SocialRow(),
                ],
              ],
            ),
          ),
          _CopyrightBar(isMobile: isMobile),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: _BrandContactColumn(isDesktop: true),
        ),
        const SizedBox(width: 48),
        Expanded(
          flex: 2,
          child: _FooterLinkSection(
            title: 'গুরুত্বপূর্ণ লিংক',
            links: const [
              ('আমাদের সম্পর্কে', '/about'),
              ('ব্লগ', AppRoutes.blog),
              ('FAQ', '/faq'),
              ('প্যাকেজ সমূহ', AppRoutes.pricing),
            ],
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          flex: 2,
          child: _FooterLinkSection(
            title: 'নীতিমালা',
            links: const [
              ('প্রাইভেসি পলিসি', '/privacy'),
              ('শর্তাবলী', '/terms'),
              ('রিফান্ড পলিসি', '/refund'),
            ],
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          flex: 2,
          child: _StoreBadgesRow(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _BrandContactColumn(isDesktop: false),
        const SizedBox(height: 32),
        _FooterLinkSection(
          title: 'গুরুত্বপূর্ণ লিংক',
          links: const [
            ('আমাদের সম্পর্কে', '/about'),
            ('ব্লগ', AppRoutes.blog),
            ('FAQ', '/faq'),
            ('প্যাকেজ সমূহ', AppRoutes.pricing),
          ],
        ),
        const SizedBox(height: 24),
        _FooterLinkSection(
          title: 'নীতিমালা',
          links: const [
            ('প্রাইভেসি পলিসি', '/privacy'),
            ('শর্তাবলী', '/terms'),
            ('রিফান্ড পলিসি', '/refund'),
          ],
        ),
      ],
    );
  }
}

class _BrandContactColumn extends StatelessWidget {
  final bool isDesktop;

  const _BrandContactColumn({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final brandGradient = AppColors.primaryGradient;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: brandGradient,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 10),
            Text(
              'Job Prostuti',
              style: AppTextStyles.headlineMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'বিসিএস প্রস্তুতির স্মার্ট সঙ্গী',
          style: AppTextStyles.displaySmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.15),
                AppColors.accent.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.people, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                '৯ লাখ+ শিক্ষার্থীর বিশ্বাস',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _ContactRow(
          icon: Icons.email_outlined,
          text: 'support@jobprostuti.com',
          onTap: () {},
        ),
        const SizedBox(height: 8),
        _ContactRow(
          icon: Icons.phone_outlined,
          text: '01XXXXXXXX4',
          onTap: () {},
        ),
        const SizedBox(height: 8),
        _ContactRow(
          icon: Icons.location_on_outlined,
          text: '২২-২৭ স্টেশন রোড, তেজগাঁও, ঢাকা-১২১৫',
          onTap: () {},
        ),
      ],
    );
  }
}

class _ContactRow extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const _ContactRow({required this.icon, required this.text, this.onTap});

  @override
  State<_ContactRow> createState() => _ContactRowState();
}

class _ContactRowState extends State<_ContactRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = _isHovered ? AppColors.primary : Colors.white70;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                widget.text,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: color,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterLinkSection extends StatelessWidget {
  final String title;
  final List<(String, String)> links;

  const _FooterLinkSection({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.headlineMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        ...links.map(
          (link) => _FooterLink(
            label: link.$1,
            route: link.$2,
          ),
        ),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  final String route;

  const _FooterLink({required this.label, required this.route});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          onTap: () => context.go(widget.route),
          borderRadius: BorderRadius.circular(4),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: AppTextStyles.bodyMedium.copyWith(
              color: _isHovered ? AppColors.primary : Colors.white60,
              fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w400,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _isHovered ? 16 : 0,
                  height: 1.5,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(widget.label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StoreBadgesRow extends StatelessWidget {
  const _StoreBadgesRow();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'অ্যাপ ডাউনলোড করুন',
          style: AppTextStyles.headlineMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StoreBadge(
              icon: Icons.android,
              label: 'Google Play',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _StoreBadge(
              icon: Icons.apple,
              label: 'App Store',
              onTap: null,
              isComingSoon: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _StoreBadge extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isComingSoon;

  const _StoreBadge({
    required this.icon,
    required this.label,
    this.onTap,
    this.isComingSoon = false,
  });

  @override
  State<_StoreBadge> createState() => _StoreBadgeState();
}

class _StoreBadgeState extends State<_StoreBadge> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final effectiveOnTap =
        widget.isComingSoon ? null : widget.onTap;
    final opacity = widget.isComingSoon ? 0.6 : 1.0;

    return MouseRegion(
      onEnter: effectiveOnTap != null
          ? (_) => setState(() => _isHovered = true)
          : null,
      onExit: effectiveOnTap != null
          ? (_) => setState(() => _isHovered = false)
          : null,
      child: Opacity(
        opacity: opacity,
        child: InkWell(
          onTap: effectiveOnTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: _isHovered
                ? (Matrix4.translationValues(0, -2, 0))
                : Matrix4.identity(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: _isHovered
                  ? Colors.white.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.label,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      widget.isComingSoon ? 'শীঘ্রই আসছে' : 'এখনই ডাউনলোড',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
          ],
        ),
      ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'আমাদের অনুসরণ করুন',
          style: AppTextStyles.headlineMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SocialIcon(
              icon: Icons.facebook,
              label: 'Facebook',
              onTap: () {},
            ),
            const SizedBox(width: 12),
            _SocialIcon(
              icon: Icons.telegram,
              label: 'Telegram',
              onTap: () {},
            ),
            const SizedBox(width: 12),
            _SocialIcon(
              icon: Icons.youtube_searched_for,
              label: 'YouTube',
              onTap: () {},
            ),
            const SizedBox(width: 12),
            _SocialIcon(
              icon: Icons.camera_alt_outlined,
              label: 'Instagram',
              onTap: () {},
            ),
          ],
        ),
        SizedBox(height: 16),
        Image.asset(
          'assets/images/payment.png',
          height: 36,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _SocialIcon({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Tooltip(
        message: widget.label,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            transform: _isHovered
                ? (Matrix4.translationValues(0, -2, 0))
                : Matrix4.identity(),
            decoration: BoxDecoration(
              gradient: _isHovered
                  ? LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.3),
                        AppColors.accent.withValues(alpha: 0.2),
                      ],
                    )
                  : null,
              color: _isHovered ? null : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isHovered
                    ? AppColors.primary.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.1),
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              widget.icon,
              color: _isHovered ? AppColors.primary : Colors.white60,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _CopyrightBar extends StatelessWidget {
  final bool isMobile;

  const _CopyrightBar({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: MaxWidthBox(
        maxWidth: 1200,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 32,
          vertical: isMobile ? 16 : 20,
        ),
        child: Column(
          children: [
            if (isMobile) ...[
              Text(
                '© ২০২৬ Job Prostuti. সর্বস্বত্ব সংরক্ষিত।',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white38,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Developed by Hakaluki.dev',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary.withValues(alpha: 0.6),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '© ২০২৬ Job Prostuti. সর্বস্বত্ব সংরক্ষিত।',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white38,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'Developed by ',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white38,
                      ),
                      children: [
                        TextSpan(
                          text: 'Hakaluki.dev',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
