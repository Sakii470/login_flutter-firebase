import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:login_app/blocs/authentication_cubit/cubit/authentication_cubit.dart';
import 'package:login_app/blocs/my_user_cubit/cubit/my_user_cubit.dart';
import 'package:login_app/screens/sign_in/cubit/sign_in_cubit.dart';
import 'package:login_app/screens/welcome/presentation/welcome_screen.dart';
import 'package:login_app/screens/home/presentation/home_screen.dart';
import 'package:login_app/routing/home_shell.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class GoRouterRefreshStream extends ChangeNotifier {
  late final Stream _stream;

  GoRouterRefreshStream(Stream stream) {
    _stream = stream;
    _stream.listen((_) => notifyListeners());
  }
}

class AppRouter {
  static GoRouter createGoRouter(AuthenticationCubit authCubit) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: '/',
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      redirect: (BuildContext context, GoRouterState state) {
        final status = authCubit.state.status;
        final loggedIn = status == AuthenticationStatus.authenticated;
        final location = state.uri.toString();

        // If not logged in and trying to access protected routes, redirect to welcome
        if (!loggedIn && location.startsWith('/home')) {
          return '/';
        }

        // If logged in and on welcome page, redirect to home
        if (loggedIn && location == '/') {
          return '/home';
        }

        return null;
      },
      routes: [
        // Welcome/Login route
        GoRoute(
          path: '/',
          name: 'welcome',
          builder: (context, state) => const WelcomeScreen(),
        ),

        // Home Shell with bottom navigation
        ShellRoute(
          builder: (context, state, child) {
            final location = state.uri.toString();
            final segments = location.split('/');
            final showBottomNav = segments.length <= 3;
            final loggedIn = authCubit.state.status == AuthenticationStatus.authenticated;

            return HomeShell(
              child: child,
              location: location,
              showBottomNav: showBottomNav,
              loggedIn: loggedIn,
            );
          },
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => SignInCubit(
                      userRepository: context.read<AuthenticationCubit>().userRepository,
                    ),
                  ),
                  BlocProvider(
                    create: (context) => MyUserCubit(
                      myUserRepository: context.read<AuthenticationCubit>().userRepository,
                    )..getMyUser(
                        context.read<AuthenticationCubit>().state.user!.uid,
                      ),
                  ),
                ],
                child: const HomeScreen(),
              ),
            ),
            GoRoute(
              path: '/home/profile',
              name: 'profile',
              builder: (context, state) => const Scaffold(
                body: Center(
                  child: Text('Profile Page - Coming Soon'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
