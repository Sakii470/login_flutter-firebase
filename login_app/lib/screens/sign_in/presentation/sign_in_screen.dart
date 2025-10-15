import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app/screens/sign_in/cubit/sign_in_cubit.dart';

import '../../../components/strings.dart' hide emailRexExp, passwordRexExp;
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

  @override
  Widget build(BuildContext context) {
    // BlocListener is great for "one-time" actions like showing a SnackBar or navigating.
    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state.status == SignInStatus.failure && state.errorMessage != null) {
          // You could show a SnackBar here for a better user experience
          // ScaffoldMessenger.of(context)
          //   ..hideCurrentSnackBar()
          //   ..showSnackBar(
          //     SnackBar(content: Text(state.errorMessage!)),
          //   );
        }
        // Navigation on success would also go here.
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            _EmailInputField(),
            const SizedBox(height: 10),
            _PasswordInputField(
              obscureText: obscurePassword,
              icon: iconPassword,
              onSuffixIconPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                  iconPassword = obscurePassword ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill;
                });
              },
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

class _EmailInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: MyTextField(
        // controller can be omitted if you fully rely on Cubit state
        hintText: 'Email',
        obscureText: false,
        keyboardType: TextInputType.emailAddress,
        prefixIcon: const Icon(CupertinoIcons.mail_solid),
        onChanged: (email) {
          context.read<SignInCubit>().emailChanged(email!);
        },
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please fill in this field';
          } else if (!emailRexExp.hasMatch(val)) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),
    );
  }
}

class _PasswordInputField extends StatelessWidget {
  final bool obscureText;
  final IconData icon;
  final VoidCallback onSuffixIconPressed;

  const _PasswordInputField({
    required this.obscureText,
    required this.icon,
    required this.onSuffixIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: MyTextField(
        hintText: 'Password',
        obscureText: obscureText,
        keyboardType: TextInputType.visiblePassword,
        prefixIcon: const Icon(CupertinoIcons.lock_fill),
        onChanged: (password) {
          context.read<SignInCubit>().passwordChanged(password!);
        },
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please fill in this field';
          } else if (!passwordRexExp.hasMatch(val)) {
            return 'Please enter a valid password';
          }
          return null;
        },
        suffixIcon: IconButton(
          onPressed: onSuffixIconPressed,
          icon: Icon(icon),
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
                  onPressed: state.isValid
                      ? () {
                          // Use formKey to show validation errors on fields
                          final form = Form.of(context);
                          if (form.validate()) {
                            context.read<SignInCubit>().signInWithCredentials();
                          }
                        }
                      : null,
                  style: TextButton.styleFrom(
                    elevation: 3.0,
                    backgroundColor: state.isValid ? Theme.of(context).colorScheme.primary : Colors.grey.shade400,
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
