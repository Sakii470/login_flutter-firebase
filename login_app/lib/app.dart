import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app/blocs/authentication_cubit/cubit/authentication_cubit.dart';
import 'package:login_app/blocs/my_user_cubit/cubit/my_user_cubit.dart';
import 'package:login_app/locator.dart';
import 'app_view.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use MultiBlocProvider to provide both cubits
    return MultiBlocProvider(
      providers: [
        // Provider for AuthenticationCubit
        BlocProvider<AuthenticationCubit>(
          create: (_) => locator<AuthenticationCubit>(),
        ),
        // Provider for MyUserCubit
        BlocProvider<MyUserCubit>(
          create: (_) => locator<MyUserCubit>(),
        ),
      ],
      child: const MyAppView(),
    );
  }
}
