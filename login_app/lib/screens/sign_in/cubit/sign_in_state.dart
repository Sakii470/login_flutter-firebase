part of 'sign_in_cubit.dart';

// An enum to represent the various states of the sign-in form submission.
enum SignInStatus { initial, loading, success, failure }

class SignInState extends Equatable {
  const SignInState({
    this.status = SignInStatus.initial,
    this.email = '',
    this.password = '',
    this.isValid = false,
    this.errorMessage,
  });

  final SignInStatus status;
  final String email;
  final String password;
  final bool isValid;
  final String? errorMessage;

  /// Creates a copy of the current SignInState with updated values.
  SignInState copyWith({
    SignInStatus? status,
    String? email,
    String? password,
    bool? isValid,
    String? errorMessage,
  }) {
    return SignInState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, email, password, isValid, errorMessage];
}
