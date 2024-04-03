part of 'gallery_bloc.dart';

abstract class GalleryState extends Equatable {
  const GalleryState();

  @override
  List<Object> get props => [];
}

final class GalleryInitial extends GalleryState {}

class GalleryLoading extends GalleryState {
  const GalleryLoading();
}

class GalleryLoaded extends GalleryState {
  final GalleryModal galleryModal;
  const GalleryLoaded(this.galleryModal);
}

class GalleryError extends GalleryState {
  final String message;
  const GalleryError({required this.message});
  @override
  List<String> get props => [message];
}

class ImgUploaded extends GalleryState {
  const ImgUploaded();
}
