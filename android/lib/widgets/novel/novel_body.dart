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

  // 跳转指定Novel
  void goToChapter(BuildContext context, Map<String, dynamic> chapter) {
    Navigator.pushNamed(
      context,
      '/novel/chapter',
      arguments: {
        "id": chapter['id'],
        "url": chapter['url'],
        "name": bookName,
      },
    );
  }

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
                goToChapter(context, item);
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
