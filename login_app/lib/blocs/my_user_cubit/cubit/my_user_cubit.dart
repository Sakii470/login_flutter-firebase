import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:login_app/locator.dart'; // Import the locator
import 'package:user_repository/user_repository.dart';

part 'my_user_state.dart';

class MyUserCubit extends Cubit<MyUserState> {
  // The Cubit now fetches its dependency from the locator.
  final UserRepository _userRepository = locator<UserRepository>();

  // The constructor no longer needs any parameters.
  MyUserCubit(UserRepository userRepository) : super(const MyUserState.loading());

  /// Fetches the user data for the given userId.
  Future<void> getMyUser(String myUserId) async {
    // No need to emit loading here if we handle it reactively.
    // The initial state is already loading.
    try {
      MyUser myUser = await _userRepository.getMyUser(myUserId);
      emit(MyUserState.success(myUser));
    } catch (e) {
      log(e.toString());
      emit(const MyUserState.failure());
    }
  }

  /// Clears the current MyUser state (used on sign-out).
  void clearUser() {
    emit(const MyUserState.loading());
  }
}
