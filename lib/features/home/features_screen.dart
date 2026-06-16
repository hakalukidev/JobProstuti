import 'package:flutter/material.dart';

import '../../../widgets/common/custom_appbar.dart';
import 'widgets/features_section.dart';

class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: SingleChildScrollView(
        child: Column(children: const [FeaturesSection()]),
      ),
    );
  }
}
