import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ChapterContent extends ConsumerStatefulWidget {
  const ChapterContent({
    Key? key,
    required this.onUpdateShowConfigBar,
    required this.chapterUrl,
  }) : super(key: key);
  final Function onUpdateShowConfigBar;
  final String chapterUrl;

  @override
  ConsumerState<ChapterContent> createState() => _ChapterContentState();
}

class _ChapterContentState extends ConsumerState<ChapterContent> {
  final List<String> pages = [];

  // 加载状态
  bool showLoading = true;

  // 页数
  int currentPageIndex = 0;

  // Page页面控制器
  final PageController _pageController = PageController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 获取当前页面的内容，并压入pages
    loadData(widget.chapterUrl);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void loadData(String url) async {
    if(url.isEmpty) {
      showErrorSnackBar('请求失败！章节URL为空！请选择其他章节！');
      return;
    }

    // 发送请求获取书籍详细信息
    final responseFuture = await getChapterContent(url);

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

    print(jsonData['data']);

    final content = jsonData['htmlContent'];

    // 加载结束
    setState(() {
      showLoading = false;
    });
  }

  // 获取章节页面内容
  Future<http.Response> getChapterContent(chapterUrl) async {
    final queryParameters = {"url": chapterUrl};
    var url = Uri.http(dotenv.env['SERVER_HTTP']!, '/crawler/chapter');

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

  // 创建Content页面
  Widget buildPage(String page) {
    // 首先需要判断当前页面是不是一个带有标题的页面

    // 如果是带有标题的页面则先给一个标题，然后再显示内容

    // 如果不是，则直接显示内容

    return Container(
      alignment: Alignment.center,
      child: Text(
        page,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  // 页面点击事件
  void pageTopDown(TapDownDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tapX = details.globalPosition.dx;
    final centerLine = screenWidth / 2;

    print(pages.toString());

    var random = Random();
    setState(() {
      pages.add(random.nextInt(100).toString());
    });

    // 点击左侧，翻到上一页
    if (tapX < centerLine - 70) {
      if (currentPageIndex >= 0) {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }

    // 点击右侧，翻到下一页
    if (tapX > centerLine + 70) {
      if (currentPageIndex < pages.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }

    // 点击中心区域，唤出控制台
    if (tapX > centerLine - 80 && tapX < centerLine + 80) {
      widget.onUpdateShowConfigBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (TapDownDetails details) {
        pageTopDown(details);
      },
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPageIndex = 0;
                });
              },
              children: pages.map((page) => buildPage(page)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
