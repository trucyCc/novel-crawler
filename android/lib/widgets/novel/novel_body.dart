import 'package:android/router/chapter_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NovelBody extends ConsumerWidget {
  const NovelBody({
    Key? key,
    required this.chapters,
    required this.bookName,
  }) : super(key: key);

  final List<dynamic> chapters;
  final String bookName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 9.0),
      child: ListView.builder(
          itemCount: chapters.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> item = chapters[index];
            return TextButton(
              onPressed: () {
                ChapterRouter.goToChapter(context, item, bookName);
              },
              child: Text(
                '${item['name']}',
                style: const TextStyle(color: Colors.black),
              ),
            );
          }),
    );
  }
}
