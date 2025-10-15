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

  // You can create getters to derive data from the state.
  // This is cleaner than storing lots of booleans.
  bool get containsUpperCase => password.contains(RegExp(r'[A-Z]'));
  bool get containsLowerCase => password.contains(RegExp(r'[a-z]'));
  bool get containsNumber => password.contains(RegExp(r'[0-9]'));
  // Assuming you have this regex defined somewhere
  bool get containsSpecialChar => password.contains(specialCharRexExp);
  bool get contains8Length => password.length >= 8;

  // A getter to determine if the form is valid and the button should be enabled.
  bool get isFormValid =>
      email.isNotEmpty &&
      name.isNotEmpty &&
      containsUpperCase &&
      containsLowerCase &&
      containsNumber &&
      containsSpecialChar &&
      contains8Length;

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

// NOTE: Your old states like SignUpInitial, SignUpProcess, etc., are no longer needed.
// The `SubmissionStatus` enum handles this now. You can delete them.
