import 'dart:convert';
import 'dart:io';

import 'package:android/provider/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class HomeSearchWidget extends ConsumerStatefulWidget {
  const HomeSearchWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeSearchWidget> createState() => _HomeSearchWidgetState();
}

class _HomeSearchWidgetState extends ConsumerState<HomeSearchWidget> {
  static const List<String> sourceList = <String>[
    'all',
    'ibiqu.org',
  ];

  // 搜索源
  String sourceOption = "ibiqu.org";
  String searchText = "";

  // 获取查询数据
  void searchClick() async {
    final responseFuture = await getSearchApi();

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

    // 存入Provider
    ref.read(searchProvider.notifier).updateSearchResult(jsonData['data']);
  }

  Future<http.Response> getSearchApi() async {
    final queryParameters = {"name": searchText};

    var url =
        Uri.http(dotenv.env['SERVER_HTTP']!, '/crawler/query', queryParameters);

    print(url);

    return await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      HttpHeaders.acceptCharsetHeader: 'gzip'
    });
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
    return Container(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: DropdownButton<String>(
              isDense: true,
              value: sourceOption,
              items: sourceList.map((sourceValue) {
                return DropdownMenuItem(
                  value: sourceValue,
                  child: Center(
                    child: Text(
                      sourceValue,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  if (newValue != null) {
                    sourceOption = newValue;
                  }
                });
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              textAlignVertical: TextAlignVertical.bottom,
              decoration: const InputDecoration(
                hintText: "输入作者或者书名",
              ),
              onChanged: (newValue) {
                setState(() {
                  searchText = newValue;
                });
              },
            ),
          ),
          IconButton(
            onPressed: searchClick,
            icon: const Icon(Icons.search),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
    );
  }
}
