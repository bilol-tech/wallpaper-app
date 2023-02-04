class PhotosModel {
  String url;
  String photographer;
  String photographerUrl;
  int photographerId;
  SrcModel src;

  PhotosModel(this.url, this.photographer, this.photographerId,
      this.photographerUrl, this.src);

  factory PhotosModel.fromMap(Map<String, dynamic> parsedJson) {
    return PhotosModel(
        parsedJson["url"],
        parsedJson["photographer"],
        parsedJson["photographer_id"],
        parsedJson["photographer_url"],
        SrcModel.fromMap(parsedJson["src"]));
  }
}

class SrcModel {
  String portrait;
  String large;
  String landscape;
  String medium;

  SrcModel(this.portrait, this.landscape, this.large, this.medium);

  factory SrcModel.fromMap(Map<String, dynamic> srcJson) {
    return SrcModel(
      srcJson["portrait"],
      srcJson["large"],
      srcJson["landscape"],
      srcJson["medium"],
    );
  }
}
