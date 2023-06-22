import 'package:android/widgets/chapter/chapter_content.dart';
import 'package:android/widgets/chapter/chapter_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  Widget build(BuildContext context) {
    // 获取路由参数
    final routeParams =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    String? chapterName = routeParams['name'];
    chapterName ??= "No Chapter Name";

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
              chapterUrl: routeParams['url'],
              onUpdateShowConfigBar: updateShowConfigBar,
              textStyle: const TextStyle(color: Colors.black, fontSize: 23),
            ),
            if (showConfigBar) ChapterTopBar(chapterName: chapterName),
          ],
        ),
      ),
    );
  }
}
