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
    return GestureDetector(
      onTap: () {
        setState(() {
          showConfigBar = !showConfigBar;
        });
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.yellow[100],
              child: ChapterContent(
                onUpdateShowConfigBar: updateShowConfigBar,
              ),
            ),
            if (showConfigBar) const ChapterTopBar(chapterName: "Chapter Name"),
          ],
        ),
      ),
    );
  }
}
