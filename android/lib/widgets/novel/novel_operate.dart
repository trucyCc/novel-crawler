import 'package:android/helper/datebase_helper.dart';
import 'package:android/model/bookshelf_item.dart';
import 'package:android/utils/show_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/search_provider.dart';

class NovelOperate extends ConsumerStatefulWidget {
  const NovelOperate({Key? key, required this.bookInfo}) : super(key: key);

  final dynamic bookInfo;

  @override
  ConsumerState<NovelOperate> createState() => _NovelOperateState();
}

class _NovelOperateState extends ConsumerState<NovelOperate> {
  bool addBookshelfStatus = false;
  bool saveLoading = false;
  bool delLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      saveLoading = true;
    });

    initAddBookButton();
  }

  void initAddBookButton() async {
    final searchResult = ref.read(searchProvider.notifier).getSearchResult();
    final searchBookInfo = searchResult.resultData
        .firstWhere((el) => el['name'] == widget.bookInfo['name']);
    final book = await DatabaseHelper.searchBookByIdAndName(
        searchBookInfo['id'], widget.bookInfo['name']);
    // 这本书不在书架
    if (book == null) {
      setState(() {
        saveLoading = false;
      });
      return;
    }

    setState(() {
      saveLoading = false;
      addBookshelfStatus = true;
    });
  }

  void addBookInBookShelf() async {
    setState(() {
      saveLoading = true;
    });
    final searchResult = ref.read(searchProvider.notifier).getSearchResult();
    final source = searchResult.source;
    final searchBookInfo = searchResult.resultData
        .firstWhere((el) => el['name'] == widget.bookInfo['name']);

    await DatabaseHelper.saveBook(
      BookShelfItem(
        coverUrl: widget.bookInfo['coverUrl'],
        bookName: widget.bookInfo['name'],
        source: source,
        bookId: searchBookInfo['id'],
        bookLastChapterName: searchBookInfo['lastChapterName'],
        chapterId: widget.bookInfo['chapters'][0]['id'],
        readLastChapterUrl: widget.bookInfo['chapters'][0]['url'],
        readLastChapterName: widget.bookInfo['chapters'][0]['name'],
      ),
    );

    setState(() {
      saveLoading = false;
      addBookshelfStatus = true;
    });
    ShowBar.showTopicSnackBar(context, '已加入书架');
  }

  void delBookInBookShelf() async {
    setState(() {
      delLoading = true;
    });

    final searchResult = ref.read(searchProvider.notifier).getSearchResult();
    final searchBookInfo = searchResult.resultData
        .firstWhere((el) => el['name'] == widget.bookInfo['name']);
    await DatabaseHelper.delBook(searchBookInfo['id'], widget.bookInfo['name']);

    ShowBar.showErrorSnackBar(context, '已经从当前书架移除');

    setState(() {
      delLoading = false;
      addBookshelfStatus = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            if (saveLoading || delLoading) {
              return;
            }

            if (addBookshelfStatus) {
              delBookInBookShelf();
            }

            if (!addBookshelfStatus) {
              addBookInBookShelf();
            }
          },
          child: addBookshelfStatus
              ? delLoading
                  ? const SizedBox(
                      width: 13,
                      height: 13,
                      child: CircularProgressIndicator(),
                    )
                  : const Text(
                      '移除',
                      style: TextStyle(color: Colors.red),
                    )
              : saveLoading
                  ? const SizedBox(
                      width: 13,
                      height: 13,
                      child: CircularProgressIndicator(),
                    )
                  : const Text('加入书架'),
        ),
      ],
    );
  }
}
