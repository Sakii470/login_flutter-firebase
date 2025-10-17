// lib/routing/app_router.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:login_app/blocs/authentication_cubit/cubit/authentication_cubit.dart';
import 'package:login_app/locator.dart';
import 'package:login_app/routing/home_shell.dart';
import 'package:login_app/screens/home/cubit/cubit/home_cubit.dart';
import 'package:login_app/screens/home/presentation/home_screen.dart';
import 'package:login_app/screens/welcome/presentation/welcome_screen.dart';
import 'dart:async';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// We only need the root welcome route as public, since sign-in/up are inside it.
const _publicRoutes = ['/'];

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _subscription;
  GoRouterRefreshStream(Stream stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  static GoRouter createGoRouter() {
    final authCubit = locator<AuthenticationCubit>();
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      redirect: (BuildContext context, GoRouterState state) {
        final status = authCubit.state.status;
        final loggedIn = status == AuthenticationStatus.authenticated;
        final location = state.uri.toString();

        final isGoingToProtectedRoute = !_publicRoutes.contains(location);

        // If not logged in and trying to access a protected route, redirect to welcome
        if (!loggedIn && isGoingToProtectedRoute) {
          return '/';
        }

        // If logged in and on the welcome screen, redirect to home
        if (loggedIn && location == '/') {
          return '/home';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'welcome',
          builder: (context, state) => const WelcomeScreen(),
        ),

        // Authenticated routes with a bottom navigation shell
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return HomeShell(navigationShell: navigationShell);
          },
          branches: [
            // Branch 1: Home
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  name: 'home',
                  builder: (context, state) {
                    return BlocProvider(
                      create: (context) => locator<HomeCubit>(),
                      child: const HomeScreen(),
                    );
                  },
                ),
              ],
            ),
            // Branch 2: Profile
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home/profile',
                  name: 'profile',
                  builder: (context, state) {
                    // If the profile screen had its own cubit, you'd provide it here.
                    return const Scaffold(
                      body: Center(child: Text('Profile Page - Coming Soon')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
