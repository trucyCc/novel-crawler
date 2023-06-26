class BookShelfItem {
  final int? id;
  final String bookSource;
  final String lastChapterUrl;
  final String lastChapterName;
  final String bookCoverUrl;
  final String createdAt;

  BookShelfItem({
    this.id,
    required this.bookSource,
    required this.lastChapterUrl,
    required this.lastChapterName,
    required this.bookCoverUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'book_source': bookSource,
      'last_chapter_url': lastChapterUrl,
      'last_chapter_name': lastChapterName,
      'book_cover_url': bookCoverUrl,
      'created_at': createdAt,
    };
  }

  factory BookShelfItem.fromMap(Map<String, dynamic> map) {
    return BookShelfItem(
      id: map['id'],
      bookSource: map['book_source'],
      lastChapterUrl: map['last_chapter_url'],
      lastChapterName: map['last_chapter_name'],
      bookCoverUrl: map['book_cover_url'],
      createdAt: map['created_at'],
    );
  }
}
