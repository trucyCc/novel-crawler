import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/search.dart';

class SearchNotifier extends StateNotifier<SearchModel> {
  SearchNotifier(super.state);

  void updateSearchResult(SearchModel searchModel) {
    state = searchModel;
  }
  
  SearchModel getSearchResult() {
    return state;
  }
}

final searchProvider = StateNotifierProvider(
    (ref) => SearchNotifier(SearchModel(source: '', resultData: [])));
