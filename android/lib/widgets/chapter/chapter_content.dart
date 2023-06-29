import 'dart:convert';
import 'dart:ui';

import 'package:android/api/chapter_api.dart';
import 'package:android/provider/chapter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../helper/datebase_helper.dart';
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
  final String bookName;

  const ChapterContent({
    Key? key,
    required this.onUpdateShowConfigBar,
    required this.chapterUrl,
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 30,
    ),
    required this.chapterId,
    required this.bookName,
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

  String chapterName = "";
  String chapterUrl = "";
  late ChapterPositionItem currentChapterPosition;
  List<ChapterPositionItem> chapterPositionList = [];
  int chapterCurrentCriticalStart = 0; // 章节当前临界开始
  int chapterCurrentCriticalEnd = 0; // 章节当前临界结束

  int cacheCurrentPageIndex = 0;

  int currentChapterPageLength = 1;
  int currentChapterPageOverAllLength = 0;

  bool addBookShelf = false;

  String bookId = '';

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: cacheCurrentPageIndex);
    initBookMessage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 初次加载数据
    loadData(widget.chapterUrl, Direction.next);
  }

  void initBookMessage() async {
    final searchResult = ref.read(searchProvider.notifier).getSearchResult();
    if (widget.bookName.isEmpty) return;
    final searchBookInfo = searchResult.resultData
        .firstWhere((el) => el['name'] == widget.bookName);
    final book = await DatabaseHelper.searchBookByIdAndName(
        searchBookInfo['id'], widget.bookName);

    bookId = searchBookInfo['id'];

    if (book == null) {
      setState(() {
        addBookShelf = false;
      });
      return;
    }

    setState(() {
      addBookShelf = true;
    });
  }

  bool initBookShelfItemMessage = false;

  void editBookShelf(String chapterName, String chapterUrl) async {
    await DatabaseHelper.updateBookShelfItemByIdAndName(
      bookId,
      widget.bookName,
      chapterName.replaceAll("_", "").replaceAll(widget.bookName, ""),
      chapterUrl,
    );
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

      chapterPositionList.add(
        ChapterPositionItem(
          chapterName: jsonData['data']['name'],
          startIndex: pages.length - tempPage.length,
          endIndex: pages.length - 1,
          length: tempPage.length,
          chapterUrl: jsonData['data']['url'],
        ),
      );

      if (chapterName.isEmpty) {
        setState(() {
          chapterName = jsonData['data']['name'];
          chapterUrl = jsonData['data']['url'];
          editBookShelf(chapterName, chapterUrl);
          currentChapterPageOverAllLength = tempPage.length;
          currentChapterPageLength = 1;
        });
        currentChapterPosition = ChapterPositionItem(
          chapterName: jsonData['data']['name'],
          startIndex: pages.length - tempPage.length,
          endIndex: pages.length - 1,
          length: tempPage.length,
          chapterUrl: jsonData['data']['url'],
        );
      }

      bolLoadingNextPage = true;
    }

    // 如果是上一页，追加到前面
    if (direction == Direction.prev) {
      cacheCurrentPageIndex = currentPageIndex;
      setState(() {
        pages.insertAll(0, tempPage);
        currentPageIndex = tempPageSize;
      });

      chapterPositionList.insert(
        0,
        ChapterPositionItem(
          chapterUrl: jsonData['data']['url'],
          chapterName: jsonData['data']['name'],
          startIndex: 0,
          endIndex: tempPage.length - 1,
          length: tempPage.length,
        ),
      );
      for (int i = 1; i < chapterPositionList.length; i++) {
        final chapterPosition = chapterPositionList[i];
        chapterPosition.startIndex =
            tempPage.length + chapterPosition.startIndex;
        chapterPosition.endIndex = tempPage.length + chapterPosition.endIndex;
        chapterPositionList[i] = chapterPosition;
      }

      if (cacheCurrentPageIndex == 0) {
        currentChapterPosition = ChapterPositionItem(
          chapterName: jsonData['data']['name'],
          startIndex: 0,
          endIndex: tempPage.length - 1,
          length: tempPage.length,
          chapterUrl: jsonData['data']['url'],
        );

        setState(() {
          chapterName = jsonData['data']['name'];
          chapterUrl = jsonData['data']['url'];
          editBookShelf(chapterName, chapterUrl);
          currentChapterPageOverAllLength = tempPage.length;
          currentChapterPageLength = tempPage.length;
        });
      } else {
        currentChapterPosition = chapterPositionList.firstWhere((el) =>
            el.chapterName == currentChapterPosition.chapterName &&
            el.length == currentChapterPosition.length);
      }

      _pageController.jumpToPage(tempPageSize + cacheCurrentPageIndex - 1);
      bolLoadingPrefPage = true;
    }

    setState(() {
      showLoading = false;
    });

    if (!initBookShelfItemMessage) {
      editBookShelf(chapterName, chapterUrl);
    }

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

  // 创建Content页面
  Widget buildPage(String page) {
    return Text(
      page,
      style: TextStyle(fontSize: widget.textStyle.fontSize),
    );
  }

  bool bolLoadingPrefPage = true;
  bool bolLoadingNextPage = true;

  // 页面点击事件
  void pageTopDown(TapDownDetails details) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final tapX = details.globalPosition.dx;
    final centerLine = screenWidth / 2;

    // 点击左侧，翻到上一页
    if (tapX < centerLine - 70) {
      if (currentPageIndex >= 0) {
        if ((currentPageIndex - 1) <= 0 && bolLoadingPrefPage) {
          bolLoadingPrefPage = false;
          setState(() {
            showLoading = true;
          });
          await loadingPrePage();
          setState(() {
            showLoading = false;
          });
          return;
        }

        // 当前页等于最小页面
        if ((currentPageIndex - 4) <= 0 && bolLoadingPrefPage) {
          bolLoadingPrefPage = false;
          loadingPrePage();
        }

        _pageController.previousPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );

        setState(() {
          currentChapterPageLength -= 1;
        });

        if (currentPageIndex <= currentChapterPosition.startIndex) {
          final lastChapterPositionIndex = chapterPositionList.indexWhere(
                  (el) =>
                      currentChapterPosition.chapterName == el.chapterName &&
                      currentChapterPosition.startIndex == el.startIndex) -
              1;
          if (lastChapterPositionIndex >= 0) {
            final lastChapterPosition =
                chapterPositionList[lastChapterPositionIndex];
            setState(() {
              chapterName = lastChapterPosition.chapterName;
              chapterUrl = lastChapterPosition.chapterUrl;
              editBookShelf(chapterName, chapterUrl);
              currentChapterPosition = lastChapterPosition;
              currentChapterPageOverAllLength = currentChapterPosition.length;
              currentChapterPageLength = currentChapterPosition.length;
            });
          }
        }
      }
    }

    // 点击右侧，翻到下一页
    if (tapX > centerLine + 70) {
      if (currentPageIndex <= pages.length - 1) {
        if (currentPageIndex <= pages.length - 4 && bolLoadingNextPage) {
          bolLoadingNextPage = false;
          loadingNextPage();
        }

        if (currentPageIndex == pages.length - 1 && bolLoadingNextPage) {
          bolLoadingNextPage = false;
          setState(() {
            showLoading = true;
          });
          await loadingNextPage();
          setState(() {
            showLoading = false;
          });
        }

        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );

        setState(() {
          currentChapterPageLength += 1;
        });

        // 判断current是否超过了当前的endIndex
        if (currentPageIndex > currentChapterPosition.endIndex - 1) {
          final lastChapterPositionIndex = chapterPositionList.indexWhere(
                  (el) =>
                      currentChapterPosition.chapterName == el.chapterName &&
                      currentChapterPosition.startIndex == el.startIndex) +
              1;
          if (lastChapterPositionIndex != -1) {
            final lastChapterPosition =
                chapterPositionList[lastChapterPositionIndex];
            setState(() {
              chapterName = lastChapterPosition.chapterName;
              chapterUrl = lastChapterPosition.chapterUrl;
              editBookShelf(chapterName, chapterUrl);
              currentChapterPosition = lastChapterPosition;
              currentChapterPageOverAllLength = currentChapterPosition.length;
              currentChapterPageLength = 1;
            });
          }
        }
      }
    }

    // 点击中心区域，唤出控制台
    if (tapX > centerLine - 80 && tapX < centerLine + 80) {
      widget.onUpdateShowConfigBar();
    }
  }

  Future<List<String>?> loadingPrePage() async {
    if (currentPrevPageIndex == 0) {
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

    if ((chapterIndex - currentPrevPageIndex) < 0 && currentPageIndex == 0) {
      ShowBar.showErrorSnackBar(context, "没有上一章节了");
      setState(() {
        showLoading = false;
      });
      return null;
    }

    if ((chapterIndex - currentPrevPageIndex) < 0) {
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

    if ((chapterIndex + currentNextPageIndex) >= chaptersCache.length &&
        currentPageIndex == pages.length) {
      ShowBar.showErrorSnackBar(context, "这已经 是最后章了");
      setState(() {
        showLoading = false;
      });
      return null;
    }

    if ((chapterIndex + currentNextPageIndex) >= chaptersCache.length) {
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
                  if (!showLoading)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 30,
                        // color: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            '$currentChapterPageLength / $currentChapterPageOverAllLength',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
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
