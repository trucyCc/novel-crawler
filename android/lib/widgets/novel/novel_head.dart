import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NovelHead extends ConsumerWidget {
  const NovelHead({
    Key? key,
    required this.name,
    required this.coverUrl,
    required this.author,
    required this.intro,
  }) : super(key: key);

  final String name;
  final String coverUrl;
  final String author;
  final String intro;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 17.0, left: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            coverUrl,
            width: 130,
            height: 160,
          ),
          const SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(author),
              const SizedBox(height: 8.0),
              const Text('简 介：'),
              SizedBox(
                width: 230,
                child: Text(intro, overflow: TextOverflow.ellipsis, maxLines: 3,),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
