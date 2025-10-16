import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart'; // Import the repository

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  // Modify the constructor to accept the UserRepository
  HomeCubit({required UserRepository userRepository}) : super(HomeInitial());
}
