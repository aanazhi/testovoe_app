import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());

class AuthState {
  final bool isLoggedIn;
  final bool isLoading;

  AuthState({
    required this.isLoggedIn,
    required this.isLoading,
  });

  AuthState copyWith({bool? isLoggedIn, bool? isLoading}) {
    return AuthState(
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        isLoading: isLoading ?? this.isLoading);
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isLoggedIn: false, isLoading: false)) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    state = state.copyWith(isLoading: true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    state = state.copyWith(isLoggedIn: token != null, isLoading: false);
  }

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('token', 'dummy_token');
    state = state.copyWith(isLoggedIn: true, isLoading: false);
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    state = state.copyWith(isLoggedIn: false, isLoading: false);
  }
}
