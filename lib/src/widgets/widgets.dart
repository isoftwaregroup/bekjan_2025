import 'package:app/src/helpers/apptheme.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';

class slider extends StatelessWidget {
  bool isActive;
  slider({Key? key, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.o),
      height: 22.o,
      width: 38.o,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.o),
        border: Border.all(
          width: 1.o,
          color: isActive ? theme.yellow : theme.line,
        ),
        color: isActive != true ? theme.dragDown : theme.yellow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          isActive == true ? const Spacer() : Container(),
          Container(
            height: 15.o,
            width: 15.o,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.o),
              color: isActive
                  ? const Color(0xFFFFFFFF)
                  : isDark
                      ? const Color(0xFF202020)
                      : const Color(0xFF303130),
            ),
          ),
          isActive != true ? const Spacer() : Container(),
        ],
      ),
    );
  }
}

void push(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => screen,
    ),
  );
}

void pushReplacement(BuildContext context, Widget screen) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => screen,
    ),
  );
}
