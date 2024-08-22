import 'dart:async';

import 'package:bekjan/src/helpers/ConnectionListner.dart';
import 'package:bekjan/src/ui/account/provider.dart';
import 'package:bekjan/src/ui/auth/enter_screen.dart';
import 'package:bekjan/src/ui/home_page/home_screen.dart';
import 'package:bekjan/src/ui/home_page/provider/map_provider.dart';
import 'package:bekjan/src/ui/home_page/provider/service_provider.dart';
import 'package:bekjan/src/ui/home_page/util.dart';
import 'package:bekjan/src/ui/home_page/widgets/call_dispecher_screen.dart';
import 'package:bekjan/src/variables/icons.dart';
import 'package:bekjan/src/variables/language.dart';
import 'package:bekjan/src/variables/links.dart';
import 'package:bekjan/src/variables/util_variables.dart';
import 'package:bekjan/src/widgets/Toast.dart';
import 'package:bekjan/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../helpers/apptheme.dart';
import 'provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _controller = PageController();
  int _selectedIndex = 0, _status = 0;
  bool locationServiceListned = false;
  @override
  void initState() {
    setDispacherLink();


    if ((pref.getString('token') ?? '').isNotEmpty) {
      userNotifier.getUser();
      setOperations();
    } else {


      splashNotifier.getSplash().onError((error, stackTrace) {


        toast(context: context, txt: error.toString());
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.secondary,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: theme.secondary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: theme.secondary,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final pages = ref.watch(splashProvider).pages;
          if ((pref.getString('token') ?? '').isNotEmpty) {
            if (dispacherLink.isNotEmpty && !isOnline) {
              return const CallDispecherScreen();
            }
            return Container(
              color: theme.background,
              alignment: Alignment.center,
              child: CircularProgressIndicator.adaptive(
                backgroundColor: theme.text,
              ),
            );
          }
          if (pages == null || pages.isEmpty) {
            return Center(
              child: SizedBox(
                height: 30.h,
                width: 30.h,
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: theme.text,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.red),
                ),
              ),
            );
          }
          return Column(
            children: [
              SizedBox(
                height: 450.h,
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 600.w,
                              height: 260.h,
                              margin: EdgeInsets.only(top: 20.h),
                              alignment: Alignment.center,
                              child: Image.network(
                                '${Links.baseUrl}${pages[index].photo}',
                                fit: BoxFit.fitWidth,
                                width: 500.w,
                                errorBuilder: (
                                  context,
                                  error,
                                  StackTrace? stackTrace,
                                ) {
                                  print(
                                      '${Links.baseUrl}${pages[index].photo}');
                                  return SvgPicture.asset(
                                    svgIcon.info,
                                    height: 130.o,
                                    width: 130.o,
                                  );
                                },
                              ),
                            ),
                            _selectedIndex == pages.length - 1
                                ? const SizedBox()
                                : GestureDetector(
                                    onTap: () {
                                      setPermissions();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        top: 10.h,
                                        right: 20.w,
                                      ),
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        skip.tr,
                                        style: theme.textStyle.copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17.o,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                top: 12.h,
                                bottom: 6.h,
                                left: 30.w,
                                right: 30.w,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                pages[index].title,
                                style: theme.textStyle.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 27.o,
                                ),
                                maxLines: 2,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                left: 30.w,
                                right: 30.w,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                pages[index].description,
                                style: theme.textStyle.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.o,
                                    color: theme.grey),
                                maxLines: 4,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                      height: 8.h,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: pages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 8.h,
                            width: 8.h,
                            margin: EdgeInsets.symmetric(
                              horizontal: 10.w,
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.h)),
                              color: _selectedIndex == index
                                  ? theme.yellow
                                  : theme.dragDown,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            _selectedIndex++;
                            if (_selectedIndex < pages.length) {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              setPermissions();
                            }
                            splashNotifier.update();
                          },
                          child: Container(
                            height: 50.o,
                            width: 50.o,
                            margin: EdgeInsets.only(right: 50.w),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.o)),
                                color: theme.yellow),
                            child: Center(
                              child: splashNotifier.permitLoading
                                  ? CircularProgressIndicator.adaptive(
                                      backgroundColor: theme.text,
                                    )
                                  : SvgPicture.asset(
                                      svgIcon.goto,
                                      height: 12.h,
                                      width: 12.h,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.black,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> setPermissions() async {
    print('!splashNotifier.permitLoading: ${splashNotifier.permitLoading}');
    if (!splashNotifier.permitLoading) {
      splashNotifier.permitLoading = true;
      print('permitLoading');
      Permission.location.isGranted.then((value) {
        print('permitvalue: $value');
        if (value) {
          mapNotifier.setCurentPosition().then((value) {
            splashNotifier.permitLoading = false;
            splashNotifier.update();
            navigate();
          }).onError((error, stackTrace) {
            splashNotifier.permitLoading = false;
            splashNotifier.update();
            toast(context: context, txt: error.toString());
          });
        } else {
          Permission.location.request().then((value) {
            print('request().then: $value');
            if (value.isGranted) {
              mapNotifier
                  .setCurentPosition()
                  .then((value) => null)
                  .onError((error, stackTrace) {
                toast(context: context, txt: error.toString());
              });
              navigate();
            }
            splashNotifier.permitLoading = false;
            splashNotifier.update();
          });
        }
      });
    }
  }

  void setOperations() async {
    connectionListner.homeConnectionListner = (isConnected) {
      setState(() {
        isOnline = isConnected;
      });
      if (isOnline) {
        setDispacherLink();
        serviceCounter.getServises().then((value) {
          _status = value;
          if (value == 401) {
            pref.remove('token');
          }
          navigate();
        });
      }
    };
    await mapNotifier.setCurentPosition().then((value) {
      serviceCounter.loadTarifs();
      navigate();
    }).onError((error, stackTrace) {
      toast(context: context, txt: error.toString());
    });
  }

  void navigate() {
    if ((pref.getString('token') ?? '').isEmpty || _status == 401) {
      pushReplacement(context, const EnterScreen());
    } else {
      if (mapNotifier.currentPosition != null) {
        pushReplacement(context, const HomePage());
      }
    }
  }
}
