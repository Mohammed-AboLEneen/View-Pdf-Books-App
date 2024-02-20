class BookModel {
  String? title;
  String? author;
  String? imageUrl;
  String? bookUrl;

  BookModel();

  BookModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    author = json['author'];
    author = json['url'];
  }
}
