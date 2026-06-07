import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../core/storage/secure_storage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    try {
      final token = await SecureStorage.getToken();
      if (token != null) {
        // Attempt to fetch profile to verify token
        final user = await authService.getProfile();
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          await SecureStorage.deleteToken();
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authService.login(event.email, event.password);
      // Small delay so Flutter Web can complete text field unfocus/autofill
      // before we destroy the LoginScreen widget tree (avoids engine crash)
      await Future.delayed(const Duration(milliseconds: 200));
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authService.logout();
    emit(AuthUnauthenticated());
  }
}
