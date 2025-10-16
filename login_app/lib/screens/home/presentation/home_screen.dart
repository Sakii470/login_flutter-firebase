// lib/screens/home/presentation/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app/blocs/authentication_cubit/cubit/authentication_cubit.dart';
import 'package:login_app/blocs/my_user_cubit/cubit/my_user_cubit.dart';
import 'package:login_app/screens/sign_in/cubit/sign_in_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the necessary Blocs for this screen and its children.
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignInCubit(
            userRepository: context.read<AuthenticationCubit>().userRepository,
          ),
        ),
        BlocProvider(
          create: (context) {
            // Safely get the user ID without force unwrapping.
            final userId = context.read<AuthenticationCubit>().state.user?.uid;

            // Create the Cubit.
            final myUserCubit = MyUserCubit(
              myUserRepository: context.read<AuthenticationCubit>().userRepository,
            );

            // Trigger the data fetch only if we have a valid user ID.
            if (userId != null) {
              myUserCubit.getMyUser(userId);
            }

            return myUserCubit;
          },
        ),
      ],
      // The actual UI for the home screen.
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              // Call the signOut method directly from the AuthenticationCubit.
              context.read<AuthenticationCubit>().signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Example of using the MyUserCubit state
            BlocBuilder<MyUserCubit, MyUserState>(
              builder: (context, state) {
                if (state.status == MyUserStatus.loading) {
                  return const CircularProgressIndicator();
                } else if (state.user != null) {
                  return Text(
                    'Welcome, ${state.user!.name}!', // Display user's name
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                return const Text(
                  // Fallback welcome message
                  'Welcome Home!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Icon(
              Icons.home,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 10),
            const Text(
              'You have successfully signed in.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
