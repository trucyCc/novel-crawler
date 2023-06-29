import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChapterCatalogue extends ConsumerWidget {
  const ChapterCatalogue(
      {Key? key,
      required this.chapters,
      required this.bookName,
      required this.refreshChapter})
      : super(key: key);
  final List<dynamic> chapters;
  final String bookName;
  final Function refreshChapter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return (chapters.length > 0)
        ? Drawer(
            child: Container(
              // color: Colors.yellow[100],
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      height: 56,
                      // 设置高度为一行的高度
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Text(
                        '目 录',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: chapters.length,
                        itemBuilder: (context, index) {
                          final chapter = chapters[index];
                          return InkWell(
                            onTap: () {
                              print("点击目录 ${chapter}");
                              refreshChapter(chapter, bookName);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                chapter['name'],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : const Center(
            child: Text(
              '抱歉，没有加载到目录',
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }
}
