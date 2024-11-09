import 'package:app/src/ui/account/provider.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../helpers/apptheme.dart';

class FAQ extends StatefulWidget {
  const FAQ({Key? key}) : super(key: key);

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  int selectedIndex = -1;
  @override
  void initState() {
    userNotifier.getFAQ();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: theme.cardBackground,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        leading: Center(
          child: GestureDetector(
            onTap: () {
              _back();
            },
            child: SvgPicture.asset(
              svgIcon.back,
              height: 22.o,
              width: 22.o,
              colorFilter: theme.colorFilter,
            ),
          ),
        ),
        title: Text(
          faq.tr,
          style: theme.textStyle.copyWith(
              fontWeight: FontWeight.w500, fontSize: 20.o, color: theme.text),
        ),
      ),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final faqs = ref.watch(userProvider).faqs;
          if (faqs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    svgIcon.info,
                    width: 40.o,
                    height: 40.o,
                    colorFilter: ColorFilter.mode(theme.grey, BlendMode.srcIn),
                  ),
                  Text(
                    empty.tr,
                    style: theme.textStyle.copyWith(
                      color: theme.grey,
                      fontSize: 18.o,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10.o),
            itemCount: faqs.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (selectedIndex == index) {
                    selectedIndex = -1;
                  } else {
                    selectedIndex = index;
                  }
                  userNotifier.update();
                },
                child: Container(
                  color: theme.secondary,
                  margin: EdgeInsets.only(top: 10.o),
                  padding: EdgeInsets.all(10.o),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              faqs[index].question,
                              style: theme.textStyle.copyWith(
                                fontSize: 14.o,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 5,
                            ),
                          ),
                          Container(
                            width: 30.o,
                            height: 30.o,
                            padding: EdgeInsets.only(
                              top: 9.o,
                              left: 12.o,
                              bottom: 9.o,
                              right: 6.o,
                            ),
                            child: SvgPicture.asset(
                              svgIcon.down,
                              colorFilter: theme.colorFilter,
                            ),
                          )
                        ],
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        child: selectedIndex != index
                            ? SizedBox(
                                width: 600.w - 40.o,
                              )
                            : Padding(
                                padding: EdgeInsets.only(top: 10.o),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        faqs[index].answer,
                                        style: theme.textStyle.copyWith(
                                          fontSize: 14.o,
                                          fontWeight: FontWeight.w400,
                                          color: theme.grey,
                                        ),
                                        maxLines: 100,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30.o,
                                      height: 30.o,
                                    )
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _back() {
    Navigator.pop(context);
  }

  void _push(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }
}
