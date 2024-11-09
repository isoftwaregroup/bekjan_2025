import 'package:app/src/helpers/apptheme.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WarningDialog extends StatelessWidget {
  final String message, btnLeft, btnRight;
  final Function() onNext;
  final bool isOne;
  const WarningDialog({
    Key? key,
    required this.message,
    this.btnLeft = '',
    this.btnRight = '',
    required this.onNext,
    this.isOne = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 260.o,
        height: 280.o,
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
              message,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: theme.textStyle.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16.o,
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 10.o,
            ),
            Row(
              children: [
                if (!isOne)
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
                          btnLeft.isEmpty ? no.tr : btnLeft,
                          style: theme.textStyle.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.o,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (!isOne)
                  SizedBox(
                    width: 20.w,
                  ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      onNext();
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 15.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.o),
                        color: isOne ? theme.yellow : theme.red,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 10.o,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        btnRight.isEmpty ? yes.tr : btnRight,
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
