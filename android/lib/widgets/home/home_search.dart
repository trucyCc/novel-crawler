import 'dart:convert';
import 'dart:io';

import 'package:android/model/search.dart';
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
  static List<String> sourceList = [];
  String sourceOption = "";
  String searchText = "";

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    // 初始化目标源
    final sourceJson = await getSourceOptional();
    print(sourceJson);
    final sourceNames = sourceJson['data']['names'];
    print(sourceNames);
    final tempList =
        sourceNames.map((dynamic item) => item.toString()).toList();

    sourceList = [];
    for (var value in tempList) {
      sourceList.add(value.toString());
    }

    if (sourceList.isNotEmpty) {
      sourceOption = sourceList[0];
    }
  }

  // 获取查询数据
  void searchClick() async {
    final searchJson = await getSearchApi();

    // 存入Provider
    print(ref.read(searchProvider.notifier).getSearchResult());

    final searchResult = SearchModel(
      source: sourceOption,
      resultData: searchJson['data'],
    );
    ref.read(searchProvider.notifier).updateSearchResult(searchResult);
  }

  dynamic getSourceOptional() async {
    var url = Uri.http(dotenv.env['SERVER_HTTP']!, '/plugin/sources');

    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      HttpHeaders.acceptCharsetHeader: 'gzip'
    });

    // 请求失败
    if (response.statusCode != 200) {
      showErrorSnackBar('请求错误，状态：${response.statusCode}');
      return null;
    }

    // 解析数据
    final jsonData = json.decode(utf8.decode(response.bodyBytes));

    // 服务器错误
    if (jsonData['code'] != 200) {
      showErrorSnackBar('${jsonData['message']}');
      return null;
    }

    return jsonData;
  }

  dynamic getSearchApi() async {
    final queryParameters = {"name": searchText, "source": sourceOption};

    var url =
        Uri.http(dotenv.env['SERVER_HTTP']!, '/crawler/query', queryParameters);

    var responseFuture = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      HttpHeaders.acceptCharsetHeader: 'gzip'
    });

    // 请求失败
    if (responseFuture.statusCode != 200) {
      showErrorSnackBar('请求错误，状态：${responseFuture.statusCode}');
      return null;
    }

    // 解析数据
    final jsonData = json.decode(utf8.decode(responseFuture.bodyBytes));

    // 服务器错误
    if (jsonData['code'] != 200) {
      showErrorSnackBar('${jsonData['message']}');
      return null;
    }

    return jsonData;
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
