import 'package:dartz/dartz.dart';
import 'package:my_gallery/core/errors/exceptions.dart';
import 'package:my_gallery/core/errors/failure.dart';
import 'package:my_gallery/core/utils/typedefs.dart';
import 'package:my_gallery/src/auth/data/datasource/auth_remote_datasource.dart';

import 'package:my_gallery/src/auth/domain/entites/user_entity.dart';
import 'package:my_gallery/src/auth/domain/repos/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepoImpl(this._remoteDataSource);

  @override
  ResultFuture<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remoteDataSource.signIn(
        email: email,
        password: password,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(statusCode: e.statusCode, message: e.message));
    }
  }
}
