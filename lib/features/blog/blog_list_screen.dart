import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app/theme.dart';
import '../../widgets/common/custom_appbar.dart';
import '../../widgets/common/responsive_layout.dart';
import '../../core/providers/blog_provider.dart';
import '../../models/blog_model.dart';
import 'widgets/blog_card.dart';

class BlogListScreen extends ConsumerStatefulWidget {
  const BlogListScreen({super.key});

  @override
  ConsumerState<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends ConsumerState<BlogListScreen> {
  String? _selectedCategory;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BlogModel> _filteredBlogs(List<BlogModel> blogs) {
    var result = blogs;
    if (_selectedCategory != null) {
      result = result.where((b) => b.category == _selectedCategory).toList();
    }
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result.where((b) =>
        b.title.toLowerCase().contains(query) ||
        b.excerpt.toLowerCase().contains(query) ||
        b.tags.any((t) => t.toLowerCase().contains(query))
      ).toList();
    }
    return result;
  }

  List<String> _extractCategories(List<BlogModel> blogs) {
    return blogs.map((b) => b.category).toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    final blogsAsync = ref.watch(blogsProvider);
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      appBar: const AppBarWidget(),
      body: blogsAsync.when(
        loading: () => _buildLoadingState(isMobile),
        error: (error, _) => _buildErrorState(error, isMobile),
        data: (blogs) {
          final categories = _extractCategories(blogs);
          final filtered = _filteredBlogs(blogs);
          return _buildContent(blogs, filtered, categories, isMobile);
        },
      ),
    );
  }

  Widget _buildContent(List<BlogModel> allBlogs, List<BlogModel> filtered,
      List<String> categories, bool isMobile) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(isMobile, categories),
          if (filtered.isEmpty)
            _buildEmptyState(isMobile)
          else ...[
            _buildFeaturedPost(allBlogs, isMobile),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 40,
                vertical: 32,
              ),
              child: _buildBlogGrid(filtered, isMobile),
            ),
          ],
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile, List<String> categories) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: CustomPaint(painter: _DotPatternPainter()),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 40,
              vertical: isMobile ? 32 : 56,
            ),
            child: MaxWidthBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'আমাদের ব্লগ সমূহ',
                    style: AppTextStyles.displayMedium.copyWith(
                      color: AppColors.white,
                      fontSize: isMobile ? 28 : 36,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: isMobile ? double.infinity : 600,
                    child: Text(
                      'প্রস্তুতিকে সহজ ও সুন্দর করতে গুরুত্বপূর্ণ সব ইনফরমেশনস পাবেন এখানেই',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Search bar
                  _buildSearchBar(isMobile),
                  const SizedBox(height: 16),
                  // Category chips
                  _buildCategoryChips(categories, isMobile),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isMobile) {
    return SizedBox(
      width: isMobile ? double.infinity : 400,
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
        decoration: InputDecoration(
          hintText: 'ব্লগ অনুসন্ধান করুন...',
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
          prefixIcon: Icon(Icons.search, color: Colors.white.withValues(alpha: 0.7), size: 20),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close, color: Colors.white.withValues(alpha: 0.7), size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(List<String> categories, bool isMobile) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'সবগুলো',
            isSelected: _selectedCategory == null,
            onTap: () => setState(() => _selectedCategory = null),
          ),
          const SizedBox(width: 8),
          ...categories.map((cat) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _FilterChip(
              label: cat,
              isSelected: _selectedCategory == cat,
              onTap: () => setState(() => _selectedCategory = cat),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildFeaturedPost(List<BlogModel> blogs, bool isMobile) {
    // Pick the blog with most views as featured
    final featured = blogs.isNotEmpty
        ? blogs.reduce((a, b) => a.viewCount > b.viewCount ? a : b)
        : null;
    if (featured == null) return const SizedBox.shrink();
    // If filtered list doesn't include featured, skip
    if (_selectedCategory != null && featured.category != _selectedCategory) {
      return const SizedBox.shrink();
    }

    final catColor = _categoryColor(featured.category);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 40,
        isMobile ? 24 : 32,
        isMobile ? 16 : 40,
        0,
      ),
      child: MaxWidthBox(
        child: Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          elevation: 4,
          shadowColor: AppColors.black.withValues(alpha: 0.1),
          child: InkWell(
            onTap: () => _showComingSoon(featured.title),
            borderRadius: BorderRadius.circular(20),
            child: IntrinsicHeight(
              child: Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: const Radius.circular(20),
                      bottom: isMobile ? Radius.zero : const Radius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: featured.imageUrl,
                          height: isMobile ? 240 : 300,
                          width: isMobile ? double.infinity : 400,
                          fit: BoxFit.cover,
                          placeholder: (_, _) => Container(
                            height: isMobile ? 240 : 300,
                            width: isMobile ? double.infinity : 400,
                            color: AppColors.lightGray,
                          ),
                          errorWidget: (_, _, _) => Container(
                            height: isMobile ? 240 : 300,
                            width: isMobile ? double.infinity : 400,
                            color: AppColors.lightGray,
                            child: const Icon(Icons.image_not_supported, size: 48, color: AppColors.mediumGray),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.15),
                                  Colors.black.withValues(alpha: 0.5),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: catColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: catColor.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              featured.category,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _MetaRow(Icons.star, 'ফিচার্ড', catColor),
                              const SizedBox(width: 12),
                              _MetaRow(Icons.visibility_outlined,
                                  '${_formatCount(featured.viewCount)} ভিউ', AppColors.mediumGray),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            featured.title,
                            style: AppTextStyles.displaySmall.copyWith(fontSize: isMobile ? 20 : 24),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Text(
                              featured.excerpt,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.mediumGray,
                                height: 1.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: AppColors.primarySurface,
                                backgroundImage: featured.authorImageUrl.isNotEmpty
                                    ? NetworkImage(featured.authorImageUrl)
                                    : null,
                                child: featured.authorImageUrl.isEmpty
                                    ? Text(featured.author[0].toUpperCase(),
                                        style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary))
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(featured.author,
                                      style: AppTextStyles.bodySmall.copyWith(
                                          fontWeight: FontWeight.w600, fontSize: 13)),
                                  Text(_formatDate(featured.publishedDate),
                                      style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.mediumGray, fontSize: 11)),
                                ],
                              ),
                              const Spacer(),
                              Icon(Icons.arrow_forward, color: catColor, size: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlogGrid(List<BlogModel> blogs, bool isMobile) {
    return MaxWidthBox(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = isMobile ? 1 : (constraints.maxWidth > 900 ? 3 : 2);
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: isMobile ? 0.82 : 0.78,
            ),
            itemCount: blogs.length,
            itemBuilder: (_, i) => BlogCard(
              blog: blogs[i],
              onTap: () => _showComingSoon(blogs[i].title),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(bool isMobile) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderSkeleton(isMobile),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40, vertical: 32),
            child: MaxWidthBox(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = isMobile ? 1 : (constraints.maxWidth > 900 ? 3 : 2);
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: 6,
                    itemBuilder: (_, _) => _BlogCardSkeleton(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSkeleton(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 32 : 56,
      ),
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: MaxWidthBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SkeletonBox(width: 280, height: 36, isMobile: isMobile),
            const SizedBox(height: 16),
            _SkeletonBox(width: isMobile ? double.infinity : 400, height: 16, isMobile: isMobile),
            const SizedBox(height: 32),
            _SkeletonBox(width: isMobile ? double.infinity : 300, height: 44, isMobile: isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40, vertical: 64),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(Icons.article_outlined, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              _selectedCategory != null || _searchController.text.isNotEmpty
                  ? 'কোনো ব্লগ পাওয়া যায়নি'
                  : 'কোনো ব্লগ নেই',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _selectedCategory != null || _searchController.text.isNotEmpty
                  ? 'অনুগ্রহ করে ভিন্ন ক্যাটাগরি বা সার্চ টার্ম ব্যবহার করুন'
                  : 'শীঘ্রই নতুন ব্লগ যোগ করা হবে',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
              textAlign: TextAlign.center,
            ),
            if (_selectedCategory != null || _searchController.text.isNotEmpty) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedCategory = null;
                    _searchController.clear();
                  });
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('ফিল্টার রিসেট করুন'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(Object error, bool isMobile) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(Icons.error_outline, size: 40, color: AppColors.error),
            ),
            const SizedBox(height: 16),
            Text('ব্লগ লোড করতে ত্রুটি হয়েছে', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(blogsProvider),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('পুনরায় চেষ্টা করুন'),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title - বিস্তারিত পৃষ্ঠা শীঘ্রই আসছে'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Color _categoryColor(String category) {
    const colors = {
      'পরীক্ষা প্রস্তুতি': Color(0xFF1B8E3D),
      'ইংরেজি': Color(0xFF3B82F6),
      'গণিত': Color(0xFF8B5CF6),
      'শিক্ষক নিয়োগ': Color(0xFFF59E0B),
      'ব্যাংক পরীক্ষা': Color(0xFFEF4444),
      'শিক্ষা পদ্ধতি': Color(0xFF06B6D4),
    };
    return colors[category] ?? AppColors.primary;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'আজ';
    if (diff.inDays == 1) return 'গতকাল';
    if (diff.inDays < 7) return '${diff.inDays} দিন আগে';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} সপ্তাহ আগে';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()} মাস আগে';
    return '${(diff.inDays / 365).floor()} বছর আগে';
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }
}

// --- Sub-widgets ---

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? AppColors.primary : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaRow(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// --- Skeleton ---

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final bool isMobile;
  const _SkeletonBox({required this.width, required this.height, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isMobile ? double.infinity : width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _BlogCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: 80, decoration: BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 10),
                Container(height: 16, width: double.infinity, decoration: BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 6),
                Container(height: 16, width: 200, decoration: BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 12),
                Container(height: 12, width: 150, decoration: BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(width: 32, height: 32, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.lightGray)),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 10, width: 80, decoration: BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.circular(4))),
                        const SizedBox(height: 4),
                        Container(height: 10, width: 100, decoration: BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.circular(4))),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Dot Pattern ---

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5;
    const spacing = 25.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
