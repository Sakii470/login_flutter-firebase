import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final UserRepository _userRepository;

  SignUpCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SignUpInitial());

  /// Triggers the sign-up process.
  Future<void> signUp({required MyUser user, required String password}) async {
    emit(SignUpProcess());
    try {
      // It's good practice to use the user object returned by the signUp method,
      // as it may contain updated info like the generated user ID.
      MyUser createdUser = await _userRepository.signUp(user, password);
      await _userRepository.setUserData(createdUser);
      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpFailure());
    }
  }
}
