import 'package:get_it/get_it.dart';
import 'package:login_app/blocs/authentication_cubit/cubit/authentication_cubit.dart';
import 'package:login_app/blocs/my_user_cubit/cubit/my_user_cubit.dart';
import 'package:login_app/screens/home/cubit/cubit/home_cubit.dart';
import 'package:login_app/screens/sign_in/cubit/sign_in_cubit.dart';
import 'package:login_app/screens/sign_up/cubit/sign_up_cubit.dart';
import 'package:user_repository/user_repository.dart';

final locator = GetIt.instance;

/// Set up all dependencies for the app
void setupLocator() {
  // Register Repository (dependency)
  locator.registerLazySingleton<UserRepository>(() => FirebaseUserRepository());

  // Register AuthenticationCubit with UserRepository dependency
  locator.registerLazySingleton<AuthenticationCubit>(
    () => AuthenticationCubit(
      userRepository: locator<UserRepository>(),
      myUserCubit: locator<MyUserCubit>(),
    ),
  );

  // Register MyUserCubit with UserRepository dependency
  locator.registerLazySingleton<MyUserCubit>(
    () => MyUserCubit(
      locator<UserRepository>(),
    ),
  );

  // Register screen-specific cubits as factories
  locator.registerFactory<HomeCubit>(
    () => HomeCubit(
      authenticationCubit: locator<AuthenticationCubit>(),
      myUserCubit: locator<MyUserCubit>(),
    ),
  );

  // Add the factory recipe for SignInCubit
  locator.registerFactory<SignInCubit>(
    () => SignInCubit(
      userRepository: locator<UserRepository>(),
    ),
  );

  locator.registerFactory<SignUpCubit>(
    () => SignUpCubit(
      userRepository: locator<UserRepository>(),
    ),
  );
}
