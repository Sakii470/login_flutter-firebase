part of 'sign_up_cubit.dart';

// An enum to represent the form submission status more clearly
enum SubmissionStatus { initial, inProgress, success, failure }

class SignUpState extends Equatable {
  const SignUpState({
    this.email = '',
    this.password = '',
    this.name = '',
    this.status = SubmissionStatus.initial,
  });

  final String email;
  final String password;
  final String name;
  final SubmissionStatus status;

  // A getter to determine if the form is valid and the button should be enabled.
  bool get isFormValid => email.isNotEmpty && name.isNotEmpty;

  // The copyWith method is crucial for creating new states immutably.
  SignUpState copyWith({
    String? email,
    String? password,
    String? name,
    SubmissionStatus? status,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [email, password, name, status];
}
