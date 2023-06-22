import 'dart:convert';
import 'dart:io';

import 'package:android/provider/chapter_provider.dart';
import 'package:android/widgets/novel/novel_body.dart';
import 'package:android/widgets/novel/novel_head.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

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
    final responseFuture = await getNovelInfoApi(routeParams['url']);

    // 请求失败
    if (responseFuture.statusCode != 200) {
      showErrorSnackBar('请求错误，状态：${responseFuture.statusCode}');
      return;
    }

    // 解析数据
    final jsonData = json.decode(utf8.decode(responseFuture.bodyBytes));

    // 服务器错误
    if (jsonData['code'] != 200) {
      showErrorSnackBar('${jsonData['message']}');
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

  // 获取书籍详细信息
  Future<http.Response> getNovelInfoApi(novelUrl) async {
    final queryParameters = {"url": novelUrl};
    var url = Uri.http(dotenv.env['SERVER_HTTP']!, '/crawler/book');

    return await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
        HttpHeaders.acceptCharsetHeader: 'gzip'
      },
      body: Uri(queryParameters: queryParameters).query,
    );
  }

  // 底部弹出报错信息
  void showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      action: SnackBarAction(
        label: 'X',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
          title: const Text('详情'),
        ),
        body: bodyWidget);
  }
}
