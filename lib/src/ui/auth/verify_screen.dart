import 'dart:async';
import 'dart:io';

import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:app/src/network/client.dart';
import 'package:app/src/ui/home_page/home_screen.dart';
import 'package:app/src/ui/home_page/provider/service_provider.dart';
import 'package:app/src/utils/utils.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/links.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:app/src/widgets/Toast.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/apptheme.dart';
import '../../network/http_result.dart';
import 'enter_screen.dart';
import 'user_info_screen.dart';

class VerifyScreen extends StatefulWidget {
  final String phone;
  final String signature;
  final String token;
  final isEdit;
  bool way;
  VerifyScreen({
    Key? key,
    required this.phone,
    required this.token,
    this.signature = '',
    this.way = true,
    this.isEdit = false,
  }) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  Timer? _timer;
  int _start = 60;
  bool isNext = false, isLoading = false, isError = false;
  @override
  void initState() {
    listenForCode();
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    smartAuth.removeSmsListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 36.h,
      height: 36.h,
      textStyle: theme.textStyle.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 16.h,
      ),
      decoration: BoxDecoration(
        border: Border.all(
            color: isDark ? const Color(0xFF808080) : theme.line, width: 1.h),
        borderRadius: BorderRadius.circular(9.h),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      borderRadius: BorderRadius.circular(9.h),
      border: Border.all(
        color: isError == true ? theme.red : theme.blue,
      ),
      color: theme.cardBackground,
    );
    return Scaffold(
      backgroundColor: theme.greyBG,
      appBar: AppBar(
        toolbarHeight: 0,
        centerTitle: true,
        backgroundColor: theme.cardBackground,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SvgPicture.asset(
              svgIcon.buildings,
              width: 560.w,
            ),
          ),
          ListView(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 180.h,
                ),
                alignment: Alignment.center,
                child: Pinput(
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: focusedPinTheme,
                  length: 4,
                  validator: (s) {
                    setState(() {
                      isNext = s != null ? s.length == 4 : false;
                    });
                    _sendSMS(s.toString());
                    return null;
                  },
                  focusNode: _pinPutFocusNode,
                  controller: _pinPutController,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 15.h,
                ),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    _pinPutController.setText('');
                    sendPhone();
                  },
                  child: Text(
                    _start > 0 ? numToClock(_start) : resend.tr,
                    style: theme.textStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 18.o,
                      color: _start > 0
                          ? theme.grey
                          : isDark
                              ? theme.blue
                              : theme.mainBlue,
                    ),
                    maxLines: 2,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    if (!isLoading && _pinPutController.text.length == 4) {
                      _sendSMS(_pinPutController.text);
                    }
                  },
                  child: Container(
                    height: 50.o,
                    width: 50.o,
                    margin: EdgeInsets.symmetric(
                      horizontal: 50.w,
                      vertical: 18.h,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.o),
                        color: theme.yellow
                            .withOpacity(!isNext || isLoading ? 0.2 : 1)),
                    alignment: Alignment.center,
                    child: isLoading
                        ? SizedBox(
                            height: 24.o,
                            width: 24.o,
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: theme.text,
                            ),
                          )
                        : SvgPicture.asset(
                            svgIcon.arrowRight,
                            height: 24.o,
                            width: 24.o,
                            colorFilter: ColorFilter.mode(
                              theme.text
                                  .withOpacity(!isNext || isLoading ? 0.3 : 1),
                              BlendMode.srcIn,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              color: theme.secondary,
              padding: EdgeInsets.all(12.o),
              height: 170.o,
              width: 600.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _back();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.o),
                        color: theme.container,
                      ),
                      padding: EdgeInsets.all(5.o),
                      child: SvgPicture.asset(
                        svgIcon.arrowLeft,
                        height: 28.o,
                        width: 28.o,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 10.o,
                      bottom: 10.o,
                    ),
                    child: Text(
                      widget.phone,
                      style: theme.textStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 24.o,
                      ),
                    ),
                  ),
                  Text(
                    smsSended.tr,
                    style: theme.textStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.o,
                      color: theme.grey,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _back() {
    Navigator.pop(context);
  }

  Future<void> listenForCode() async {
    final res = await smartAuth.getSmsCode();
    if (res.succeed && res.sms != null) {
      debugPrint('SMS: ${res.code}');
      int start = res.sms!.indexOf('kodi:');
      final String code = res.sms!.substring(start + 5, start + 10).trim();
      _pinPutController.setText(code);
    } else {
      debugPrint('SMS Failure:');
    }
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start <= 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void sendPhone() async {
    setState(() {
      isLoading = true;
    });
    String signature = await smartAuth.getAppSignature() ?? 'HsGhnxiN';
    MainModel result = await client.post(
      Links.resendSMSCode,
      data: {
        'token': widget.token,
        'signature': signature,
      },
    );
    if (result.status == 200) {
      _start = 60;
      _startTimer();
    } else {
      show(result.message);
    }
    setState(() {
      isLoading = false;
    });
  }

  void show(String message) {
    toast(context: context, txt: message);
  }

  void _sendSMS(String s) async {
    setState(() {
      isLoading = true;
    });
    int? userId;
    if (Platform.isAndroid) {
      try {
        ReferrerDetails referrerDetails =
            await AndroidPlayInstallReferrer.installReferrer;
        print(
            'referrerDetails.installReferrer: ${referrerDetails.installReferrer}');
        userId = int.tryParse(referrerDetails.installReferrer.toString());
      } catch (e) {}
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    String deviceName = "";

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName = iosInfo.utsname.machine ?? "";
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = androidInfo.model ?? "";
    }
    MainModel result = await client.post(
      widget.isEdit
          ? Links.editVerify
          : userId == null
              ? Links.sendVerify
              : '${Links.sendVerify}?parent_id=$userId',
      data: {
        'token': widget.token,
        'code': s,
        'device_name': deviceName,
        'fcToken': '',
      },
    );
    if (result.status == 200 && result.data['auth_key'] != null) {
      if (widget.isEdit) {
      } else {
        await pref.setString('token', result.data['auth_key'].toString());
        await pref.setString('userId', result.data['id'].toString());
        if (result.data['photo'] != null) {
          pref.setString('photo', result.data['photo'].toString());
        }
        serviceCounter.loadTarifs();
        if (result.data['step']['int'] == 1) {
          push();
        } else {
          navigate();
        }
      }
    } else {
      show(result.message);
    }
    setState(() {
      isLoading = false;
    });
  }

  void navigate() {
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const HomePage();
        },
      ),
    );
  }

  void push() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return UserInfoScreen();
        },
      ),
    );
  }

  void popUntil() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
