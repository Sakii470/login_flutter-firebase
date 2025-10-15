// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app/blocs/authentication_cubit/cubit/authentication_cubit.dart';
import 'package:user_repository/user_repository.dart';
import 'app_view.dart';

class MainApp extends StatelessWidget {
  final UserRepository userRepository;
  const MainApp({required this.userRepository, super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Provide the repository to the rest of the app.
    return RepositoryProvider<UserRepository>(
      create: (context) => userRepository,
      // 2. Use MultiBlocProvider to provide all app-level Blocs.
      child: BlocProvider<AuthenticationCubit>(
        create: (context) => AuthenticationCubit(
          myUserRepository: userRepository,
        ),
        child: const MyAppView(),
      ),
    );
  }
}
