import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Auth State Model
class AuthState {
  final bool isLoggedIn;
  final bool isOnboarded;
  final String? userId;
  final String? userName;
  final String? userEmail;

  const AuthState({
    this.isLoggedIn = false,
    this.isOnboarded = false,
    this.userId,
    this.userName,
    this.userEmail,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    bool? isOnboarded,
    String? userId,
    String? userName,
    String? userEmail,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
    );
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _loadAuthState();
  }

  // Load saved auth state from SharedPreferences
  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final isOnboarded = prefs.getBool('isOnboarded') ?? false;
    final userId = prefs.getString('userId');
    final userName = prefs.getString('userName');
    final userEmail = prefs.getString('userEmail');

    state = AuthState(
      isLoggedIn: isLoggedIn,
      isOnboarded: isOnboarded,
      userId: userId,
      userName: userName,
      userEmail: userEmail,
    );
  }

  // Login
  Future<bool> login(String email, String password) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Basic validation
      if (email.isEmpty || password.isEmpty) return false;
      if (password.length < 6) return false;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', 'user_001');
      await prefs.setString('userName', email.split('@')[0]);
      await prefs.setString('userEmail', email);

      state = state.copyWith(
        isLoggedIn: true,
        userId: 'user_001',
        userName: email.split('@')[0],
        userEmail: email,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // Register
  Future<bool> register(String name, String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (name.isEmpty || email.isEmpty || password.isEmpty) return false;
      if (password.length < 6) return false;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', 'user_001');
      await prefs.setString('userName', name);
      await prefs.setString('userEmail', email);

      state = state.copyWith(
        isLoggedIn: true,
        userId: 'user_001',
        userName: name,
        userEmail: email,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // Complete Onboarding
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboarded', true);
    state = state.copyWith(isOnboarded: true);
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userEmail');

    state = const AuthState(isOnboarded: true);
  }
}

// Providers
final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
