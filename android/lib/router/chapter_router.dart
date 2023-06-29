

import 'package:flutter/material.dart';

class ChapterRouter{
  // 跳转指定Novel
  static void goToChapter(BuildContext context, Map<String, dynamic> chapter, String bookName) {
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
}