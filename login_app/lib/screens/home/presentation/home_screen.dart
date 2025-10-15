import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app/screens/home/cubit/cubit/home_cubit.dart';
import 'package:login_app/blocs/authentication_cubit/cubit/authentication_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          BlocProvider(
            create: (context) => HomeCubit(
              userRepository: context.read<AuthenticationCubit>().userRepository,
            ),
            child: Builder(
              builder: (context) => IconButton(
                onPressed: () {
                  // Call the signOut method from the HomeCubit
                  context.read<HomeCubit>().signOut();
                },
                icon: const Icon(Icons.logout),
              ),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              size: 80,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome Home!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
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
