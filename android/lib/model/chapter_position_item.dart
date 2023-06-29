class ChapterPositionItem {
  ChapterPositionItem({
    required this.chapterName,
    required this.startIndex,
    required this.endIndex,
    required this.length,
    required this.chapterUrl
  });

  String chapterName;
  int startIndex;
  int endIndex;
  int length;
  String chapterUrl;

  @override
  String toString() {
    return 'chapterName:$chapterName, startIndex:$startIndex, endIndex:$endIndex, length:$length';
  }
}
