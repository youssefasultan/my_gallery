import 'dart:io';

import 'package:my_gallery/core/utils/typedefs.dart';
import 'package:my_gallery/src/gallery/domain/entities/gallery_entitiy.dart';

abstract class GalleryRepo {
  ResultFuture<GalleryEntity> getGallery(String token);
  ResultFuture<void> uploadImg(File path, String token);
}
