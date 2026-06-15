import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

import 'api_service.dart';
import '../../models/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(apiServiceProvider));
});

class AuthResult {
  final UserModel user;
  final String token;
  final String refreshToken;

  const AuthResult({
    required this.user,
    required this.token,
    required this.refreshToken,
  });
}

class AuthService {
  final ApiService _api;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final Logger _logger = Logger();

  AuthService(this._api);

  // Login with email/password
  Future<AuthResult> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final data = await _api.login(email: email, password: password);
    final result = _parseAuthResult(data);
    await _api.saveTokens(
      token: result.token,
      refreshToken: result.refreshToken,
    );
    return result;
  }

  // Register with email/password
  Future<AuthResult> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final data = await _api.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
    final result = _parseAuthResult(data);
    await _api.saveTokens(
      token: result.token,
      refreshToken: result.refreshToken,
    );
    return result;
  }

  // Google Sign-In
  Future<AuthResult> loginWithGoogle() async {
    final googleUser = await (_googleSignIn as dynamic).signIn();
    if (googleUser == null)
      throw const ApiException(message: 'Google সাইন-ইন বাতিল হয়েছে।');

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _firebaseAuth.signInWithCredential(credential);
    final idToken = await _firebaseAuth.currentUser?.getIdToken();
    if (idToken == null)
      throw const ApiException(message: 'Google token পাওয়া যায়নি।');

    final data = await _api.loginWithGoogle(idToken: idToken);
    final result = _parseAuthResult(data);
    await _api.saveTokens(
      token: result.token,
      refreshToken: result.refreshToken,
    );
    return result;
  }

  // Logout
  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      _logger.w('Firebase logout error: $e');
    }
    await _api.logout();
  }

  // Forgot password
  Future<void> forgotPassword(String email) async {
    await _api.forgotPassword(email);
  }

  // Check if user is logged in
  Future<UserModel?> getCurrentUser() async {
    final token = await _api.getToken();
    if (token == null) return null;

    try {
      final data = await _api.getUserProfile();
      return UserModel.fromJson(data['data'] as Map<String, dynamic>);
    } catch (e) {
      _logger.e('Get current user error: $e');
      return null;
    }
  }

  AuthResult _parseAuthResult(Map<String, dynamic> data) {
    final result = data['data'] as Map<String, dynamic>? ?? data;
    return AuthResult(
      user: UserModel.fromJson(result['user'] as Map<String, dynamic>),
      token: result['access_token'] as String,
      refreshToken: result['refresh_token'] as String,
    );
  }
}
