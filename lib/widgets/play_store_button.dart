import 'package:flutter/material.dart';
import '../app/theme.dart';

class PlayStoreButton extends StatelessWidget {
  const PlayStoreButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'GET IT ON',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white70, fontSize: 10),
              ),
              Text(
                'Google Play',
                style: AppTextStyles.labelLarge.copyWith(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
