import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:login_app/blocs/authentication_cubit/cubit/authentication_cubit.dart';
import 'package:login_app/blocs/my_user_cubit/cubit/my_user_cubit.dart';
import 'package:user_repository/user_repository.dart'; // For MyUser

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AuthenticationCubit _authenticationCubit;
  final MyUserCubit _myUserCubit;
  late final StreamSubscription _authSubscription;
  late final StreamSubscription _myUserSubscription;

  HomeCubit({
    required AuthenticationCubit authenticationCubit,
    required MyUserCubit myUserCubit,
  })  : _authenticationCubit = authenticationCubit,
        _myUserCubit = myUserCubit,
        super(const HomeState()) {
    // Listen for authentication changes
    _authSubscription = _authenticationCubit.stream.listen((authState) {
      if (authState.status == AuthenticationStatus.authenticated) {
        _fetchUserData(authState.user!.uid);
      }
    });

    // Listen for changes in the user data
    _myUserSubscription = _myUserCubit.stream.listen((myUserState) {
      if (myUserState.status == MyUserStatus.success) {
        emit(state.copyWith(status: HomeStatus.success, user: myUserState.user));
      } else if (myUserState.status == MyUserStatus.loading) {
        emit(state.copyWith(status: HomeStatus.loading));
      }
    });

    // Handle initial state
    final initialAuthState = _authenticationCubit.state;
    if (initialAuthState.status == AuthenticationStatus.authenticated) {
      _fetchUserData(initialAuthState.user!.uid);
    }
  }

  void _fetchUserData(String userId) {
    _myUserCubit.getMyUser(userId);
  }

  @override
  Future<void> close() {
    // IMPORTANT: Always cancel subscriptions to prevent memory leaks
    _authSubscription.cancel();
    _myUserSubscription.cancel();
    return super.close();
  }
}
