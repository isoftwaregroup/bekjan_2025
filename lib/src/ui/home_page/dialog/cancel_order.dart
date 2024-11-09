import 'package:app/src/helpers/apptheme.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CancelDialog extends StatefulWidget {
  final Function(String comment) onCancel;
  const CancelDialog({
    super.key,
    required this.onCancel,
  });

  @override
  State<CancelDialog> createState() => _CancelDialogState();
}

class _CancelDialogState extends State<CancelDialog> {
  String commentText = '';
  @override
  Widget build(BuildContext context) {
    double bottom = MediaQuery.of(context).viewInsets.bottom - 80.o;
    if (bottom < 0) {
      bottom = 0;
    }
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.o,
        vertical: 25.o,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            svgIcon.down,
            height: 10.o,
            width: 10.o,
            colorFilter: theme.greyFilter,
          ),
          SizedBox(
            height: 10.o,
          ),
          Text(
            cancelOrder.tr,
            style: theme.textStyle.copyWith(
              fontSize: 22.o,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 15.o,
          ),
          SvgPicture.asset(
            svgIcon.clear,
            height: 80.o,
            width: 80.o,
            colorFilter: ColorFilter.mode(
              theme.red,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(
            height: 15.o,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.o),
            child: Text(
              sureCancel.tr,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: theme.textStyle.copyWith(
                fontSize: 18.o,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 15.o,
              top: 12.o,
            ),
            height: 50.o,
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            decoration: theme.greyDecor,
            child: Column(
              children: [
                Expanded(
                  child: TextField(
                    maxLines: 4,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: theme.textStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 15.h,
                        color: theme.line,
                      ),
                      hintText: comment.tr,
                    ),
                    style: theme.textStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.o,
                    ),
                    onChanged: (txt) {
                      commentText = txt;
                    },
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.onCancel(commentText);
              Navigator.pop(context);
            },
            child: Container(
              height: 50.o,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.o),
                color: theme.yellow,
              ),
              margin: EdgeInsets.only(bottom: bottom),
              child: Text(
                cancelOrder.tr,
                style: theme.textStyle.copyWith(
                  fontSize: 17.o,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
