import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/auth_provider.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/auth/forgot_password_screen.dart';
import '../features/home/home_screen.dart';
import '../features/courses/course_list_screen.dart';
import '../features/courses/course_detail_screen.dart';
import '../features/courses/enrollment_screen.dart';
import '../features/exams/live_exams_screen.dart';
import '../features/exams/exam_detail_screen.dart';
import '../features/exams/exam_attempt_screen.dart';
import '../features/exams/exam_result_screen.dart';
import '../features/exams/model_test_create_screen.dart';
import '../features/exams/question_bank_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/dashboard/profile_screen.dart';
import '../features/dashboard/exam_history_screen.dart';
import '../features/dashboard/bookmarks_screen.dart';
import '../features/resources/resources_list_screen.dart';
import '../features/resources/pdf_viewer_screen.dart';
import '../features/pricing/pricing_screen.dart';

// Route names
class AppRoutes {
  static const home = '/';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const courses = '/courses';
  static const courseDetail = '/courses/:id';
  static const enrollment = '/courses/:id/enroll';
  static const liveExams = '/exams/live';
  static const examDetail = '/exams/:id';
  static const examAttempt = '/exams/:id/attempt';
  static const examResult = '/exams/:id/result';
  static const modelTest = '/model-test/create';
  static const questionBank = '/question-bank';
  static const dashboard = '/dashboard';
  static const profile = '/profile';
  static const examHistory = '/exam-history';
  static const bookmarks = '/bookmarks';
  static const resources = '/resources';
  static const pdfViewer = '/pdf-viewer';
  static const pricing = '/pricing';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isAuthenticated = authState.value != null;
      final isAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register ||
          state.matchedLocation == AppRoutes.forgotPassword;

      // Protected routes
      final protectedRoutes = [
        AppRoutes.dashboard,
        AppRoutes.profile,
        AppRoutes.examHistory,
        AppRoutes.bookmarks,
        AppRoutes.examAttempt,
      ];

      final isProtected = protectedRoutes.any(
            (r) => state.matchedLocation.startsWith(r.split(':').first),
      );

      if (isProtected && !isAuthenticated) {
        return '${AppRoutes.login}?redirect=${state.matchedLocation}';
      }

      if (isAuthenticated && isAuthRoute) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => _buildPage(
              state,
              const HomeScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.courses,
            pageBuilder: (context, state) => _buildPage(
              state,
              const CourseListScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.courseDetail,
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return _buildPage(state, CourseDetailScreen(courseId: id));
            },
          ),
          GoRoute(
            path: AppRoutes.liveExams,
            pageBuilder: (context, state) => _buildPage(
              state,
              const LiveExamsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.questionBank,
            pageBuilder: (context, state) => _buildPage(
              state,
              const QuestionBankScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.resources,
            pageBuilder: (context, state) => _buildPage(
              state,
              const ResourcesListScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.pricing,
            pageBuilder: (context, state) => _buildPage(
              state,
              const PricingScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.dashboard,
            pageBuilder: (context, state) => _buildPage(
              state,
              const DashboardScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) => _buildPage(
              state,
              const ProfileScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.examHistory,
            pageBuilder: (context, state) => _buildPage(
              state,
              const ExamHistoryScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.bookmarks,
            pageBuilder: (context, state) => _buildPage(
              state,
              const BookmarksScreen(),
            ),
          ),
        ],
      ),

      // Full-screen routes (no shell)
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => _buildPage(
          state,
          const LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (context, state) => _buildPage(
          state,
          const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        pageBuilder: (context, state) => _buildPage(
          state,
          const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.enrollment,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _buildPage(state, EnrollmentScreen(courseId: id));
        },
      ),
      GoRoute(
        path: AppRoutes.examDetail,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _buildPage(state, ExamDetailScreen(examId: id));
        },
      ),
      GoRoute(
        path: AppRoutes.examAttempt,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _buildPage(state, ExamAttemptScreen(examId: id));
        },
      ),
      GoRoute(
        path: AppRoutes.examResult,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          final extra = state.extra as Map<String, dynamic>?;
          return _buildPage(state, ExamResultScreen(examId: id, resultData: extra));
        },
      ),
      GoRoute(
        path: AppRoutes.modelTest,
        pageBuilder: (context, state) => _buildPage(
          state,
          const ModelTestCreateScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.pdfViewer,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return _buildPage(
            state,
            PdfViewerScreen(
              url: extra['url'] as String,
              title: extra['title'] as String,
            ),
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'পেজটি পাওয়া যায়নি',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('হোমে ফিরে যান'),
            ),
          ],
        ),
      ),
    ),
  );
});

CustomTransitionPage<void> _buildPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
  );
}

// Main shell with bottom navigation on mobile
class MainShell extends ConsumerStatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _selectedIndex = 0;

  static const _routes = [
    AppRoutes.home,
    AppRoutes.courses,
    AppRoutes.liveExams,
    AppRoutes.dashboard,
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (!isMobile) {
      return widget.child;
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          context.go(_routes[index]);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'হোম',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'কোর্স',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_outlined),
            activeIcon: Icon(Icons.quiz),
            label: 'পরীক্ষা',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'প্রোফাইল',
          ),
        ],
      ),
    );
  }
}