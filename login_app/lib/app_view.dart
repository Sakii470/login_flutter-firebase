import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app/blocs/authentication_cubit/cubit/authentication_cubit.dart';
import 'package:login_app/app_router.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        final router = AppRouter.createGoRouter(context.read<AuthenticationCubit>());

        return MaterialApp.router(
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
          routerConfig: router,
        );
      },
    );
  }
}
