import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeSearchItem extends ConsumerWidget {
  const HomeSearchItem(
      {Key? key,
      required this.id,
      required this.title,
      required this.author,
      required this.status,
      required this.lastChapterName,
      required this.lastUpdateTime,
      required this.url,
      required this.wordCount})
      : super(key: key);
  final String id;
  final String title;
  final String author;
  final String status;
  final String lastChapterName;
  final String lastUpdateTime;
  final String wordCount;
  final String url;

  // 跳转指定Novel
  void goToNovel(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/novel',
      arguments: {
        "id": id,
        "url": url,
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        goToNovel(context);
      },
      child: Card(
        elevation: 2, // 设置卡片的阴影
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // 设置卡片的圆角
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '书 名：$title',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '状 态：$status',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '作 者：$author',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '字 数：$wordCount',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '最新章节：$lastChapterName',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '最后更新时间：$lastUpdateTime',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
