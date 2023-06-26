import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/bookshelf/bookshelf_item.dart';

class BookShelfScreen extends ConsumerStatefulWidget {
  const BookShelfScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BookShelfScreen> createState() => _BookShelfScreenState();
}

class _BookShelfScreenState extends ConsumerState<BookShelfScreen> {
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
      body: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, index) {
            return BookshelfItemWidget(
              coverUrl: "",
              bookName: "",
              readLastChapterUrl: "",
              readLastChapterName: "",
              bookLastChapterName: ""
            );
          }),
    );
  }
}
