// lib/bloc/login/login_event.dart
import 'package:equatable/equatable.dart';

/// Abstract base class for all login-related events.
abstract class LoginEvent extends Equatable {
  /// Creates a [LoginEvent].
  const LoginEvent();

  @override
  List<Object> get props => [];
}

/// Event triggered when the email input changes.
class LoginEmailChanged extends LoginEvent {
  /// The new email value.
  final String email;

  /// Creates a [LoginEmailChanged] event.
  const LoginEmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

/// Event triggered when the password input changes.
class LoginPasswordChanged extends LoginEvent {
  /// The new password value.
  final String password;

  /// Creates a [LoginPasswordChanged] event.
  const LoginPasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}

/// Event triggered when the login form is submitted.
class LoginSubmitted extends LoginEvent {}