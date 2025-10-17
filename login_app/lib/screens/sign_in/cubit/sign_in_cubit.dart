import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  // The dependency is declared here.
  final UserRepository _userRepository;

  // The dependency is "injected" via the constructor.
  SignInCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const SignInState());

  /// Called when the email input field changes.
  void emailChanged(String value) {
    final isValid = _validateForm(email: value, password: state.password);
    emit(state.copyWith(email: value, isValid: isValid, status: SignInStatus.initial, errorMessage: null));
  }

  /// Called when the password input field changes.
  void passwordChanged(String value) {
    final isValid = _validateForm(email: state.email, password: value);
    emit(state.copyWith(password: value, isValid: isValid, status: SignInStatus.initial, errorMessage: null));
  }

  /// Validates the form based on the current email and password.
  bool _validateForm({required String email, required String password}) {
    return email.isNotEmpty && password.isNotEmpty;
  }

  /// Triggers the sign-in process with email and password from the state.
  Future<void> signInWithCredentials() async {
    if (!state.isValid) return;

    emit(state.copyWith(status: SignInStatus.loading, errorMessage: null));
    try {
      await _userRepository.signIn(state.email, state.password);
      emit(state.copyWith(status: SignInStatus.success));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(
        status: SignInStatus.failure,
        errorMessage: 'Invalid email or password. Please try again.',
      ));
    }
  }
}
