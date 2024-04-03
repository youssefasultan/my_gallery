import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:my_gallery/core/usecases/usecase.dart';
import 'package:my_gallery/core/utils/typedefs.dart';
import 'package:my_gallery/src/gallery/domain/repo/gallery_repo.dart';

class UploadImg extends UsecaseWithParams<void, UploadImgParams> {
  UploadImg(this._repo);
  final GalleryRepo _repo;

  @override
  ResultFuture<void> call(UploadImgParams params) =>
      _repo.uploadImg(params.img, params.token);
}

class UploadImgParams extends Equatable {
  const UploadImgParams({required this.token, required this.img});

  final String token;
  final File img;

  @override
  List<Object?> get props => [token];
}
