import 'package:android/api/novel_api.dart';
import 'package:android/api/search_api.dart';
import 'package:android/router/chapter_router.dart';
import 'package:android/utils/show_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  bool isLoading = false;

  void clickBookShelfItem(
    String source,
    String bookId,
    String chapterId,
    String bookName,
  ) async {
    print(source);
    print(bookId);
    print(chapterId);
    print(bookName);

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
    print('resultBook: $resultBook');

    // 从源获取Book
    final bookJsonData = await NovelApi.getNovelInfoApi(
        context, source, resultBook['url'], ShowBar.showErrorSnackBar);
    if (bookJsonData == null) {
      return;
    }
    print('searchBookJson: $bookJsonData');

    final chapters = bookJsonData['data']['chapters'] as List<dynamic>;
    ref.read(chapterProvider.notifier).updateChapters(chapters);
    final chapter = chapters.firstWhere((ch) => ch['id'] == chapterId);

    ChapterRouter.goToChapter(context, chapter, resultBook['name']);

    // 跳转章节页面
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "书 架",
          style: TextStyle(),
          textAlign: TextAlign.center,
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: 100,
            itemBuilder: (context, index) {
              return BookshelfItemWidget(
                source: "ibiqu",
                bookId: "160_160607",
                chapterId: "182992296",
                coverUrl:
                    "http://r.m.ibiqu.org/cover/aHR0cDovL2Jvb2tjb3Zlci55dWV3ZW4uY29tL3FkYmltZy8zNDk1NzMvMTAzMzczMzY0Ni8xODA=",
                bookName: "诡道修仙游戏",
                readLastChapterUrl:
                    "http://www.ibiqu.org/160_160607/182992296.html",
                readLastChapterName: "第一章 圣经永流传",
                bookLastChapterName: "第一百四十九章 新的起点",
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
