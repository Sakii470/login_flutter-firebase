import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final UserRepository userRepository;
  late final StreamSubscription<User?> _userSubscription;

  AuthenticationCubit({required UserRepository myUserRepository})
      : userRepository = myUserRepository,
        super(const AuthenticationState.unknown()) {
    // Listen to the user stream from the repository.
    // Instead of adding an event, we directly process the user object.
    _userSubscription = userRepository.user.listen((user) {
      _onUserChanged(user);
    });
  }

  /// A private method to handle user changes from the stream.
  void _onUserChanged(User? user) {
    if (user != null) {
      // If the user exists, emit an authenticated state.
      emit(AuthenticationState.authenticated(user));
    } else {
      // If the user is null, emit an unauthenticated state.
      emit(const AuthenticationState.unauthenticated());
    }
  }

  // It's crucial to cancel the stream subscription when the Cubit is closed
  // to prevent memory leaks.
  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
