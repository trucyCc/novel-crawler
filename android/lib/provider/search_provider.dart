import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchNotifier extends StateNotifier<List< dynamic>> {
  SearchNotifier() : super([]);

  void updateSearchResult(List<dynamic> newResult) {
    state = newResult;
  }
}

final searchProvider = StateNotifierProvider((ref) => SearchNotifier());