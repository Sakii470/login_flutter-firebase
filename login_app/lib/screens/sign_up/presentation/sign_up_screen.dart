import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app/screens/sign_up/cubit/sign_up_cubit.dart';

import '../../../components/strings.dart';
import '../../../components/textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  bool obscurePassword = true;
  IconData iconPassword = CupertinoIcons.eye_fill;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        // Use the listener for side-effects like showing a SnackBar.
        if (state.status == SubmissionStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Sign Up Failure')),
            );
        }
        // Navigation would also be a side-effect handled here.
      },
      child: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(CupertinoIcons.mail_solid),
                  // Send changes to the cubit
                  onChanged: (email) {
                    if (email != null) {
                      context.read<SignUpCubit>().emailChanged(email);
                    }
                    return null;
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
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: const Icon(CupertinoIcons.lock_fill),
                  // Send changes to the cubit
                  onChanged: (password) {
                    if (password != null) {
                      context.read<SignUpCubit>().passwordChanged(password);
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        // This setState is OK as it only controls local UI state
                        obscurePassword = !obscurePassword;
                        if (obscurePassword) {
                          iconPassword = CupertinoIcons.eye_fill;
                        } else {
                          iconPassword = CupertinoIcons.eye_slash_fill;
                        }
                      });
                    },
                    icon: Icon(iconPassword),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please fill in this field';
                    } else if (!passwordRexExp.hasMatch(val)) {
                      return 'Please enter a valid password';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              // Use BlocBuilder to rebuild only the widgets that depend on the state
              BlocBuilder<SignUpCubit, SignUpState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "⚈  1 uppercase",
                            style: TextStyle(
                                color: state.containsUpperCase
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.onBackground),
                          ),
                          Text(
                            "⚈  1 lowercase",
                            style: TextStyle(
                                color: state.containsLowerCase
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.onBackground),
                          ),
                          Text(
                            "⚈  1 number",
                            style: TextStyle(
                                color:
                                    state.containsNumber ? Colors.green : Theme.of(context).colorScheme.onBackground),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "⚈  1 special character",
                            style: TextStyle(
                                color: state.containsSpecialChar
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.onBackground),
                          ),
                          Text(
                            "⚈  8 minimum character",
                            style: TextStyle(
                                color:
                                    state.contains8Length ? Colors.green : Theme.of(context).colorScheme.onBackground),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: MyTextField(
                  controller: nameController,
                  hintText: 'Name',
                  obscureText: false,
                  keyboardType: TextInputType.name,
                  prefixIcon: const Icon(CupertinoIcons.person_fill),
                  // Send changes to the cubit
                  onChanged: (name) {
                    if (name != null) {
                      context.read<SignUpCubit>().nameChanged(name);
                    }
                    return null;
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please fill in this field';
                    } else if (val.length > 30) {
                      return 'Name too long';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              // Rebuild the button based on the submission status
              BlocBuilder<SignUpCubit, SignUpState>(
                builder: (context, state) {
                  return state.status == SubmissionStatus.inProgress
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: TextButton(
                              // Disable the button if the form is invalid
                              onPressed: state.isFormValid
                                  ? () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<SignUpCubit>().signUp();
                                      }
                                    }
                                  : null, // Setting onPressed to null disables the button
                              style: TextButton.styleFrom(
                                  elevation: 3.0,
                                  backgroundColor: state.isFormValid
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey, // Visual feedback for disabled state
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60))),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              )),
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
