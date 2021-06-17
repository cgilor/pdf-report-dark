final String tableImages = 'images';

class ImageFields {
  static final List<String> values = [id, path, description];

  static final String id = '_id';
  static final String path = 'path';
  static final String description = 'description';
}

class ImagePdf {
  int? id;
  String? path;
  String? description;

  ImagePdf({
    this.id,
    this.path,
    this.description,
  });

  ImagePdf copy({
    int? id,
    String? path,
    String? description,
  }) =>
      ImagePdf(
        id: id ?? this.id,
        path: path ?? this.path,
        description: description ?? this.description,
      );

  static ImagePdf fromJson(Map<String, dynamic> json) => ImagePdf(
        id: json[ImageFields.id],
        path: json[ImageFields.path],
        description: json[ImageFields.description],
      );
  Map<String, dynamic> toJson() => {
        ImageFields.id: id,
        ImageFields.path: path,
        ImageFields.description: description,
      };
}
