import 'package:app/src/helpers/apptheme.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class CallDispecherScreen extends StatelessWidget {
  const CallDispecherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          svgIcon.offWifi,
          height: 100.o,
          width: 100.o,
          colorFilter: theme.colorFilter,
        ),
        SizedBox(
          height: 20.h,
        ),
        Text(
          noConnection.tr,
          style: theme.textStyle
              .copyWith(fontWeight: FontWeight.w700, fontSize: 22.o),
        ),
        SizedBox(
          height: 8.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30.o,
          ),
          child: Text(
            checkConnection.tr,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: theme.textStyle.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 13.o,
                color: Colors.grey),
          ),
        ),
        SizedBox(
          height: 200.h,
        ),
        Center(
          child: GestureDetector(
            onTap: () async {
              if (!await launchUrl(Uri.parse(dispacherLink),
                  mode: LaunchMode.externalApplication)) {
                throw 'Could not launch $num';
              }
            },
            child: Container(
              height: 70.o,
              width: 70.o,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35.o),
                color: theme.mainBlue,
              ),
              child: SvgPicture.asset(
                svgIcon.phone,
                height: 28.o,
                width: 28.o,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Text(
          dispacher.tr,
          style: theme.textStyle
              .copyWith(fontWeight: FontWeight.w500, fontSize: 16.o),
        ),
      ],
    );
  }
}
