import 'package:flutter/material.dart';

class ShowBar {
  // 底部弹出报错信息
  static void showErrorSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      // action: SnackBarAction(
      //   label: 'X',
      //   onPressed: () {
      //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
      //   },
      // ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
