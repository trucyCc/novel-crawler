
import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChapterApi {
  // 获取章节页面内容
  static Future<http.Response> getChapterContent(source, chapterUrl) async {
    final queryParameters = {"url": chapterUrl, "source": source};
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
}