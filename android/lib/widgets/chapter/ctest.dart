import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

const sampleText = '''
Flutter is an open-source UI software development kit created by Google. 
It is used to develop applications for Android, iOS, Linux, Mac, Windows, Google Fuchsia,[4] and the web from a single codebase.[5]
The first version of Flutter was known as codename "Sky" and ran on the Android operating system. 
It was unveiled at the 2015 Dart developer summit,[6] with the stated intent of being able to render consistently at 120 frames per second.[7]
During the keynote of Google Developer Days in Shanghai, Google announced Flutter Release Preview 2, which is the last big release before Flutter 1.0. 
On 2018年12月4日, Flutter 1.0 was released at the Flutter Live event, denoting the first "stable" version of the Framework. 
On 2019年12月11日, Flutter 1.12 was released at the Flutter Interactive event.[8]
On 2020年5月6日, the Dart SDK in version 2.8 and the Flutter in version 1.17.0 were released, where support was added to the Metal API, improving performance on iOS devices (approximately 50%), new Material widgets, and new network tracking.
On 2021年3月3日, Google released Flutter 2 during an online Flutter Engage event. 
This major update brought official support for web-based applications as well as early-access desktop application support for Windows, MacOS, and Linux.[9]
On 2021年3月3日, Google released Flutter 2 during an online Flutter Engage event.
''';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PagingText(
                sampleText,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PagingText extends StatefulWidget {
  final String text;
  final TextStyle style;

  PagingText(
      this.text, {
        this.style = const TextStyle(
          color: Colors.black,
          fontSize: 30,
        ),
      });

  @override
  _PagingTextState createState() => _PagingTextState();
}

class _PagingTextState extends State<PagingText> {
  // 分页
  final List<String> _pageTexts = [];

  // 当前页
  int _currentIndex = 0;

  bool _needPaging = true;
  bool _isPaging = false;

  final _pageKey = GlobalKey();

  @override
  void didUpdateWidget(PagingText oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 如果输入文本和当前文本不匹配，清空数据重新加载
    if (widget.text != oldWidget.text) {
      setState(() {
        _pageTexts.clear();
        _currentIndex = 0;
        _needPaging = true;
        _isPaging = false;
      });
    }
  }

  // 分页
  void _paginate() {
    // 获取页面尺寸
    // 获取当前Widget尺寸
    final pageSize =
        (_pageKey.currentContext?.findRenderObject() as RenderBox).size;

    // 清空分页数据
    _pageTexts.clear();

    // 使用textPainter进行分页
    final textSpan = TextSpan(
      text: widget.text,
      style: widget.style,
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
    double currentPageBottom = pageSize.height;
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
        widget.text.substring(currentPageStartIndex, currentPageEndIndex);
        _pageTexts.add(pageText);

        currentPageStartIndex = currentPageEndIndex;
        currentPageBottom = top + pageSize.height;
      }
    }

    final lastPageText = widget.text.substring(currentPageStartIndex);
    _pageTexts.add(lastPageText);

    setState(() {
      _currentIndex = 0;
      _needPaging = false;
      _isPaging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_needPaging && !_isPaging) {
      _isPaging = true;

      SchedulerBinding.instance.addPostFrameCallback((_) {
        _paginate();
      });
    }

    // 创建Content页面
    Widget buildPage(String page) {
      return Text(
        page,
        style: const TextStyle(fontSize: 30),
      );
    }

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: SizedBox.expand(
                key: _pageKey,
                child: PageView(
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                  children: _pageTexts.map((page) => buildPage(page)).toList(),
                ),
              ),
            ),
          ],
        ),
        if (_isPaging)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
