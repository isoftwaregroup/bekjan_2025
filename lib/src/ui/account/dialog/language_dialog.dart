import 'dart:io';

import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/apptheme.dart';

class LanguageDialog extends StatefulWidget {
  final Function onChange;
  const LanguageDialog({Key? key, required this.onChange}) : super(key: key);

  @override
  _LanguageDialogState createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  String lan = 'uz';

  @override
  void initState() {
    getLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double bottom = MediaQuery.of(context).viewInsets.bottom - 60.h;
    if (bottom < 0) {
      bottom = 0;
    }
    return Container(
      padding: EdgeInsets.only(
        bottom: Platform.isIOS ? 15.o : 0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.o),
          topRight: Radius.circular(30.o),
        ),
        color: theme.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 30.o, bottom: 15.h),
            child: Text(
              selectLanguage.tr,
              style: theme.textStyle.copyWith(
                fontSize: 23.o,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                lan = 'uz';
              });
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 36.w,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'uz',
                    maxLines: 2,
                    style: theme.textStyle.copyWith(
                      fontSize: 22.o,
                      fontWeight: FontWeight.w500,
                      color: lan != 'uz' ? theme.text : theme.blue,
                    ),
                  ),
                  const Spacer(),
                  lan != 'uz'
                      ? const SizedBox()
                      : SvgPicture.asset(
                          svgIcon.success,
                          height: 9.h,
                          width: 9.h,
                          colorFilter: ColorFilter.mode(
                            theme.blue,
                            BlendMode.srcIn,
                          ),
                        ),
                ],
              ),
            ),
          ),
          Container(
            height: 1.o,
            color: theme.line,
            margin: EdgeInsets.symmetric(horizontal: 36.w),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                lan = 'ru';
              });
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 36.w,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'ru',
                    maxLines: 2,
                    style: theme.textStyle.copyWith(
                      fontSize: 22.o,
                      fontWeight: FontWeight.w500,
                      color: lan != 'ru' ? theme.text : theme.blue,
                    ),
                  ),
                  const Spacer(),
                  lan != 'ru'
                      ? const SizedBox()
                      : SvgPicture.asset(
                          svgIcon.success,
                          height: 9.h,
                          width: 9.h,
                          colorFilter: ColorFilter.mode(
                            theme.blue,
                            BlendMode.srcIn,
                          ),
                        ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          GestureDetector(
            onTap: () {
              _setLanguage();
            },
            child: Container(
              height: 40.h,
              width: 540.w,
              margin: EdgeInsets.only(
                top: 10.h,
                bottom: 15.h,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.o),
                color: theme.yellow,
              ),
              alignment: Alignment.center,
              child: Text(
                save.tr,
                style: theme.textStyle.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.o,
                  color: const Color(0xFF302E2B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _setLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("language", lan);
    setState(() {
      var localizationDelegate = LocalizedApp.of(context).delegate;
      localizationDelegate.changeLocale(Locale(lan));
    });
    widget.onChange();
    _back();
  }

  void getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lan = prefs.getString("language") ?? 'uz';
    setState(() {});
  }

  void _back() {
    Navigator.pop(context);
  }
}
