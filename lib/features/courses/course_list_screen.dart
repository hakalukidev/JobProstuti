import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';

import '../../app/theme.dart';
import '../../repositories/course_repository.dart';
import '../../widgets/common/custom_appbar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/responsive_layout.dart';
import '../../widgets/course/course_card.dart';

final _categoryProvider = StateProvider<String?>((ref) => null);
final _searchProvider = StateProvider<String>((ref) => '');

class CourseListScreen extends ConsumerWidget {
  const CourseListScreen({super.key});

  static const _categories = [
    'সব',
    'বিসিএস',
    'ব্যাংক',
    'প্রাইমারি',
    'NTRCA',
    'সহকারী জজ',
    'অন্যান্য',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(_categoryProvider);
    final search = ref.watch(_searchProvider);
    final isMobile = ResponsiveLayout.isMobile(context);

    final coursesAsync = ref.watch(
      coursesProvider({
        'page': 1,
        'category': category,
        'search': search.isEmpty ? null : search,
      }),
    );

    return Scaffold(
      appBar: const AppBarWidget(title: 'কোর্সসমূহ'),
      body: Column(
        children: [
          // Search & filter bar
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              children: [
                // Search box
                TextField(
                  onChanged: (v) =>
                      ref.read(_searchProvider.notifier).state = v,
                  decoration: InputDecoration(
                    hintText: 'কোর্স খুঁজুন...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: search.isNotEmpty
                        ? IconButton(
                            onPressed: () =>
                                ref.read(_searchProvider.notifier).state = '',
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Category chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((cat) {
                      final isSelected = cat == 'সব'
                          ? category == null
                          : category == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (_) {
                            ref.read(_categoryProvider.notifier).state =
                                cat == 'সব' ? null : cat;
                          },
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.darkGray,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          backgroundColor: AppColors.background,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.lightGray,
                          ),
                          showCheckmark: false,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          const Divider(height: 1),

          // Course grid
          Expanded(
            child: coursesAsync.when(
              data: (courses) {
                if (courses.isEmpty) {
                  return const EmptyStateWidget(
                    title: 'কোনো কোর্স পাওয়া যায়নি',
                    subtitle: 'অন্য ক্যাটাগরি বা কীওয়ার্ড দিয়ে খুঁজুন',
                    icon: Icons.search_off,
                  );
                }
                return GridView.builder(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile
                        ? 1
                        : (ResponsiveLayout.isDesktop(context) ? 3 : 2),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: isMobile ? 2.2 : 0.78,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (_, i) => isMobile
                      ? CourseCard(course: courses[i], isCompact: true)
                      : CourseCard(course: courses[i]),
                );
              },
              loading: () => GridView.count(
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                crossAxisCount: isMobile ? 1 : 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isMobile ? 2.2 : 0.78,
                children: List.generate(6, (_) => const CourseCardSkeleton()),
              ),
              error: (e, _) => AppErrorWidget(
                message: e.toString(),
                onRetry: () => ref.invalidate(coursesProvider({'page': 1})),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
