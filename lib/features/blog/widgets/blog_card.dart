import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/blog_model.dart';
import '../../../app/theme.dart';

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

class BlogCard extends StatefulWidget {
  final BlogModel blog;
  final VoidCallback? onTap;

  const BlogCard({super.key, required this.blog, this.onTap});

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  bool _isHovering = false;

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

  @override
  Widget build(BuildContext context) {
    final catColor = _categoryColor(widget.blog.category);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        offset: _isHovering ? const Offset(0, -0.01) : Offset.zero,
        child: Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          elevation: _isHovering ? 12 : 2,
          shadowColor: AppColors.black.withValues(alpha: _isHovering ? 0.15 : 0.08),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildImage(catColor),
                _buildContent(catColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(Color catColor) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Stack(
        children: [
          AnimatedScale(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            scale: _isHovering ? 1.05 : 1.0,
            child: CachedNetworkImage(
              imageUrl: widget.blog.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(
                height: 200,
                color: AppColors.lightGray,
                child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              errorWidget: (_, _, _) => Container(
                height: 200,
                color: AppColors.lightGray,
                child: const Icon(Icons.image_not_supported, size: 40, color: AppColors.mediumGray),
              ),
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ),
          // Category badge
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: catColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: catColor.withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                widget.blog.category,
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ),
          ),
          // Date
          Positioned(
            bottom: 10,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_today, size: 10, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(widget.blog.publishedDate),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Color catColor) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            widget.blog.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          // Excerpt
          Text(
            widget.blog.excerpt,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.mediumGray,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          // Tags
          if (widget.blog.tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: widget.blog.tags.take(3).map((tag) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tag,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )).toList(),
              ),
            ),
          // Author + Meta
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primarySurface,
                backgroundImage: widget.blog.authorImageUrl.isNotEmpty
                    ? NetworkImage(widget.blog.authorImageUrl)
                    : null,
                child: widget.blog.authorImageUrl.isEmpty
                    ? Text(
                        widget.blog.author.isNotEmpty
                            ? widget.blog.author[0].toUpperCase()
                            : 'A',
                        style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.blog.author,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        _MetaIcon(Icons.visibility_outlined, _formatCount(widget.blog.viewCount)),
                        const SizedBox(width: 12),
                        _MetaIcon(Icons.schedule_outlined, '${widget.blog.readingTimeMinutes} মিনিট'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Read more
          Align(
            alignment: Alignment.centerRight,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.only(right: _isHovering ? 0 : 4),
              child: Text(
                'বিস্তারিত পড়ুন →',
                style: AppTextStyles.bodySmall.copyWith(
                  color: catColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }
}

class _MetaIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaIcon(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.mediumGray),
        const SizedBox(width: 3),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.mediumGray,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
