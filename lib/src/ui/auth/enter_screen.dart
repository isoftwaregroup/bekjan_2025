import 'package:app/src/network/client.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/links.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:app/src/widgets/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:smart_auth/smart_auth.dart';

import '../../helpers/apptheme.dart';
import '../../network/http_result.dart';
import 'verify_screen.dart';

class EnterScreen extends StatefulWidget {
  final isEdit;
  const EnterScreen({Key? key, this.isEdit = false}) : super(key: key);

  @override
  State<EnterScreen> createState() => _EnterScreenState();
}

late SmartAuth smartAuth;

class _EnterScreenState extends State<EnterScreen> {
  final TextEditingController _numberController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    smartAuth = SmartAuth();
    _numberController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    smartAuth.removeSmsListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.greyBG,
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
                height: 100.h,
                width: 200.h,
                margin: EdgeInsets.only(
                  top: 30.h,
                  left: 80.w,
                  right: 80.w,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.h),
                  color: Colors.white, //theme.grey,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.h),
                  child: Image.asset(
                    height: 100.h,
                    width: 210.h,
                    images.logo,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 20.h,
                  left: 30.w,
                  right: 30.w,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  translate(widget.isEdit ? editPhone.tr : enter.tr),
                  style: theme.textStyle.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 24.o,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 16.h,
                  bottom: 6.h,
                  left: 30.w,
                  right: 30.w,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  enterPhone.tr,
                  style: theme.textStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.o,
                      color: theme.grey),
                ),
              ),
              Container(
                height: 40.h,
                width: 540.w,
                margin: EdgeInsets.symmetric(
                  horizontal: 30.w,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ),
                decoration: theme.cardDecor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      svgIcon.phone,
                      height: 24.o,
                      width: 24.o,
                    ),
                    SizedBox(
                      width: 5.o,
                    ),
                    Text(
                      "+998",
                      style: theme.textStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.h,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _numberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          theme.numberMaskFormatter,
                        ],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: theme.textStyle.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 13.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    if (!isLoading && _numberController.text.length == 13) {
                      sendPhone();
                    }
                  },
                  child: Container(
                    height: 50.o,
                    width: 50.o,
                    margin: EdgeInsets.symmetric(
                      horizontal: 30.w,
                      vertical: 18.h,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.o),
                        color: theme.yellow.withOpacity(
                            _numberController.text.length != 13 || isLoading
                                ? 0.2
                                : 1)),
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
                              theme.text.withOpacity(
                                  _numberController.text.length != 13 ||
                                          isLoading
                                      ? 0.2
                                      : 1),
                              BlendMode.srcIn,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _push(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void sendPhone() async {
    setState(() {
      isLoading = true;
    });
    String signature = 'AJgBklbb';
    try {
      signature = await smartAuth.getAppSignature() ?? 'AJgBklbb';
    } catch (e) {}
    final num = '+998${_numberController.text}';
    MainModel result = await client.post(
      widget.isEdit ? Links.editPhone : Links.sendPhone,
      data: {
        'phone': num,
        'signature': signature,
      },
    );
    if (result.status == 200) {
      _push(VerifyScreen(
        phone: '+998${_numberController.text}',
        signature: signature,
        token: result.data['token'],
        isEdit: widget.isEdit,
      ));
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
}
