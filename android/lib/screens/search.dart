import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/search.dart';
import '../provider/search_provider.dart';
import '../widgets/home/home_search.dart';
import '../widgets/home/home_search_item.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final searchModel = ref.watch(searchProvider) as SearchModel;
    final searchResult = searchModel.resultData;
    final searchBool = searchResult.isNotEmpty;

    return Column(
      mainAxisAlignment:
          searchBool ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: HomeSearchWidget(),
        ),
        if (searchBool)
          Expanded(
            child: ListView.builder(
              itemCount: searchResult.length, // 假设有100个列表项
              itemBuilder: (context, index) {
                final item = searchResult[index];
                return ListTile(
                  title: HomeSearchItem(
                      id: item['id'],
                      title: item['name'],
                      author: item['author'],
                      status: item['status'],
                      lastChapterName: item['lastChapterName'],
                      lastUpdateTime: item['lastUpdateTime'],
                      wordCount: item['wordCount'],
                      url: item['url']),
                );
              },
            ),
          ),
        if (searchBool) const Text("仅显示前50条，请输入更详细的搜索条件，缩写搜索范围.")
      ],
    );
  }
}
