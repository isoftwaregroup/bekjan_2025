import 'package:app/src/helpers/apptheme.dart';
import 'package:app/src/helpers/widgets.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';

class MessageDialog extends StatelessWidget {
  final String msg, buttonTxt;
  final Function? onTap;
  const MessageDialog({
    super.key,
    required this.msg,
    this.onTap,
    this.buttonTxt = 'Ok',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          msg,
          maxLines: 10,
          textAlign: TextAlign.center,
          style: theme.textStyle.copyWith(
            fontSize: 18.o,
            fontWeight: FontWeight.w500,
          ),
        ),
        StandartButton(
          onTap: () {
            Navigator.pop(context);
            if (onTap != null) {
              onTap!();
            }
          },
          txt: buttonTxt,
        ),
      ],
    );
  }
}
