import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChapterTopBar extends ConsumerWidget {
  const ChapterTopBar({
    Key? key,
    required this.bookName,
  }) : super(key: key);
  final String bookName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
        ),
        child: AppBar(
          backgroundColor: Colors.yellow[100],
          elevation: 0,
          title: Text(bookName, style:const TextStyle(fontSize: 20),),
        ),
      ),
    );
  }
}
