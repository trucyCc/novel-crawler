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
    required this.loadBookshelf,
    required this.delBook,
  }) : super(key: key);

  final String coverUrl;
  final String bookName;
  final String readLastChapterUrl;
  final String readLastChapterName;
  final String bookLastChapterName;
  final String source;
  final String bookId;
  final Function clickBookShelfItem;
  final Function loadBookshelf;
  final Function delBook;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: GlobalKey(),
      direction: DismissDirection.endToStart,
      background: FractionallySizedBox(
        // widthFactor: 0.33,
        child: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      onDismissed: (direction) async {
        // 弹出确认删除的对话框
        bool confirmDelete = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('确认删除'),
              content: Text('确定要删除吗？'),
              actions: [
                TextButton(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop(false); // 用户取消删除
                  },
                ),
                TextButton(
                  child: Text('确定'),
                  onPressed: () {
                    Navigator.of(context).pop(true); // 用户确认删除
                  },
                ),
              ],
            );
          },
        );

        if (confirmDelete == true) {
          // 执行删除操作的代码
          delBook(bookId, bookName);
        } else {
          // 取消删除操作
          loadBookshelf();
        }
      },
      child: InkWell(
        onTap: () {
          clickBookShelfItem(
            source,
            bookId,
            bookName,
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
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
                    SizedBox(
                      width: 270,
                      child: Text(
                        '最新章节：$bookLastChapterName',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    SizedBox(
                      width: 270,
                      child: Text(
                        '当前进度：$readLastChapterName',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
