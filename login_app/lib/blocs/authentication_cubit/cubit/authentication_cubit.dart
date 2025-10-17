import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';
import 'package:login_app/blocs/my_user_cubit/cubit/my_user_cubit.dart';
// NO LONGER NEEDED: import 'package:login_app/locator.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final UserRepository _userRepository;
  final MyUserCubit _myUserCubit; // add dependency
  late final StreamSubscription<User?> _userSubscription;

  AuthenticationCubit({required UserRepository userRepository, required MyUserCubit myUserCubit})
      : _userRepository = userRepository,
        _myUserCubit = myUserCubit,
        super(const AuthenticationState.unknown()) {
    _userSubscription = _userRepository.user.listen((user) {
      _onUserChanged(user);
    });
  }

  /// A private method to handle user changes from the stream.
  void _onUserChanged(User? user) {
    if (user != null) {
      emit(AuthenticationState.authenticated(user));
    } else {
      // clear MyUser state when unauthenticated
      _myUserCubit.clearUser();
      emit(const AuthenticationState.unauthenticated());
    }
  }

  /// Triggers the sign-out process.
  Future<void> signOut() async {
    await _userRepository.logOut();
    // proactively clear MyUser state on manual sign-out
    _myUserCubit.clearUser();
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
