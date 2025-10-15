import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app/blocs/authentication_cubit/cubit/authentication_cubit.dart';
import 'package:login_app/blocs/my_user_cubit/cubit/my_user_cubit.dart';
import 'package:login_app/blocs/sign_in_cubit/cubit/sign_in_cubit.dart';
import 'package:login_app/screens/welcome/welcome_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'login_app',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
            background: Colors.white,
            onBackground: Colors.black,
            primary: Color.fromRGBO(206, 147, 216, 1),
            onPrimary: Colors.black,
            secondary: Color.fromRGBO(244, 143, 177, 1),
            onSecondary: Colors.white,
            tertiary: Color.fromRGBO(255, 204, 128, 1),
            error: Colors.red,
            outline: Color(0xFF424242)),
      ),
      home: BlocBuilder<AuthenticationCubit, AuthenticationState>(builder: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => SignInCubit(userRepository: context.read<AuthenticationCubit>().userRepository),
              ),
              // BlocProvider(
              // 	create: (context) => UpdateUserInfoBloc(
              // 		userRepository: context.read<AuthenticationBloc>().userRepository
              // 	),
              // ),
              BlocProvider(
                create: (context) => MyUserCubit(myUserRepository: context.read<AuthenticationCubit>().userRepository)
                  ..getMyUser(// <-- CORRECT: Calling the method directly
                      context.read<AuthenticationCubit>().state.user!.uid),
              ),

              // BlocProvider(
              // 	create: (context) => GetPostBloc(
              // 		postRepository: FirebasePostRepository()
              // 	)..add(GetPosts())
              // )
            ],
            child: WelcomeScreen(),
            // child: const HomeScreen(),
          );
        } else {
          return const WelcomeScreen();
        }
      }),
    );
  }
}
