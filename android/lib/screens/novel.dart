import 'package:android/api/novel_api.dart';
import 'package:android/provider/chapter_provider.dart';
import 'package:android/provider/search_provider.dart';
import 'package:android/utils/show_bar.dart';
import 'package:android/widgets/novel/novel_body.dart';
import 'package:android/widgets/novel/novel_head.dart';
import 'package:android/widgets/novel/novel_operate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NovelScreen extends ConsumerStatefulWidget {
  const NovelScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NovelScreen> createState() => _NovelScreenState();
}

class _NovelScreenState extends ConsumerState<NovelScreen> {
  bool pageLoading = true;
  Map novelInfo = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  // 数据初始化
  void loadData() async {
    // 获取路由参数
    final routeParams =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    // 发送请求获取书籍详细信息
    final source = ref.read(searchProvider.notifier).getSearchResult().source;
    final jsonData = await NovelApi.getNovelInfoApi(
        context, source, routeParams['url'], ShowBar.showErrorSnackBar);
    if (jsonData == null) {
      return;
    }

    ref
        .read(chapterProvider.notifier)
        .updateChapters(jsonData['data']['chapters']);

    // 加载结束
    setState(() {
      novelInfo = jsonData['data'];
      pageLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget = const Center(
      child: CircularProgressIndicator(),
    );

    if (!pageLoading) {
      bodyWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: NovelHead(
              name: novelInfo['name'],
              coverUrl: novelInfo['coverUrl'],
              author: novelInfo['author'],
              intro: novelInfo['intro'],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20.0, left: 8.0),
            child: Row(
              children: [
                SizedBox(
                  child: Center(
                    child: Text(
                      "目 录",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            flex: 3,
            child: NovelBody(
              bookName: novelInfo['name'],
              chapters: novelInfo['chapters'],
            ),
          ),
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // 后退操作
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('详情'),
              if (!pageLoading)
                NovelOperate(
                  bookInfo: novelInfo,
                ),
            ],
          ),
        ),
        body: bodyWidget);
  }
}
