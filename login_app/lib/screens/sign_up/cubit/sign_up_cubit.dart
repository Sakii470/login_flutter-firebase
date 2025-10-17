import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_app/components/strings.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final UserRepository _userRepository;

  SignUpCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const SignUpState());

  // Method to be called when the email text field changes.
  void emailChanged(String value) {
    emit(state.copyWith(email: value));
  }

  // Method to be called when the password text field changes.
  void passwordChanged(String value) {
    emit(state.copyWith(password: value));
  }

  // Method to be called when the name text field changes.
  void nameChanged(String value) {
    emit(state.copyWith(name: value));
  }

  Future<void> signUp() async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: SubmissionStatus.inProgress));
    try {
      MyUser myUser = MyUser.empty.copyWith(
        email: state.email,
        name: state.name,
      );

      // STEP 1: Call the sign-up method and CAPTURE the result.
      // Your repository method should return the `User` object from Firebase.
      MyUser firebaseUser = await _userRepository.signUp(myUser, state.password);

      // STEP 2: Use the UID from the result to update your local user object.
      myUser = myUser.copyWith(
        id: firebaseUser.id,
      );

      // STEP 3: Now, save the COMPLETE user object (with the UID) to Firestore.
      await _userRepository.setUserData(myUser);

      if (!isClosed) {
        emit(state.copyWith(status: SubmissionStatus.success));
      }
    } catch (e) {
      log(e.toString());
      if (!isClosed) {
        emit(state.copyWith(status: SubmissionStatus.failure));
      }
    }
  }
}
