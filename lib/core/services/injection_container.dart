import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:my_gallery/src/auth/data/datasource/auth_remote_datasource.dart';
import 'package:my_gallery/src/auth/data/repos/auth_repo_impl.dart';
import 'package:my_gallery/src/auth/domain/repos/auth_repo.dart';

import 'package:my_gallery/src/auth/domain/usecases/sign_in.dart';
import 'package:my_gallery/src/auth/presntation/bloc/auth_bloc.dart';
import 'package:my_gallery/src/gallery/data/datasources/gallery_remote_data_source.dart';
import 'package:my_gallery/src/gallery/data/repos/gallery_repo_impl.dart';
import 'package:my_gallery/src/gallery/domain/repo/gallery_repo.dart';
import 'package:my_gallery/src/gallery/domain/usecases/get_galley.dart';
import 'package:my_gallery/src/gallery/domain/usecases/upload_img.dart';
import 'package:my_gallery/src/gallery/presenation/bloc/gallery_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _authInit();
  await _galleryInit();
}

Future<void> _galleryInit() async {
  sl
    ..registerFactory(() => GalleryBloc(getGallery: sl(), uploadImg: sl()))
    ..registerLazySingleton(() => GetGallery(sl()))
    ..registerLazySingleton(() => UploadImg(sl()))
    ..registerLazySingleton<GalleryRepo>(() => GalleryRepoImpl(sl()))
    ..registerLazySingleton<GalleryRemoteDataSource>(
      () => GalleryRemoteDataSourceImpl(sl()),
    );
}

Future<void> _authInit() async {
  // final prefs = await SharedPreferences.getInstance();

  sl
    ..registerFactory(
      () => AuthBloc(
        signIn: sl(),
      ),
    )
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()))
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton(http.Client.new);
}
