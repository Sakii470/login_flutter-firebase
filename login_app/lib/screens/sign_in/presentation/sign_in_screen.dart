import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app/constants/app_colors.dart';
import 'package:login_app/screens/sign_in/cubit/sign_in_cubit.dart';

import '../../../components/textfield.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Local UI state that doesn't affect business logic can remain here.
  bool obscurePassword = true;
  IconData iconPassword = CupertinoIcons.eye_fill;
  final _formKey = GlobalKey<FormState>();
  // Add controllers to avoid updating state on every keystroke
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // BlocListener is great for "one-time" actions like showing a SnackBar or navigating.
    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state.status == SignInStatus.failure && state.errorMessage != null) {
          // You could show a SnackBar here for a better user experience
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).colorScheme.error,
                content: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: AppColors.white),
                ),
              ),
            );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            _EmailInputField(screenWidth: screenWidth, controller: _emailController),
            const SizedBox(height: 10),
            _PasswordInputField(
              screenWidth: screenWidth,
              obscureText: obscurePassword,
              icon: iconPassword,
              onSuffixIconPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                  iconPassword = obscurePassword ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill;
                });
              },
              controller: _passwordController,
            ),
            _ErrorMessage(),
            const SizedBox(height: 20),
            _SignInButton(),
          ],
        ),
      ),
    );
  }
}

// All the private helper widgets (_EmailInputField, etc.) remain unchanged.
// ...existing code...

class _EmailInputField extends StatelessWidget {
  final double screenWidth;
  final TextEditingController controller;

  const _EmailInputField({required this.screenWidth, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth * 0.9,
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            context.read<SignInCubit>().emailChanged(controller.text);
          }
        },
        child: MyTextField(
          // controller used to read text when focus is lost
          hintText: 'Email',
          obscureText: false,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(CupertinoIcons.mail_solid),
          controller: controller,
          validator: (val) => null, // No validation
        ),
      ),
    );
  }
}

class _PasswordInputField extends StatelessWidget {
  final double screenWidth;
  final bool obscureText;
  final IconData icon;
  final VoidCallback onSuffixIconPressed;
  final TextEditingController controller;

  const _PasswordInputField({
    required this.screenWidth,
    required this.obscureText,
    required this.icon,
    required this.onSuffixIconPressed,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth * 0.9,
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            context.read<SignInCubit>().passwordChanged(controller.text);
          }
        },
        child: MyTextField(
          hintText: 'Password',
          obscureText: obscureText,
          keyboardType: TextInputType.visiblePassword,
          prefixIcon: const Icon(CupertinoIcons.lock_fill),
          controller: controller,
          validator: (val) => null, // No validation
          suffixIcon: IconButton(
            onPressed: onSuffixIconPressed,
            icon: Icon(icon),
          ),
        ),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status == SignInStatus.failure && state.errorMessage != null) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              state.errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Rebuild the button based on the form status and validity.
    return BlocBuilder<SignInCubit, SignInState>(
      // Only rebuild when status or validity changes
      buildWhen: (previous, current) => previous.status != current.status || previous.isValid != current.isValid,
      builder: (context, state) {
        return state.status == SignInStatus.loading
            ? const CircularProgressIndicator()
            : SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                child: TextButton(
                  // Button is disabled if the form is invalid
                  onPressed: () {
                    // Ensure fields commit their values by unfocusing
                    FocusScope.of(context).unfocus();
                    // Use formKey to show validation errors on fields
                    final form = Form.of(context);
                    if (form.validate()) {
                      context.read<SignInCubit>().signInWithCredentials();
                    }
                  },
                  style: TextButton.styleFrom(
                    elevation: 3.0,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    child: Text(
                      'Sign In',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
