import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'my_user_state.dart';

class MyUserCubit extends Cubit<MyUserState> {
  final UserRepository _userRepository;

  MyUserCubit({required UserRepository myUserRepository})
      : _userRepository = myUserRepository,
        super(const MyUserState.loading());

  /// Fetches the user data for the given userId.
  Future<void> getMyUser(String myUserId) async {
    // It's good practice to emit a loading state just before the async call.
    emit(const MyUserState.loading());
    try {
      MyUser myUser = await _userRepository.getMyUser(myUserId);
      emit(MyUserState.success(myUser));
    } catch (e) {
      log(e.toString());
      emit(const MyUserState.failure());
    }
  }
}
