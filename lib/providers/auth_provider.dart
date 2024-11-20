import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piton_books/providers/providers.dart' as providers;
import '../services/auth_service.dart';
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref),
);

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref; 

  AuthNotifier(this._ref) : super(AuthState());

  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final authService = _ref.read(authServiceProvider);
      await authService.login(email, password);
      state = state.copyWith(isLoading: false, isLoggedIn: true);
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      rethrow;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final authService = _ref.read(authServiceProvider);
      await authService.register(name, email, password);
      state = state.copyWith(isLoading: false);
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      rethrow;
    }
  }
Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      final authService = _ref.read(authServiceProvider);
      await authService.logout();
      state = state.copyWith(isLoading: false, isLoggedIn: false);
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      rethrow;
    }
  }
}





class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final String? errorMessage;

  AuthState({
    this.isLoading = false,
    this.isLoggedIn = false,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
