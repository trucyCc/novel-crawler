import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChapterContent extends ConsumerStatefulWidget {
  const ChapterContent({Key? key, required this.onUpdateShowConfigBar})
      : super(key: key);
  final Function onUpdateShowConfigBar;

  @override
  ConsumerState<ChapterContent> createState() => _ChapterContentState();
}

class _ChapterContentState extends ConsumerState<ChapterContent> {
  final List<String> pages = ['1', '2'];
  int currentPageIndex = 0;
  PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget buildPage(String page) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        page,
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // onTap: () {
      //
      //   print("点击");
      //   if (currentPageIndex < pages.length - 1) {
      //     print("点击1");
      //     _pageController.nextPage(
      //       duration: Duration(milliseconds: 500),
      //       curve: Curves.easeInOut,
      //     );
      //   }
      // },
      onTapDown: (TapDownDetails details) {
        final screenWidth = MediaQuery.of(context).size.width;
        final tapX = details.globalPosition.dx;
        final centerLine = screenWidth / 2;

        if (tapX < centerLine - 80) {
          if (currentPageIndex >= 0) {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        }

        if (tapX > centerLine + 80) {
          // 右侧页面点击
          if (currentPageIndex < pages.length - 1) {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        }

        if (tapX > centerLine - 80 && tapX < centerLine + 80) {
          widget.onUpdateShowConfigBar();
        }
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
