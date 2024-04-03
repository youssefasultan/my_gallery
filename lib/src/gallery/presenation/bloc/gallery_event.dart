part of 'gallery_bloc.dart';

abstract class GalleryEvent extends Equatable {
  const GalleryEvent();

  @override
  List<Object> get props => [];
}

class GetGalleryEvent extends GalleryEvent {
  const GetGalleryEvent({required this.token});
  final String token;

  @override
  List<Object> get props => [token];
}

class UploadImgEvent extends GalleryEvent {
  const UploadImgEvent({required this.img, required this.token});
  final File img;
  final String token;
  @override
  List<Object> get props => [img, token];
}
