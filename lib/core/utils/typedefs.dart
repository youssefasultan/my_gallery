import 'package:dartz/dartz.dart';
import 'package:my_gallery/core/errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef DataMap = Map<String, dynamic>;
