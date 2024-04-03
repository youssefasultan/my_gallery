import 'package:equatable/equatable.dart';
import 'package:my_gallery/core/usecases/usecase.dart';
import 'package:my_gallery/core/utils/typedefs.dart';
import 'package:my_gallery/src/auth/domain/entites/user_entity.dart';
import 'package:my_gallery/src/auth/domain/repos/auth_repo.dart';

class SignIn extends UsecaseWithParams<UserEntity, SignInParams> {
  const SignIn(this._repo);

  final AuthRepo _repo;
  @override
  ResultFuture<UserEntity> call(SignInParams params) => _repo.signIn(
        email: params.email,
        password: params.password,
      );
}

class SignInParams extends Equatable {
  const SignInParams({required this.email, required this.password});

  const SignInParams.empty()
      : email = '',
        password = '';

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
