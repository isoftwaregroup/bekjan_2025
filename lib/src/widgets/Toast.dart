import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';

void toast(
    {required BuildContext context,
    required String txt,
    Color? backgroundColor}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(txt),
      backgroundColor: backgroundColor,
      margin: EdgeInsets.only(bottom: 50.h),
      duration: const Duration(milliseconds: 3500),
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 13,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
