import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app/blocs/authentication_cubit/cubit/authentication_cubit.dart';
import 'package:login_app/routing/app_router.dart';
import 'package:login_app/constants/app_colors.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        final router = AppRouter.createGoRouter();
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'login_app',
          theme: ThemeData(
            colorScheme: AppColors.lightColorScheme,
          ),
          routerConfig: router,
        );
      },
    );
  }
}
