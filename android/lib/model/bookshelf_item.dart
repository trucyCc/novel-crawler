class BookShelfItem {
  final String coverUrl;
  final String bookName;
  final String readLastChapterUrl;
  final String readLastChapterName;
  final String bookLastChapterName;
  final String source;
  final String chapterId;
  final String bookId;

  BookShelfItem({
    required this.coverUrl,
    required this.bookName,
    required this.readLastChapterUrl,
    required this.readLastChapterName,
    required this.source,
    required this.chapterId,
    required this.bookId,
    required this.bookLastChapterName,
  });

  Map<String, dynamic> toMap() {
    return {
      'coverUrl': coverUrl,
      'bookName': bookName,
      'readLastChapterUrl': readLastChapterUrl,
      'readLastChapterName': readLastChapterName,
      'source': source,
      'chapterId': chapterId,
      'bookId': bookId,
      'bookLastChapterName': bookLastChapterName,
    };
  }

  static BookShelfItem fromMap(Map<String, dynamic> map) {
    return BookShelfItem(
      coverUrl: map['coverUrl'],
      bookName: map['bookName'],
      readLastChapterUrl: map['readLastChapterUrl'],
      readLastChapterName: map['readLastChapterName'],
      source: map['source'],
      chapterId: map['chapterId'],
      bookId: map['bookId'],
      bookLastChapterName: map['bookLastChapterName'],
    );
  }
}
