// lib/bloc/login/login_state.dart
import 'package:equatable/equatable.dart';

/// Represents the state of the login feature.
class LoginState extends Equatable {
  /// The current email input value.
  final String email;

  /// The current password input value.
  final String password;

  /// Indicates if the current email and password are considered valid.
  final bool isValid;

  /// Indicates if a login request is currently in progress.
  final bool isSubmitting;

  /// Indicates if the login was successful.
  final bool isSuccess;

  /// Indicates if the login failed.
  final bool isFailure;

  /// Contains an error message if validation or login fails.
  final String errorMessage;

  /// Creates a [LoginState].
  const LoginState({
    required this.email,
    required this.password,
    required this.isValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
    required this.errorMessage,
  });

  /// Factory constructor for the initial state.
  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      isValid: false,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      errorMessage: '',
    );
  }

  /// Creates a copy of this state but with the given fields replaced with the new values.
  LoginState copyWith({
    String? email,
    String? password,
    bool? isValid,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props =>
      [email, password, isValid, isSubmitting, isSuccess, isFailure, errorMessage];

  @override
  bool get stringify => true;
}