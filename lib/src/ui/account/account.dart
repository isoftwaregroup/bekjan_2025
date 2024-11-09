import 'package:app/src/helpers/widgets.dart';
import 'package:app/src/network/client.dart';
import 'package:app/src/network/http_result.dart';
import 'package:app/src/ui/account/dialog/delete_dialog.dart';
import 'package:app/src/ui/account/orders/my_orders.dart';
import 'package:app/src/ui/account/provider.dart';
import 'package:app/src/ui/account/qr_code.dart';
import 'package:app/src/ui/auth/model/user.dart';
import 'package:app/src/ui/home_page/provider/home_provider.dart';
import 'package:app/src/ui/home_page/provider/map_provider.dart';
import 'package:app/src/utils/utils.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/links.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:app/src/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/apptheme.dart';
import '../auth/edit_info_screen.dart';
import '../auth/enter_screen.dart';
import '../home_page/provider/service_provider.dart';
import 'app_info.dart';
import 'bonus/bonuses.dart';
import 'dialog/language_dialog.dart';
import 'faq.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountState();
}

class _AccountState extends State<AccountScreen> {
  bool isLoading = false, imageloading = false;
  String lan = 'uz', packageInfo = '';
  final _picker = ImagePicker();

  @override
  void initState() {
    if (userNotifier.user == null) {
      userNotifier.getUser();
    }
    userNotifier.getTotalBonus();
    userNotifier.getShareMsg();
    PackageInfo.fromPlatform().then((value) {
      packageInfo = value.packageName;
      userNotifier.update();
    });
    _getLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        toolbarHeight: 5.h,
        elevation: 0,
        backgroundColor: theme.cardBackground,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: theme.cardBackground,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          User? user = ref.watch(userProvider).user;
          return ListView(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: 600.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16.h),
                        bottomRight: Radius.circular(16.h),
                      ),
                      color: theme.cardBackground,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      pickImage(ImageSource.gallery);
                    },
                    child: Container(
                      height: 80.h,
                      width: 80.h,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 5.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(80.h),
                        ),
                        color: const Color(0xFFD9D9D9),
                      ),
                      child: imageloading
                          ? SizedBox(
                              width: 24.o,
                              height: 24.o,
                              child: CircularProgressIndicator(
                                backgroundColor: const Color(0xFFD9D9D9),
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(theme.blue),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(112.o),
                              child: Image.network(
                                '${Links.baseUrl}${user?.photo}',
                                height: 132.h,
                                width: 132.h,
                                fit: BoxFit.cover,
                                errorBuilder: (
                                  context,
                                  error,
                                  StackTrace? stackTrace,
                                ) {
                                  return SvgPicture.asset(
                                    svgIcon.avatar,
                                    height: 130.h,
                                    width: 130.h,
                                  );
                                },
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    top: 8.o,
                    left: 12.o,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 34.o,
                        width: 34.o,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.o),
                            color: theme.mainBlue),
                        child: SvgPicture.asset(
                          svgIcon.arrowLeft,
                          width: 24.o,
                          height: 24.o,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              user != null
                  ? Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20.o, bottom: 20.o),
                          alignment: Alignment.center,
                          child: Text(
                            '${user.firstname} ${user.lastname}',
                            style: theme.textStyle.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 20.o,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      height: 80.h,
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 26.h,
                        width: 26.h,
                        child: CircularProgressIndicator.adaptive(
                            backgroundColor: theme.text,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(theme.red)),
                      ),
                    ),
              Container(
                width: 600.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16.h)),
                    color: theme.cardBackground),
                padding: EdgeInsets.only(
                  left: 23.5.w,
                  right: 23.5.w,
                  top: 15.h,
                  bottom: 15.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    user == null
                        ? const SizedBox()
                        : item(
                            icon: SvgPicture.asset(
                              svgIcon.pensil,
                              colorFilter: theme.greyFilter,
                              height: 14.h,
                              width: 14.h,
                            ),
                            message: editInfo.tr,
                            onTap: () => _push(UpdateInfoScreen(user: user!)),
                          ),
                    line,
                    item(
                      icon: SvgPicture.asset(
                        svgIcon.dispecher,
                        colorFilter: theme.greyFilter,
                        height: 13.h,
                        width: 13.h,
                      ),
                      message: dispacher.tr,
                      onTap: () async {
                        if (!await launchUrl(
                          Uri.parse(dispacherLink),
                          //mode: LaunchMode.externalApplication
                        )) {
                          throw 'Could not launch $num';
                        }
                      },
                    ),
                    line,
                    item(
                      icon: SvgPicture.asset(
                        svgIcon.globus,
                        colorFilter: theme.greyFilter,
                        height: 15.h,
                        width: 15.h,
                      ),
                      message: language.tr,
                      rightText: lanKey.tr,
                      onTap: () => showBottomDialog(LanguageDialog(
                        onChange: () {
                          _getLanguage();
                          serviceCounter.update();
                        },
                      ), context),
                    ),
                    line,
                    item(
                      icon: SvgPicture.asset(
                        svgIcon.bonus,
                        colorFilter: theme.greyFilter,
                        height: 16.h,
                        width: 16.h,
                      ),
                      message: bonusHistory.tr,
                      rightText: userNotifier.totalBonus.isEmpty
                          ? ''
                          : '${numberFormat(userNotifier.totalBonus)} UZS',
                      onTap: () => _push(MyBonuses(
                          '${numberFormat(userNotifier.totalBonus)} UZS')),
                    ),
                    line,
                    item(
                      icon: SvgPicture.asset(
                        svgIcon.history,
                        colorFilter: theme.greyFilter,
                        height: 14.h,
                        width: 14.h,
                      ),
                      message: myOrders.tr,
                      onTap: () => _push(const MyOrders()),
                    ),
                    line,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 36.w,
                          child: SvgPicture.asset(
                            svgIcon.moon,
                            colorFilter: theme.greyFilter,
                            height: 11.h,
                            width: 11.h,
                          ),
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        txt(night.tr),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              isDark = !isDark;
                              updateTheme();
                              serviceCounter.update();
                              mapNotifier.update();
                              mapNotifier.mapScrollstate.sink.add(false);
                              homeNotifier.update();
                            });
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setBool('ThemeApp', isDark);
                          },
                          child: slider(isActive: isDark),
                        ),
                      ],
                    ),
                    line,
                    item(
                      icon: SvgPicture.asset(
                        svgIcon.info,
                        colorFilter: theme.greyFilter,
                        height: 14.h,
                        width: 14.h,
                      ),
                      message: about.tr,
                      onTap: () => _push(const AppInfo()),
                    ),
                    line,
                    item(
                      icon: SvgPicture.asset(
                        svgIcon.faq,
                        colorFilter: theme.greyFilter,
                        height: 12.5.h,
                        width: 12.5.h,
                      ),
                      message: faq.tr,
                      onTap: () => _push(const FAQ()),
                    ),
                    if (user?.id != null && packageInfo.isNotEmpty) line,
                    if (user?.id != null && packageInfo.isNotEmpty)
                      item(
                        icon: SvgPicture.asset(
                          svgIcon.qrCode,
                          colorFilter: theme.greyFilter,
                          height: 12.5.h,
                          width: 12.5.h,
                        ),
                        message: qrCode.tr,
                        onTap: () => _push(
                            QrCodeScreen(package: packageInfo, user: user!)),
                      ),
                    line,
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DeleteDialog(
                              message: sureExit.tr,
                              onNext: (isDelete) async {
                                setState(() {
                                  isLoading = true;
                                });
                                if (isDelete) {
                                  await client.post(Links.deleteUser);
                                }
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.remove("token");
                                userNotifier.user = null;
                                navigate();
                                user = null;
                                setState(() {
                                  isLoading = false;
                                });
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 36.w,
                              child: SvgPicture.asset(
                                svgIcon.exit,
                                colorFilter: ColorFilter.mode(
                                  theme.red,
                                  BlendMode.srcIn,
                                ),
                                height: 16.h,
                                width: 16.h,
                              ),
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            Text(
                              exit.tr,
                              style: theme.textStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 15.o,
                                color: theme.red,
                              ),
                            ),
                            const Spacer(),
                            SvgPicture.asset(
                              svgIcon.goto,
                              colorFilter: ColorFilter.mode(
                                theme.red,
                                BlendMode.srcIn,
                              ),
                              height: 13.o,
                              width: 13.o,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 60.h,
              ),
            ],
          );
        },
      ),
    );
  }

  Future pickImage(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
      );
      setState(() {
        imageloading = true;
      });
      if (file == null) {
        setState(() {
          imageloading = false;
        });
        return;
      }
      print('path: ${file.path}');
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });
      MainModel result = await client.post(Links.avatar, data: formData);
      if (result.status == 200) {
        userNotifier.setUser(User.fromJson(result.data));
      }
      setState(() {
        imageloading = false;
      });
    } on PlatformException catch (_) {
      print('error pick image : $_');
    }
  }

  Widget txt(String s) {
    return Text(
      s,
      style: theme.textStyle.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 15.o,
      ),
    );
  }

  Widget get line => Container(
        width: 553.w,
        color: theme.line,
        height: 1.h,
        margin: EdgeInsets.symmetric(
          vertical: 10.h,
        ),
      );

  Widget item({
    required Widget icon,
    required String message,
    String rightText = '',
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 36.w,
              child: icon,
            ),
            SizedBox(
              width: 15.w,
            ),
            txt(message),
            const Spacer(),
            Text(
              rightText,
              style: theme.textStyle.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 15.o,
                color: theme.grey,
              ),
            ),
            SizedBox(
              width: 15.w,
            ),
            goto(),
          ],
        ),
      ),
    );
  }

  void _push(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Widget goto() => SvgPicture.asset(
        svgIcon.goto,
        colorFilter: theme.greyFilter,
        height: 13.o,
        width: 13.o,
      );

  Future<void> _getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lan = prefs.getString('language') ?? "uz";
    setState(() {
      var localizationDelegate = LocalizedApp.of(context).delegate;
      localizationDelegate.changeLocale(Locale(lan));
    });
  }

  void navigate() {
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const EnterScreen()));
  }
}
