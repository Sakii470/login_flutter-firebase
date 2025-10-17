import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app/constants/app_colors.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        // Use the listener for side-effects like showing a SnackBar.
        if (state.status == SubmissionStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.red,
                content: Text('Sign Up Failure', style: TextStyle(color: AppColors.white)),
              ),
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
                width: screenWidth * 0.9,
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      context.read<SignUpCubit>().emailChanged(emailController.text);
                    }
                  },
                  child: MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(CupertinoIcons.mail_solid),
                    // onChanged removed to avoid emitting on each keystroke
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      } else if (!emailRexExp.hasMatch(val)) {
                        return 'Please enter a valid email format (example@domain.com)';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: screenWidth * 0.9,
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      context.read<SignUpCubit>().passwordChanged(passwordController.text);
                    }
                  },
                  child: MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: const Icon(CupertinoIcons.lock_fill),
                    // onChanged removed to avoid emitting on each keystroke
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
                      }
                      return null;
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),
              SizedBox(
                width: screenWidth * 0.9,
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      context.read<SignUpCubit>().nameChanged(nameController.text);
                    }
                  },
                  child: MyTextField(
                    controller: nameController,
                    hintText: 'Name',
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    prefixIcon: const Icon(CupertinoIcons.person_fill),
                    // onChanged removed to avoid emitting on each keystroke
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
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              // Rebuild the button based on the submission status
              BlocBuilder<SignUpCubit, SignUpState>(
                builder: (context, state) {
                  return state.status == SubmissionStatus.inProgress
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: screenWidth * 0.5,
                          child: TextButton(
                              // Disable the button if the form is invalid
                              onPressed: () {
                                // Ensure fields commit their values by unfocusing
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  context.read<SignUpCubit>().signUp();
                                }
                              },
                              style: TextButton.styleFrom(
                                  elevation: 3.0,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary, // Visual feedback for disabled state
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
