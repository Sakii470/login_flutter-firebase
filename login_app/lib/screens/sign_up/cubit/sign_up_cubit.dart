import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final UserRepository _userRepository;

  SignUpCubit({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const SignUpState());

  void emailChanged(String value) {
    emit(state.copyWith(email: value));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value));
  }

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

      MyUser firebaseUser = await _userRepository.signUp(myUser, state.password);
      myUser = myUser.copyWith(id: firebaseUser.id);
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
