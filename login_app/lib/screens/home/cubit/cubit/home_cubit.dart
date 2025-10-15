import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart'; // Import the repository

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final UserRepository _userRepository;

  // Modify the constructor to accept the UserRepository
  HomeCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(HomeInitial());

  /// Triggers the sign-out process.
  Future<void> signOut() async {
    // This simply calls the repository.
    // The app's root AuthenticationBloc will listen to the user stream
    // from the repository and handle the navigation.
    await _userRepository.logOut();
  }
}
