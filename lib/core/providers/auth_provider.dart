import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../services/auth_service.dart';
import '../../models/user_model.dart';

// Current user state
final authStateProvider = FutureProvider<UserModel?>((ref) async {
  final authService = ref.read(authServiceProvider);
  return authService.getCurrentUser();
});

// Current user - watched
final currentUserProvider = StateProvider<UserModel?>((ref) => null);

// Auth actions notifier
class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    final authService = ref.read(authServiceProvider);
    return authService.getCurrentUser();
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      final result = await authService.loginWithEmail(
        email: email,
        password: password,
      );
      ref.read(currentUserProvider.notifier).state = result.user;
      return result.user;
    });
  }

  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      final result = await authService.registerWithEmail(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      ref.read(currentUserProvider.notifier).state = result.user;
      return result.user;
    });
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      final result = await authService.loginWithGoogle();
      ref.read(currentUserProvider.notifier).state = result.user;
      return result.user;
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    final authService = ref.read(authServiceProvider);
    await authService.logout();
    ref.read(currentUserProvider.notifier).state = null;
    state = const AsyncData(null);
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(
  AuthNotifier.new,
);

// Convenience providers
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).value != null;
});

final userDisplayNameProvider = Provider<String>((ref) {
  final user = ref.watch(authNotifierProvider).value;
  return user?.name ?? 'অতিথি';
});