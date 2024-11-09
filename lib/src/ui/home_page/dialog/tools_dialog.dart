import 'package:app/src/helpers/apptheme.dart';
import 'package:app/src/ui/home_page/models/service_model.dart';
import 'package:app/src/ui/home_page/provider/service_provider.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:app/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pinput/pinput.dart';

import '../provider/home_provider.dart';

class ToolsDialg extends StatefulWidget {
  const ToolsDialg({
    super.key,
  });

  @override
  State<ToolsDialg> createState() => _ToolsDialgState();
}

class _ToolsDialgState extends State<ToolsDialg> {
  bool haveComment = false;
  TextEditingController commentText = TextEditingController();
  @override
  void initState() {
    if (homeNotifier.commentText.isNotEmpty) {
      haveComment = true;
      commentText.setText(homeNotifier.commentText);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.o,
        vertical: 25.o,
      ),
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          List<SericeModel> data = ref.watch(servicesProvider).services;
          double bottom = MediaQuery.of(context).viewInsets.bottom -
              (50.o * data.length + 55.o);
          if (bottom < 0) {
            bottom = 0;
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                svgIcon.down,
                height: 10.o,
                width: 10.o,
                colorFilter: ColorFilter.mode(theme.grey, BlendMode.srcIn),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    haveComment = !haveComment;
                  });
                },
                child: item(
                  icon: svgIcon.message,
                  title: writeComment.tr,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: EdgeInsets.only(
                  bottom: haveComment ? 12.o + bottom : 0,
                ),
                height: haveComment ? 60.h : 0,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ),
                decoration: haveComment ? theme.greyDecor : null,
                child: haveComment
                    ? Column(
                        children: [
                          Expanded(
                            child: TextField(
                              maxLines: 4,
                              keyboardType: TextInputType.text,
                              controller: commentText,
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
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ),
              if (data.isNotEmpty)
                Column(
                  children: List<Widget>.generate(
                    data.length,
                    (index) => Column(
                      children: [
                        line,
                        item(
                          icon: data[index].icon.isEmpty
                              ? svgIcon.snow
                              : data[index].icon,
                          greyTxt: '${data[index].cost} UZS',
                          title: data[index].name,
                          rightWidget: GestureDetector(
                            onTap: () {
                              print('icon: ${data[index].icon}');
                              data[index] = data[index]
                                  .copyWith(isActive: !data[index].isActive);
                              serviceCounter.services = data;
                              serviceCounter.notifyListeners();
                            },
                            child: slider(
                              isActive: data[index].isActive,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              GestureDetector(
                onTap: () {
                  List<SericeModel> listData = [];
                  for (final item in data) {
                    if (item.isActive) {
                      listData.add(item);
                    }
                  }
                  homeNotifier.commentText = commentText.text;
                  homeNotifier.services = listData;
                  serviceCounter.update();
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50.o,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    left: 10.o,
                    right: 10.o,
                    top: 5.o,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.o),
                    color: theme.yellow,
                  ),
                  child: Text(
                    save.tr,
                    style: theme.textStyle.copyWith(
                      fontSize: 17.o,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget item(
          {required String icon,
          required String title,
          String greyTxt = '',
          Widget? rightWidget}) =>
      Container(
        padding: EdgeInsets.symmetric(
          vertical: 10.o,
        ),
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon.contains('.svg')
                ? SvgPicture.asset(
                    icon,
                    height: 20.o,
                    width: 20.o,
                  )
                : Container(
                    alignment: Alignment.center,
                    height: 20.o,
                    width: 20.o,
                    child: FaIcon(
                      getIcon(icon),
                      size: 20.o,
                      color: theme.blue,
                    ),
                  ),
            SizedBox(width: 10.o),
            Expanded(
              child: Text(
                title,
                style: theme.textStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 19.o,
                ),
              ),
            ),
            SizedBox(width: 6.o),
            Text(
              greyTxt,
              style: theme.textStyle.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 16.o,
                color: theme.grey,
              ),
            ),
            SizedBox(
              width: 10.o,
            ),
            rightWidget ??
                Padding(
                  padding: EdgeInsets.only(right: 8.o),
                  child: SvgPicture.asset(
                    svgIcon.goto,
                    height: 12.o,
                    width: 12.o,
                    color: theme.grey,
                  ),
                ),
          ],
        ),
      );

  Widget get line => Container(
        width: 600.w - 30.o,
        height: 1.5.o,
        color: theme.line,
      );
}
