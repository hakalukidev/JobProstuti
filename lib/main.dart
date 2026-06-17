import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

import 'app/app.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    try {
      await Firebase.initializeApp();
    } catch (e) {
      debugPrint('Firebase init error: $e');
    }

    // Initialize Hive
    try {
      await Hive.initFlutter();
      await Hive.openBox('questions_cache');
      await Hive.openBox('exams_cache');
      await Hive.openBox('user_cache');
    } catch (e) {
      debugPrint('Hive init error: $e');
    }

    // Initialize SharedPreferences
    SharedPreferences? prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('Prefs init error: $e');
    }

    // ✅ NotificationService এর initialization comment করে দাও:
    /*
    try {
      if (!kIsWeb) {
        await NotificationService.initialize();
      }
    } catch (e) {
      debugPrint('Notification init error: $e');
    }
    */

    if (!kIsWeb) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      );
    }

    runApp(
      ProviderScope(
        overrides: [
          if (prefs != null) sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const JobProstutiApp(),
      ),
    );
  } catch (e, stack) {
    debugPrint('Fatal error in main: $e');
    debugPrint(stack.toString());
    runApp(MaterialApp(home: Scaffold(body: Center(child: Text('Error: $e')))));
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});
