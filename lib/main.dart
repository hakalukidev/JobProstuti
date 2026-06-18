import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/app.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      await dotenv.load(fileName: ".env");
      print('WEB_CLIENT_ID: ${dotenv.env['WEB_CLIENT_ID']}');
    } catch (e) {
      debugPrint('Dotenv initialization error: $e');
    }
    try {
  // 2. ✅ Pass your options object to make Web Authentication work flawlessly
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // 🔴 THE SILENT CRASH HAPPENS HERE
  );
} catch (e) {
  debugPrint('Firebase init error: $e'); // 📝 It catches the error and hides it from your UI!
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
