import 'package:app/src/helpers/apptheme.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DeleteDialog extends StatefulWidget {
  final String message, btnLeft, btnRight;
  final Function(bool isDelete) onNext;
  const DeleteDialog({
    Key? key,
    required this.message,
    this.btnLeft = '',
    this.btnRight = '',
    required this.onNext,
  }) : super(key: key);

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  bool setDelete = false;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 260.o,
        height: 300.o,
        margin: EdgeInsets.only(bottom: 15.o),
        padding: EdgeInsets.only(
          left: 23.5.w,
          right: 23.5.w,
          bottom: 15.o,
          top: 28.o,
        ),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14.h)),
          color: theme.cardBackground,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgIcon.info,
              height: 100.o,
              width: 100.o,
            ),
            const Spacer(),
            SizedBox(
              height: 10.o,
            ),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: theme.textStyle.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16.o,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      setDelete = !setDelete;
                    });
                  },
                  child: Container(
                    height: 18.o,
                    width: 18.o,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.o),
                        border: Border.all(
                          width: 1.o,
                          color: theme.line,
                        )),
                    margin: EdgeInsets.only(right: 5.h),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(2.o),
                    child: setDelete
                        ? SvgPicture.asset(
                            svgIcon.success,
                            fit: BoxFit.fill,
                          )
                        : null,
                  ),
                ),
                Text(
                  delAccount.tr,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: theme.textStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.o,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 15.o,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.o),
                        color: theme.line,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 10.o,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.btnLeft.isEmpty ? no.tr : widget.btnLeft,
                        style: theme.textStyle.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.o,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.onNext(setDelete);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 18.o,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.o),
                        color: theme.red,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 10.o,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.btnRight.isEmpty ? yes.tr : widget.btnRight,
                        style: theme.textStyle.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.o,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
