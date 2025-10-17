part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.user,
  });

  final HomeStatus status;
  final MyUser? user; // The user data we want to display

  HomeState copyWith({
    HomeStatus? status,
    MyUser? user,
  }) {
    return HomeState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, user];
}
