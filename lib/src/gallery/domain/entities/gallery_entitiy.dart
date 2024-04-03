import 'package:equatable/equatable.dart';

class GalleryEntity extends Equatable {
  final String status;
  final String message;
  final List<String> imageUrl;

  const GalleryEntity({
    required this.status,
    required this.message,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
        status,
        message,
      ];
}
