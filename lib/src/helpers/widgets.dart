import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';

import 'apptheme.dart';

void showBottomDialog(Widget dialog, BuildContext context) =>
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.o),
          topRight: Radius.circular(30.o),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: theme.card,
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );

void showCenterdialog(Widget dialog, BuildContext context) => showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.all(20.h),
            margin: EdgeInsets.all(30.o),
            decoration: BoxDecoration(
              color: theme.card,
              borderRadius: BorderRadius.circular(20.o),
            ),
            child: dialog,
          ),
        );
      },
    );

class StandartButton extends StatelessWidget {
  final String txt;
  final Function()? onTap;
  const StandartButton({
    super.key,
    this.txt = 'Ok',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          top: 12.o,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.o),
          color: theme.yellow,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 12.o,
          horizontal: 15.o,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                txt,
                textAlign: TextAlign.center,
                style: theme.textStyle.copyWith(
                    fontSize: 15.o,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
