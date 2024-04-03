import 'dart:convert';

import 'package:my_gallery/core/utils/typedefs.dart';
import 'package:my_gallery/src/gallery/domain/entities/gallery_entitiy.dart';

class GalleryModal extends GalleryEntity {
  const GalleryModal({
    required super.status,
    required super.message,
    required super.imageUrl,
  });

  GalleryModal.fromMap(DataMap map)
      : this(
          message: map['message'] as String,
          status: map['status'] as String,
          imageUrl: (map['data']['images'] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
        );

  factory GalleryModal.fromJson(String source) =>
      GalleryModal.fromMap(jsonDecode(source) as DataMap);
}
