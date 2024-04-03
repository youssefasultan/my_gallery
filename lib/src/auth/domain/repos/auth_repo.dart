import 'package:my_gallery/core/utils/typedefs.dart';
import 'package:my_gallery/src/auth/domain/entites/user_entity.dart';

abstract class AuthRepo {
  const AuthRepo();

  ResultFuture<UserEntity> signIn({
    required String email,
    required String password,
  });
}
