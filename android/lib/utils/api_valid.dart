import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class ApiValid {
  static bool validHttpResponse(
      BuildContext buildContext,
      Response response,
      dynamic jsonData,
      Function(BuildContext, String) showErrorMessage) {

    if (response.statusCode != 200) {
      showErrorMessage(buildContext, '请求错误，${jsonData['message']}');
      return false;
    }

    if (jsonData['code'] != 200) {
      showErrorMessage(buildContext, '${jsonData['message']}');
      return false;
    }

    return true;
  }
}
