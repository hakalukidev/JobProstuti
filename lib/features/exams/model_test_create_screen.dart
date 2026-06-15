import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../repositories/exam_repository.dart';
import '../../widgets/common/custom_button.dart';

class ModelTestCreateScreen extends ConsumerStatefulWidget {
  const ModelTestCreateScreen({super.key});

  @override
  ConsumerState<ModelTestCreateScreen> createState() => _ModelTestCreateScreenState();
}

class _ModelTestCreateScreenState extends ConsumerState<ModelTestCreateScreen> {
  final _subjects = [
    'বাংলা', 'ইংরেজি', 'গণিত', 'সাধারণ জ্ঞান', 'বাংলাদেশ বিষয়াবলি',
    'আন্তর্জাতিক বিষয়াবলি', 'বিজ্ঞান ও প্রযুক্তি', 'মানসিক দক্ষতা', 'কম্পিউটার',
  ];

  final Set<String> _selectedSubjects = {};
  int _questionCount = 50;
  int _timeLimit = 45;
  double _negativeMarks = 0.25;
  bool _isLoading = false;

  Future<void> _createTest() async {
    if (_selectedSubjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('অন্তত একটি বিষয় বেছে নিন'), backgroundColor: AppColors.error),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final exam = await ref.read(examRepositoryProvider).createModelTest(
        subjectIds: _selectedSubjects.toList(),
        questionCount: _questionCount,
        timeLimitMinutes: _timeLimit,
        marksPerQuestion: 1,
        negativeMarks: _negativeMarks,
      );
      if (mounted) context.go('/exams/${exam.id}');
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
    return Scaffold(
      appBar: AppBar(title: const Text('মডেল টেস্ট তৈরি করুন')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject selection
            Text('বিষয় বেছে নিন', style: AppTextStyles.headlineLarge),
            const SizedBox(height: 6),
            Text('এক বা একাধিক বিষয় থেকে প্রশ্ন নির্বাচন করুন', style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray)),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _subjects.map((sub) {
                final selected = _selectedSubjects.contains(sub);
                return FilterChip(
                  label: Text(sub),
                  selected: selected,
                  onSelected: (_) => setState(() {
                    if (selected) _selectedSubjects.remove(sub);
                    else _selectedSubjects.add(sub);
                  }),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: selected ? Colors.white : AppColors.darkGray),
                  backgroundColor: AppColors.background,
                  side: BorderSide(color: selected ? AppColors.primary : AppColors.lightGray),
                  showCheckmark: false,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),
            const Divider(),
            const SizedBox(height: 20),

            // Question count
            _SliderSetting(
              label: 'প্রশ্নের সংখ্যা',
              value: _questionCount.toDouble(),
              min: 10,
              max: 200,
              divisions: 19,
              display: '$_questionCount টি প্রশ্ন',
              onChanged: (v) => setState(() => _questionCount = v.toInt()),
            ),

            const SizedBox(height: 24),

            // Time limit
            _SliderSetting(
              label: 'সময়সীমা',
              value: _timeLimit.toDouble(),
              min: 10,
              max: 180,
              divisions: 17,
              display: '$_timeLimit মিনিট',
              onChanged: (v) => setState(() => _timeLimit = v.toInt()),
            ),

            const SizedBox(height: 24),

            // Negative marks
            Text('নেগেটিভ মার্কস', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 10),
            Row(
              children: [0.0, 0.25, 0.50].map((val) {
                final selected = _negativeMarks == val;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => _negativeMarks = val),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: selected ? AppColors.primary : AppColors.lightGray,
                          ),
                        ),
                        child: Text(
                          val == 0 ? 'নেই' : '-$val',
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: selected ? Colors.white : AppColors.darkGray,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 36),

            // Summary card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('পরীক্ষার সারসংক্ষেপ', style: AppTextStyles.headlineSmall.copyWith(color: AppColors.primary)),
                  const SizedBox(height: 10),
                  _SummaryRow('বিষয়', _selectedSubjects.isEmpty ? 'কোনোটি নয়' : _selectedSubjects.join(', ')),
                  _SummaryRow('প্রশ্ন', '$_questionCount টি'),
                  _SummaryRow('সময়', '$_timeLimit মিনিট'),
                  _SummaryRow('মোট নম্বর', '$_questionCount'),
                  _SummaryRow('নেগেটিভ', _negativeMarks == 0 ? 'নেই' : '-$_negativeMarks প্রতি ভুলে'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            GradientButton(
              label: 'মডেল টেস্ট শুরু করুন →',
              width: double.infinity,
              onPressed: _createTest,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SliderSetting extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String display;
  final ValueChanged<double> onChanged;

  const _SliderSetting({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.display,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.headlineSmall),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(display, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            thumbColor: AppColors.primary,
            inactiveTrackColor: AppColors.lightGray,
            overlayColor: AppColors.primary.withOpacity(0.1),
          ),
          child: Slider(value: value, min: min, max: max, divisions: divisions, onChanged: onChanged),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${min.toInt()}', style: AppTextStyles.bodySmall),
            Text('${max.toInt()}', style: AppTextStyles.bodySmall),
          ],
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray)),
          ),
          const Text(': '),
          Expanded(child: Text(value, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}