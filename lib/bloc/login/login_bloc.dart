// lib/bloc/login/login_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:findoc_app/utils/validators.dart'; // Adjust path if needed
import 'login_event.dart';
import 'login_state.dart';

/// Business Logic Component for handling login operations.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  /// Creates a [LoginBloc] instance.
  LoginBloc() : super(LoginState.initial()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  /// Handles the [LoginEmailChanged] event.
  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final String email = event.email;
    final bool isValidEmail = Validators.isValidEmail(email);
    emit(state.copyWith(
      email: email,
      isValid: isValidEmail && Validators.isValidPassword(state.password),
      errorMessage:
          isValidEmail ? '' : 'Invalid email format (e.g., user@example.com)',
    ));
  }

  /// Handles the [LoginPasswordChanged] event.
  void _onPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    final String password = event.password;
    final bool isValidPassword = Validators.isValidPassword(password);
    emit(state.copyWith(
      password: password,
      isValid: Validators.isValidEmail(state.email) && isValidPassword,
      errorMessage: isValidPassword
          ? ''
          : 'Min 8 chars: uppercase, lowercase, number, symbol (!@#\$%^&* etc.)',
    ));
  }

  /// Handles the [LoginSubmitted] event.
  Future<void> _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    // If the form is not valid, do nothing.
    if (!state.isValid) return;

    // Indicate that submission is starting.
    emit(state.copyWith(isSubmitting: true));

    // Simulate network delay (e.g., API call).
    await Future.delayed(const Duration(seconds: 1));

    // Simulate login success/failure.
    // In a real app, you'd call an API here and check the response.
    // For this assignment, let's assume valid input leads to success.
    if (state.email.isNotEmpty && state.password.isNotEmpty) {
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } else {
      emit(state.copyWith(
          isSubmitting: false, isFailure: true, errorMessage: 'Login failed'));
    }
  }
}