import 'package:android/model/search.dart';
import 'package:android/provider/search_provider.dart';
import 'package:android/widgets/home/home_search.dart';
import 'package:android/widgets/home/home_search_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final searchModel = ref.watch(searchProvider) as SearchModel;
    final searchResult = searchModel.resultData;
    final searchBool = searchResult.isNotEmpty;

    return SafeArea(
      child: Scaffold(
        body: Column(
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
                          url: item['url']
                      ),
                    );
                  },
                ),
              ),
            if (searchBool) const Text("仅显示前50条，请输入更详细的搜索条件，缩写搜索范围.")
          ],
        ),
      ),
    );
  }
}
