import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookshelfItemWidget extends ConsumerWidget {
  const BookshelfItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2, // 设置卡片的阴影
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // 设置卡片的圆角
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
