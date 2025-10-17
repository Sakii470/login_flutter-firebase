// lib/routing/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:login_app/blocs/authentication_cubit/cubit/authentication_cubit.dart';
import 'package:login_app/screens/home/presentation/home_screen.dart';
import 'package:login_app/screens/welcome/presentation/welcome_screen.dart';
import 'package:login_app/routing/home_shell.dart';
import 'dart:async';

// Use a root navigator key for more advanced navigation scenarios like showing dialogs over the shell
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// A list of public routes that don't require authentication.
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
  static GoRouter createGoRouter(AuthenticationCubit authCubit) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      redirect: (BuildContext context, GoRouterState state) {
        final status = authCubit.state.status;
        final loggedIn = status == AuthenticationStatus.authenticated;
        final location = state.uri.toString();

        final isGoingToProtectedRoute = !_publicRoutes.contains(location);

        if (!loggedIn && isGoingToProtectedRoute) {
          return '/';
        }

        if (loggedIn && location == '/') {
          return '/home';
        }

        return null;
      },
      routes: [
        // Welcome/Login route (outside the shell)
        GoRoute(
          path: '/',
          name: 'welcome',
          builder: (context, state) => const WelcomeScreen(),
        ),

        // CORRECTED: Use StatefulShellRoute for tabbed navigation
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            // The builder now provides a `navigationShell` object.
            // Pass this object to your HomeShell.
            return HomeShell(navigationShell: navigationShell);
          },
          branches: [
            // Branch 1: The "Home" tab
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  name: 'home',
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),

            // Branch 2: The "Profile" tab
            StatefulShellBranch(
              routes: [
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
        ),
      ],
    );
  }
}
