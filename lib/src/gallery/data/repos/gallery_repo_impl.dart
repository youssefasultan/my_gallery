import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:my_gallery/core/errors/exceptions.dart';
import 'package:my_gallery/core/errors/failure.dart';
import 'package:my_gallery/core/utils/typedefs.dart';
import 'package:my_gallery/src/gallery/data/datasources/gallery_remote_data_source.dart';
import 'package:my_gallery/src/gallery/domain/entities/gallery_entitiy.dart';
import 'package:my_gallery/src/gallery/domain/repo/gallery_repo.dart';

class GalleryRepoImpl extends GalleryRepo {
  GalleryRepoImpl(this._remoteDataSource);
  final GalleryRemoteDataSource _remoteDataSource;
  @override
  ResultFuture<GalleryEntity> getGallery(String token) async {
    try {
      final result = await _remoteDataSource.getImages(token: token);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(statusCode: e.statusCode, message: e.message));
    }
  }

  @override
  ResultFuture<void> uploadImg(File path, String token) async {
    try {
      await _remoteDataSource.uploadImg(img: path, token: token);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(statusCode: e.statusCode, message: e.message));
    }
  }
}
