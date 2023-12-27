import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void showToast(String message, BuildContext context) {
  ToastContext toastContext = ToastContext();
  toastContext.init(context);
  Toast.show(
    message,
    duration: Toast.lengthShort,
    gravity: Toast.bottom,
    backgroundColor: Colors.black54,
    webTexColor: Colors.white,
  );
}