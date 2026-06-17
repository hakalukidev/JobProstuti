import 'package:flutter/material.dart';
import '../app/theme.dart';

class FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const FaqItem({super.key, required this.question, required this.answer});

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _isExpanded ? AppColors.primary.withOpacity(0.3) : AppColors.lightGray),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            title: Text(
              widget.question,
              style: AppTextStyles.headlineSmall.copyWith(fontSize: 15),
            ),
            trailing: Icon(
              _isExpanded ? Icons.remove : Icons.add,
              color: _isExpanded ? AppColors.primary : AppColors.mediumGray,
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                widget.answer,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray, height: 1.6),
              ),
            ),
        ],
      ),
    );
  }
}
