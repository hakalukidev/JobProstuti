import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'routes.dart';
import 'theme.dart';

class JobProstutiApp extends ConsumerWidget {
  const JobProstutiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Job Prostuti | জব প্রস্তুতি',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('bn', 'BD'), Locale('en', 'US')],
      locale: const Locale('bn', 'BD'),
      builder: (context, child) {
        // Ensure text scale factor doesn't break layout
        final mediaQuery = MediaQuery.of(context);
        final clamped = mediaQuery.textScaleFactor.clamp(0.8, 1.2).toDouble();
        return MediaQuery(
          data: mediaQuery.copyWith(textScaleFactor: clamped),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
