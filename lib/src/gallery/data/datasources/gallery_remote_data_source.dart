import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:my_gallery/core/errors/exceptions.dart';
import 'package:my_gallery/src/gallery/data/models/gallery_modal.dart';

abstract class GalleryRemoteDataSource {
  Future<GalleryModal> getImages({required String token});

  Future<void> uploadImg({required File img, required String token});
}

class GalleryRemoteDataSourceImpl implements GalleryRemoteDataSource {
  final http.Client _client;

  GalleryRemoteDataSourceImpl(this._client);
  @override
  Future<GalleryModal> getImages({required String token}) async {
    try {
      final response = await _client.get(
        Uri.https('flutter.prominaagency.com', 'api/my-gallery'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return GalleryModal.fromJson(response.body);
      } else {
        throw ServerException(
          message: 'Wrong Token',
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  @override
  Future<void> uploadImg({required File img, required String token}) {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.https('flutter.prominaagency.com', 'api/upload'),
        
      );
      request.files.add(
        http.MultipartFile.fromBytes(
          'img',
          img.readAsBytesSync(),
          filename: img.path.split('/').last,
        ),
      );
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      return _client.send(request).then((value) {
        if (value.statusCode == 200) {
          return;
        } else {
          throw ServerException(
            message: 'Wrong Token',
            statusCode: value.statusCode,
          );
        }
      });
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }
}
