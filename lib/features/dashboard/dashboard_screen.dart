import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../core/providers/auth_provider.dart';
import '../../repositories/user_repository.dart';
import '../../widgets/common/custom_appbar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/responsive_layout.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).value;
    final dashboardAsync = ref.watch(userDashboardProvider);
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      appBar: AppBarWidget(title: isMobile ? 'ড্যাশবোর্ড' : null),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(userDashboardProvider),
        child: dashboardAsync.when(
          data: (data) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: MaxWidthBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'স্বাগতম, ${user?.name.split(' ').first ?? 'শিক্ষার্থী'}! 👋',
                                style: AppTextStyles.headlineLarge.copyWith(color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'আজকের প্রস্তুতি শুরু করুন',
                                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white24,
                          backgroundImage: user?.avatarUrl != null ? NetworkImage(user!.avatarUrl!) : null,
                          child: user?.avatarUrl == null
                              ? Text(
                            user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'U',
                            style: AppTextStyles.headlineLarge.copyWith(color: Colors.white),
                          )
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quick stats
                  GridView.count(
                    crossAxisCount: isMobile ? 2 : 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      _QuickStat(
                        icon: Icons.quiz_outlined,
                        label: 'পরীক্ষা দিয়েছেন',
                        value: '${(data['total_exams'] as num?)?.toInt() ?? 0}',
                        color: AppColors.primary,
                      ),
                      _QuickStat(
                        icon: Icons.star_outlined,
                        label: 'গড় নম্বর',
                        value: '${(data['average_score'] as num?)?.toStringAsFixed(1) ?? '0'}%',
                        color: AppColors.warning,
                      ),
                      _QuickStat(
                        icon: Icons.menu_book_outlined,
                        label: 'এনরোল কোর্স',
                        value: '${(data['enrolled_courses'] as num?)?.toInt() ?? 0}',
                        color: AppColors.info,
                      ),
                      _QuickStat(
                        icon: Icons.bookmark_outlined,
                        label: 'বুকমার্ক',
                        value: '${(data['bookmark_count'] as num?)?.toInt() ?? 0}',
                        color: AppColors.accent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Performance chart
                  if ((data['score_history'] as List?)?.isNotEmpty == true) ...[
                    Text('পারফরম্যান্স', style: AppTextStyles.headlineLarge),
                    const SizedBox(height: 14),
                    Container(
                      height: 200,
                      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: AppColors.lightGray),
                      ),
                      child: _PerformanceChart(history: data['score_history'] as List),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Quick actions
                  Text('দ্রুত অ্যাক্সেস', style: AppTextStyles.headlineLarge),
                  const SizedBox(height: 14),
                  GridView.count(
                    crossAxisCount: isMobile ? 2 : 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      _QuickAction(icon: Icons.quiz, label: 'মডেল টেস্ট', route: AppRoutes.modelTest, color: AppColors.primary),
                      _QuickAction(icon: Icons.live_tv, label: 'লাইভ পরীক্ষা', route: AppRoutes.liveExams, color: AppColors.error),
                      _QuickAction(icon: Icons.book, label: 'প্রশ্নব্যাংক', route: AppRoutes.questionBank, color: AppColors.info),
                      _QuickAction(icon: Icons.history, label: 'পরীক্ষার ইতিহাস', route: AppRoutes.examHistory, color: AppColors.warning),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Recent exams
                  if ((data['recent_exams'] as List?)?.isNotEmpty == true) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('সাম্প্রতিক পরীক্ষা', style: AppTextStyles.headlineLarge),
                        TextButton(
                          onPressed: () => context.go(AppRoutes.examHistory),
                          child: const Text('সব দেখুন →'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...(data['recent_exams'] as List).take(3).map((e) => _RecentExamTile(exam: e as Map<String, dynamic>)),
                  ],
                ],
              ),
            ),
          ),
          loading: () => const LoadingWidget(fullScreen: true, message: 'ড্যাশবোর্ড লোড হচ্ছে...'),
          error: (e, _) => AppErrorWidget(
            message: e.toString(),
            fullScreen: true,
            onRetry: () => ref.invalidate(userDashboardProvider),
          ),
        ),
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _QuickStat({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTextStyles.headlineLarge.copyWith(color: color, fontSize: 20)),
              Text(label, style: AppTextStyles.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final Color color;

  const _QuickAction({required this.icon, required this.label, required this.route, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(color: color, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PerformanceChart extends StatelessWidget {
  final List history;
  const _PerformanceChart({required this.history});

  @override
  Widget build(BuildContext context) {
    final spots = history.asMap().entries.map((e) {
      final score = (e.value['score'] as num?)?.toDouble() ?? 0;
      return FlSpot(e.key.toDouble(), score);
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (_) => FlLine(color: AppColors.lightGray, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              getTitlesWidget: (v, _) => Text('${v.toInt()}%', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
              reservedSize: 36,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i >= 0 && i < history.length) {
                  return Text('${i + 1}', style: AppTextStyles.bodySmall.copyWith(fontSize: 10));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                radius: 4,
                color: AppColors.primary,
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [AppColors.primary.withOpacity(0.2), AppColors.primary.withOpacity(0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentExamTile extends StatelessWidget {
  final Map<String, dynamic> exam;
  const _RecentExamTile({required this.exam});

  @override
  Widget build(BuildContext context) {
    final score = (exam['score'] as num?)?.toDouble() ?? 0;
    final color = score >= 70 ? AppColors.success : (score >= 50 ? AppColors.warning : AppColors.error);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Center(
              child: Text(
                '${score.toInt()}%',
                style: AppTextStyles.bodySmall.copyWith(color: color, fontWeight: FontWeight.w700, fontSize: 11),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exam['title']?.toString() ?? '', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(exam['date']?.toString() ?? '', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.mediumGray),
        ],
      ),
    );
  }
}