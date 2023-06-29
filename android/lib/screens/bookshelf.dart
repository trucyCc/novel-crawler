import 'package:android/api/novel_api.dart';
import 'package:android/api/search_api.dart';
import 'package:android/helper/datebase_helper.dart';
import 'package:android/router/chapter_router.dart';
import 'package:android/utils/show_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/bookshelf_item.dart';
import '../model/search.dart';
import '../provider/chapter_provider.dart';
import '../provider/search_provider.dart';
import '../widgets/bookshelf/bookshelf_item.dart';

class BookShelfScreen extends ConsumerStatefulWidget {
  const BookShelfScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BookShelfScreen> createState() => _BookShelfScreenState();
}

class _BookShelfScreenState extends ConsumerState<BookShelfScreen> {
  bool isLoading = true;
  bool bookIsEmpty = false;
  List<BookShelfItem> bookShelfItem = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initBookShelf();
  }

  void initBookShelf() async {
    final books = await DatabaseHelper.loadBooks();
    if (books.isEmpty) {
      setState(() {
        isLoading = false;
        bookIsEmpty = true;
        bookShelfItem = books;
      });
      return;
    }

    setState(() {
      bookShelfItem.clear();
      bookShelfItem.addAll(books);
      isLoading = false;
    });
  }

  void clickBookShelfItem(
    String source,
    String bookId,
    String bookName,
  ) async {
    setState(() {
      isLoading = true;
    });

    // 从源查询书籍
    final searchJson = await SearchApi.getSearchApi(
        context, source, bookName, ShowBar.showErrorSnackBar);
    if (searchJson == null) {
      return;
    }
    final searchResult = SearchModel(
      source: source,
      resultData: searchJson['data'],
    );
    ref.read(searchProvider.notifier).updateSearchResult(searchResult);

    // 遍历查询结果获取bookUrl
    final resultBook =
        searchResult.resultData.firstWhere((data) => data['id'] == bookId);

    // 从源获取Book
    final bookJsonData = await NovelApi.getNovelInfoApi(
        context, source, resultBook['url'], ShowBar.showErrorSnackBar);
    if (bookJsonData == null) {
      return;
    }

    final item = bookShelfItem.firstWhere((el) => el.bookId == bookId);
    final chapters = bookJsonData['data']['chapters'] as List<dynamic>;
    ref.read(chapterProvider.notifier).updateChapters(chapters);

    try {
      final chapter =
          chapters.firstWhere((ch) => ch['name'] == item.readLastChapterName);
      ChapterRouter.goToChapter(context, chapter, resultBook['name']);
    } catch (e) {
      ShowBar.showTopicSnackBar(context, '没有找到指定章节！');
    }

    // 跳转章节页面
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "书 架",
              style: TextStyle(),
              textAlign: TextAlign.center,
            ),
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          bookIsEmpty
              ? const Center(
                  child: Text("当前书架没有书籍，请去搜索书籍加入吧"),
                )
              : ListView.builder(
                  itemCount: bookShelfItem.length,
                  itemBuilder: (context, index) {
                    final shelfItem = bookShelfItem[index];
                    return BookshelfItemWidget(
                      source: shelfItem.source,
                      bookId: shelfItem.bookId,
                      coverUrl: shelfItem.coverUrl,
                      bookName: shelfItem.bookName,
                      readLastChapterUrl: shelfItem.readLastChapterUrl,
                      readLastChapterName: shelfItem.readLastChapterName,
                      bookLastChapterName: shelfItem.bookLastChapterName,
                      clickBookShelfItem: clickBookShelfItem,
                    );
                  },
                ),
          if (isLoading)
            // 蒙版
            Container(
              color: Colors.black.withOpacity(0.5),
            ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            ),
        ],
      ),
    );
  }
}
