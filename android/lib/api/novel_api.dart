import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../utils/api_valid.dart';

class NovelApi {
  // 获取书籍详细信息
  static dynamic getNovelInfoApi(BuildContext buildContext, String source,
      String novelUrl, Function(BuildContext, String) showErrorMessage) async {
    final queryParameters = {"url": novelUrl, "source": source};
    var url = Uri.http(dotenv.env['SERVER_HTTP']!, '/crawler/book');

    final response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
        HttpHeaders.acceptCharsetHeader: 'gzip'
      },
      body: Uri(queryParameters: queryParameters).query,
    );

    // 解析数据
    final jsonData = json.decode(utf8.decode(response.bodyBytes));

    final validStatus = ApiValid.validHttpResponse(
      buildContext,
      response,
      jsonData,
      showErrorMessage,
    );
    if (!validStatus) {
      return null;
    }

    return jsonData;
  }
}
