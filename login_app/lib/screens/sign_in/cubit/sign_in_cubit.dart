import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_in_state.dart';

// Assuming these are defined in your components/strings.dart or similar
final RegExp emailRexExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
final RegExp passwordRexExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

class SignInCubit extends Cubit<SignInState> {
  final UserRepository _userRepository;

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
    return emailRexExp.hasMatch(email) && passwordRexExp.hasMatch(password);
  }

  /// Triggers the sign-in process with email and password from the state.
  Future<void> signInWithCredentials() async {
    // Only proceed if the form is valid.
    if (!state.isValid) return;

    // Emit a loading state
    emit(state.copyWith(status: SignInStatus.loading, errorMessage: null));
    try {
      await _userRepository.signIn(state.email, state.password);
      // On success, emit the success state.
      emit(state.copyWith(status: SignInStatus.success));
    } catch (e) {
      log(e.toString());
      // On failure, emit failure state with a message.
      emit(state.copyWith(
        status: SignInStatus.failure,
        errorMessage: 'Invalid email or password. Please try again.',
      ));
    }
  }

  /// Triggers the sign-out process.
  Future<void> signOut() async {
    // Note: This method doesn't emit a state. The AuthenticationCubit/Bloc
    // should be listening to the user stream and will react to the logout.
    await _userRepository.logOut();
  }
}
