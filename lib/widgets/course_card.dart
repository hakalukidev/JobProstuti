import 'package:flutter/material.dart';
import '../models/course_model.dart';
import 'course/course_card.dart' as modern;

/// Legacy-compatible `CourseCard` wrapper.
/// Accepts older named parameters and forwards to the modern `CourseCard`.
class CourseCard extends StatelessWidget {
  final String? imagePath;
  final String? title;
  final String? description;
  final String? badge;
  final String? bannerTopText;
  final String? bannerTitle;
  final String? bannerSubtitle;
  final String? bannerBadge;
  final CourseModel? course;
  final bool isCompact;

  const CourseCard({
    Key? key,
    this.imagePath,
    this.title,
    this.description,
    this.badge,
    this.bannerTopText,
    this.bannerTitle,
    this.bannerSubtitle,
    this.bannerBadge,
    this.course,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CourseModel model =
        course ??
        CourseModel(
          id: bannerTitle ?? title ?? UniqueKey().toString(),
          title: title ?? '',
          shortDescription: description ?? '',
          imageUrl: imagePath ?? '',
          category: badge ?? '',
          price: 0,
          createdAt: DateTime.now(),
        );

    return modern.CourseCard(course: model, isCompact: isCompact);
  }
}
