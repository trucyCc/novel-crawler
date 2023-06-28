import 'package:android/widgets/chapter/chapter_bottom_bar.dart';
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

  @override
  Widget build(BuildContext context) {
    // 获取路由参数
    final routeParams =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    String? bookName = routeParams['name'];
    bookName ??= "No Book Name";

    final chaptersCache = ref.watch(chapterProvider) as List<dynamic>;

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
              bookName:routeParams['name'],
              chapterId: routeParams['id'],
              chapterUrl: routeParams['url'],
              onUpdateShowConfigBar: updateShowConfigBar,
              textStyle: const TextStyle(color: Colors.black, fontSize: 23),
            ),
            if (showConfigBar)
              ChapterTopBar(
                bookName: bookName,
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
            if (isDrawerOpen) ChapterCatalogue(chapters: chaptersCache),
          ],
        ),
      ),
    );
  }
}
