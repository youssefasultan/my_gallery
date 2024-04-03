import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_gallery/src/gallery/data/models/gallery_modal.dart';
import 'package:my_gallery/src/gallery/domain/usecases/get_galley.dart';
import 'package:my_gallery/src/gallery/domain/usecases/upload_img.dart';

part 'gallery_event.dart';
part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  GalleryBloc({required GetGallery getGallery, required UploadImg uploadImg})
      : _getGallery = getGallery,
        _uploadImg = uploadImg,
        super(GalleryInitial()) {
    on<GalleryEvent>((event, emit) {
      emit(const GalleryLoading());
    });

    on<GetGalleryEvent>(_getGalleryhandler);
    on<UploadImgEvent>(_uploadImghandler);
  }
  final GetGallery _getGallery;
  final UploadImg _uploadImg;

  Future<void> _getGalleryhandler(
      GetGalleryEvent event, Emitter<GalleryState> emit) async {
    final result = await _getGallery.call(event.token);
    result.fold(
      (failure) => emit(GalleryError(message: failure.message)),
      (r) => emit(GalleryLoaded(r as GalleryModal)),
    );
  }

  Future<void> _uploadImghandler(
      UploadImgEvent event, Emitter<GalleryState> emit) async {
    final result =
        await _uploadImg(UploadImgParams(token: event.token, img: event.img));
    result.fold(
      (l) => emit(GalleryError(message: l.message)),
      (r) => emit(const ImgUploaded()),
    );
  }
}
