import 'package:android/widgets/chapter/chapter_content.dart';
import 'package:android/widgets/chapter/chapter_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/chapter_provider.dart';
import '../widgets/chapter/chapter_catalogue.dart';

class ChapterScreen extends ConsumerStatefulWidget {
  const ChapterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends ConsumerState<ChapterScreen> {
  bool showConfigBar = false;
  Map<String, dynamic> chapterData = {};

  bool initRoutParams = true;

  String bookNameRouteParam = "";
  String chapterIdRouteParam = "";
  String chapterUrlRouteParam = "";

  Key refreshChapterContentKey = GlobalKey();

  void updateShowConfigBar() {
    setState(() {
      showConfigBar = !showConfigBar;
    });
  }

  bool isDrawerOpen = false;

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
  }

  void refreshChapter(Map<String, dynamic> chapter, String bookName) {
    setState(() {
      isDrawerOpen = false;
      bookNameRouteParam = bookName;
      chapterIdRouteParam = chapter['id'];
      chapterUrlRouteParam = chapter['url'];
      refreshChapterContentKey = GlobalKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chaptersCache = ref.watch(chapterProvider) as List<dynamic>;

    if (initRoutParams) {
      final routeParams =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

      bookNameRouteParam = routeParams['name'];
      chapterIdRouteParam = routeParams['id'];
      chapterUrlRouteParam = routeParams['url'];
      initRoutParams = false;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          showConfigBar = !showConfigBar;
        });
      },
      child: Scaffold(
        body: Stack(
          children: [
            ChapterContent(
              key: refreshChapterContentKey,
              bookName: bookNameRouteParam,
              chapterId: chapterIdRouteParam,
              chapterUrl: chapterUrlRouteParam,
              onUpdateShowConfigBar: updateShowConfigBar,
              textStyle: const TextStyle(color: Colors.black, fontSize: 23),
            ),
            if (showConfigBar)
              ChapterTopBar(
                bookName: bookNameRouteParam,
                chapters: chaptersCache,
                toggleDrawer: toggleDrawer,
              ),
            // if(showConfigBar)
            //   ChapterConfigBottom(),
            // 打开目录
            if (isDrawerOpen)
              GestureDetector(
                onTap: () {
                  toggleDrawer();
                },
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            if (isDrawerOpen)
              ChapterCatalogue(
                chapters: chaptersCache,
                bookName: bookNameRouteParam,
                refreshChapter: refreshChapter,
              ),
          ],
        ),
      ),
    );
  }
}
