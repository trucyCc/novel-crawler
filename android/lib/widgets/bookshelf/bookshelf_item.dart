import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookshelfItemWidget extends ConsumerWidget {
  const BookshelfItemWidget({
    Key? key,
    required this.coverUrl,
    required this.bookName,
    required this.readLastChapterUrl,
    required this.readLastChapterName,
    required this.source,
    required this.bookId,
    required this.bookLastChapterName,
    required this.clickBookShelfItem,
  }) : super(key: key);

  final String coverUrl;
  final String bookName;
  final String readLastChapterUrl;
  final String readLastChapterName;
  final String bookLastChapterName;
  final String source;
  final String bookId;
  final Function clickBookShelfItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        clickBookShelfItem(
          source,
          bookId,
          bookName,
        );
      },
      child: Card(
        elevation: 2, // 设置卡片的阴影
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // 设置卡片的圆角
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 15,
            ),
            Image.network(
              coverUrl,
              width: 80,
              height: 130,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  bookName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('最新章节：$bookLastChapterName'),
                const SizedBox(
                  height: 13,
                ),
                Text('当前进度：$readLastChapterName')
              ],
            ),
          ],
        ),
      ),
    );
  }
}
