import 'package:my_gallery/core/usecases/usecase.dart';
import 'package:my_gallery/core/utils/typedefs.dart';
import 'package:my_gallery/src/gallery/domain/entities/gallery_entitiy.dart';
import 'package:my_gallery/src/gallery/domain/repo/gallery_repo.dart';

class GetGallery extends UsecaseWithParams<GalleryEntity, String> {
  final GalleryRepo _galleryRepo;

  GetGallery(this._galleryRepo);

  @override
  ResultFuture<GalleryEntity> call(String params) => _galleryRepo.getGallery(params);
}
