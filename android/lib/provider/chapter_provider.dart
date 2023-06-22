import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChapterNotifier extends StateNotifier<List< dynamic>> {
  ChapterNotifier() : super([]);

  void updateChapters(List<dynamic> newResult) {
    state = newResult;
  }
}

final chapterProvider = StateNotifierProvider((ref) => ChapterNotifier());