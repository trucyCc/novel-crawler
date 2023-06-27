import 'dart:convert';
import 'dart:ui';

import 'package:android/api/chapter_api.dart';
import 'package:android/provider/chapter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/chapter_position_item.dart';
import '../../provider/search_provider.dart';
import '../../utils/show_bar.dart';

enum Direction {
  next,
  prev,
}

class ChapterContent extends ConsumerStatefulWidget {
  final Function onUpdateShowConfigBar;
  final String chapterUrl;
  final TextStyle textStyle;
  final String chapterId;

  const ChapterContent({
    Key? key,
    required this.onUpdateShowConfigBar,
    required this.chapterUrl,
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 30,
    ),
    required this.chapterId,
  }) : super(key: key);

  @override
  ConsumerState<ChapterContent> createState() => _ChapterContentState();
}

class _ChapterContentState extends ConsumerState<ChapterContent> {
  final List<String> pages = []; // 页面列表
  bool showLoading = true; // 加载状态
  int currentPageIndex = 0; // 当前页数
  final _pageKey = GlobalKey(); // text size 计算容器
  late PageController _pageController; // Page页面控制器
  int currentPrevPageIndex = 1; // 上一页
  int currentNextPageIndex = 1; // 下一页

  String chapterName = "第一章 圣经永流传_诡道修仙游戏";
  List<ChapterPositionItem> chapterPositionList = [];

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: currentPageIndex);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 获取当前页面的内容，并压入pages
    loadData(widget.chapterUrl, Direction.next);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<List<String>> loadData(String url, Direction direction) async {
    if (currentPageIndex == pages.length - 4 || currentNextPageIndex == 0) {
      setState(() {
        showLoading = true;
      });
    }
    if (url.isEmpty) {
      ShowBar.showErrorSnackBar(context, '请求失败！章节URL为空！请选择其他章节！');
      return [];
    }

    // 发送请求获取书籍详细信息
    final source = ref.read(searchProvider.notifier).getSearchResult().source;
    final responseFuture = await ChapterApi.getChapterContent(source, url);

    // 请求失败
    if (responseFuture.statusCode != 200) {
      ShowBar.showErrorSnackBar(
          context, '请求错误，状态：${responseFuture.statusCode}');
      return [];
    }

    // 解析数据
    final jsonData = json.decode(utf8.decode(responseFuture.bodyBytes));

    // 服务器错误
    if (jsonData['code'] != 200) {
      ShowBar.showErrorSnackBar(context, '${jsonData['message']}');
      return [];
    }
    String chapterContent = jsonData['data']['htmlContent'].toString();

    chapterContent =
        chapterContent.replaceAll("<p>", "\n").replaceAll("</p>", "");

    final tempPage = _paginate(chapterContent);

    // 新添加的页面长度
    final tempPageSize = tempPage.length;

    // 如果是下一页，直接追加，当前页不变
    if (direction == Direction.next) {
      setState(() {
        pages.addAll(tempPage);
      });
    }

    // 如果是上一页，追加到前面
    if (direction == Direction.prev) {
      setState(() {
        pages.insertAll(0, tempPage);
        currentPageIndex = tempPageSize;
      });

      _pageController.jumpToPage((currentPageIndex - 1));
    }

    setState(() {
      showLoading = false;
    });

    return tempPage;
  }

  // 分页
  List<String> _paginate(String longText) {
    // 获取页面尺寸
    // 获取当前Widget尺寸
    final pageSize =
        (_pageKey.currentContext?.findRenderObject() as RenderBox).size;

    final List<String> tempPages = [];

    // 使用textPainter进行分页
    final textSpan = TextSpan(
      text: longText,
      style: TextStyle(
        color: widget.textStyle.color,
        fontSize: widget.textStyle.fontSize,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: pageSize.width,
    );

    // https://medium.com/swlh/flutter-line-metrics-fd98ab180a64
    // 每个LineMetrics表示文本的一行，可以获取行的信息
    List<LineMetrics> lines = textPainter.computeLineMetrics();
    double currentPageBottom = pageSize.height - 30;
    int currentPageStartIndex = 0;
    int currentPageEndIndex = 0;

    // 遍历每一行
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      final left = line.left;
      final top = line.baseline - line.ascent;
      final bottom = line.baseline + line.descent;

      // Current line overflow page
      if (currentPageBottom < bottom) {
        // https://stackoverflow.com/questions/56943994/how-to-get-the-raw-text-from-a-flutter-textbox/56943995#56943995
        currentPageEndIndex =
            textPainter.getPositionForOffset(Offset(left, top)).offset;
        final pageText =
            longText.substring(currentPageStartIndex, currentPageEndIndex);
        tempPages.add(pageText);

        currentPageStartIndex = currentPageEndIndex;
        currentPageBottom = top + pageSize.height - 30;
      }
    }

    final lastPageText = longText.substring(currentPageStartIndex);
    tempPages.add(lastPageText);

    return tempPages;
  }

  void showWarningSnackBar(String message) {
    final snackBar = SnackBar(
      duration: const Duration(milliseconds: 600),
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
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
    return Container(
      child: Text(
        page,
        style: TextStyle(fontSize: widget.textStyle.fontSize),
      ),
    );
  }

  // 页面点击事件
  void pageTopDown(TapDownDetails details) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final tapX = details.globalPosition.dx;
    final centerLine = screenWidth / 2;

    // 点击左侧，翻到上一页
    if (tapX < centerLine - 70) {
      if (currentPageIndex >= 0) {
        // 当前页等于最小页面
        if ((currentPageIndex - 4) <= 0) {
          await loadingPrePage();
        } else {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    }

    // 点击右侧，翻到下一页
    if (tapX > centerLine + 70) {
      if (currentPageIndex <= pages.length - 4) {
        // 当前页等于最大页面
        if (currentPageIndex <= pages.length - 4) {
          await loadingNextPage();
        }

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

  Future<List<String>?> loadingPrePage() async {
    if (currentNextPageIndex == 0) {
      setState(() {
        showLoading = true;
      });
    }

    // 获取当前书籍在 provider cache 中的位置
    final chaptersCache = ref.watch(chapterProvider) as List<dynamic>;
    int chapterIndex =
        chaptersCache.indexWhere((ch) => ch['id'] == widget.chapterId);
    if (chapterIndex == -1) {
      ShowBar.showErrorSnackBar(context, "章节错误，请重新搜索书籍");
      setState(() {
        showLoading = false;
      });
      return null;
    }

    if ((chapterIndex - currentPrevPageIndex) < 0) {
      showWarningSnackBar("没有上一章节了");
      setState(() {
        showLoading = false;
      });
      return null;
    }

    // 上一章的位置是
    int prevChapterIndex = chapterIndex - currentPrevPageIndex;
    currentPrevPageIndex = currentPrevPageIndex + 1;
    Map<String, dynamic> chapterCache = chaptersCache[prevChapterIndex];

    return await loadData(chapterCache['url'], Direction.prev);
  }

  Future<List<String>?> loadingNextPage() async {
    if (currentPageIndex == pages.length - 1) {
      setState(() {
        showLoading = true;
      });
    }

    // 获取当前书籍在 provider cache 中的位置
    final chaptersCache = ref.watch(chapterProvider) as List<dynamic>;
    int chapterIndex =
        chaptersCache.indexWhere((ch) => ch['id'] == widget.chapterId);
    if (chapterIndex == -1) {
      ShowBar.showErrorSnackBar(context, "章节错误，请重新搜索书籍");
      setState(() {
        showLoading = false;
      });
      return null;
    }

    if ((chapterIndex + currentNextPageIndex) >= chaptersCache.length) {
      showWarningSnackBar("这已经是最后章了");
      setState(() {
        showLoading = false;
      });
      return null;
    }

    // 下一章的位置是
    int nextChapterIndex = chapterIndex + currentNextPageIndex;
    currentNextPageIndex = currentNextPageIndex + 1;
    Map<String, dynamic> chapterCache = chaptersCache[nextChapterIndex];

    return await loadData(chapterCache['url'], Direction.next);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.yellow[100],
          child: SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (TapDownDetails details) {
                pageTopDown(details);
              },
              child: Stack(
                children: [
                  SizedBox(
                    height: 30,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        chapterName,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox.expand(
                            key: _pageKey,
                            child: PageView(
                              controller: _pageController,
                              onPageChanged: (index) {
                                currentPageIndex = index;
                              },
                              children:
                                  pages.map((page) => buildPage(page)).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (showLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
