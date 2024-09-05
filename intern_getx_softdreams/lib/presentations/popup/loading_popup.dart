import 'package:flutter/material.dart';

class LoadingPopup {
  static bool isShowing = false;

  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        isShowing = true;
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          ),
        );
      },
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    if (!isShowing) return;
    isShowing = false;
    Navigator.of(context).pop();
  }
}
