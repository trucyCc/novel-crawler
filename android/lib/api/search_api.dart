import 'dart:convert';
import 'dart:io';

import 'package:android/utils/api_valid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SearchApi {
  static dynamic getSearchApi(BuildContext buildContext, String source,
      String text, Function(BuildContext, String) showErrorMessage) async {
    final queryParameters = {"name": text, "source": source};

    var url =
        Uri.http(dotenv.env['SERVER_HTTP']!, '/crawler/query', queryParameters);

    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      HttpHeaders.acceptCharsetHeader: 'gzip'
    });

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
