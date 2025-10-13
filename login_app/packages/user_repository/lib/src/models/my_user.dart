// my_user.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:user_repository/user_repository.dart';
//import 'entities.dart';

part 'my_user.freezed.dart';

@freezed
class MyUser with _$MyUser {
  // private constructor is needed by freezed
  const MyUser._();

  const factory MyUser({
    required String id,
    required String email,
    required String name,
    String? picture,
  }) = _MyUser;

  /// Empty user which represents an unauthenticated user.
  static final empty = MyUser(
    id: '',
    email: '',
    name: '',
    picture: '',
  );

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == MyUser.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != MyUser.empty;

  // --- MAPPING LOGIC STAYS ---
  // The logic to map between layers is still your responsibility

  MyUserEntity toEntity() {
    return MyUserEntity(
      id: id,
      email: email,
      name: name,
      picture: picture,
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      picture: entity.picture,
    );
  }
}
