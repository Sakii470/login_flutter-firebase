import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final UserRepository _userRepository;

  SignInCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SignInInitial());

  /// Triggers the sign-in process with email and password.
  Future<void> signInWithCredentials({required String email, required String password}) async {
    // Emit a loading/process state immediately so the UI can react.
    emit(SignInProcess());
    try {
      await _userRepository.signIn(email, password);
      // On success, emit the success state.
      emit(SignInSuccess());
    } catch (e) {
      log(e.toString());
      emit(const SignInFailure());
    }
  }

  /// Triggers the sign-out process.
  Future<void> signOut() async {
    // Note: This method doesn't emit a state. The AuthenticationCubit/Bloc
    // should be listening to the user stream and will react to the logout.
    await _userRepository.logOut();
  }
}
