import 'package:app/src/network/client.dart';
import 'package:app/src/network/http_result.dart';
import 'package:app/src/ui/home_page/home_screen.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/links.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:app/src/widgets/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../helpers/apptheme.dart';
import 'dialog/picker_dialog.dart';

class UserInfoScreen extends StatefulWidget {
  UserInfoScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  bool isLoading = false,
      nameError = false,
      surnameError = false,
      isMan = true,
      dateError = false,
      isNext = false;
  String bornDay = '';
  TextEditingController name = TextEditingController(),
      surname = TextEditingController();

  @override
  void initState() {
    name.addListener(() {
      checkIs(false);
    });
    surname.addListener(() {
      checkIs(false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background,
      body: Column(
        children: [
          Container(
            height: 60.h,
            width: 600.w,
            margin: EdgeInsets.only(top: 30.h),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
              horizontal: 30.w,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25.o),
                bottomRight: Radius.circular(25.o),
              ),
              color: theme.cardBackground,
            ),
            child: Text(
              userInfo.tr,
              style: theme.textStyle.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 24.o,
              ),
              maxLines: 2,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                title(userName.tr),
                editText(
                  hint: 'Akramjon',
                  decor: nameError ? theme.redDecor : theme.cardDecor,
                  controller: name,
                ),
                title(userSurname.tr),
                editText(
                  hint: 'Minochdinov',
                  decor: surnameError ? theme.redDecor : theme.cardDecor,
                  controller: surname,
                ),
                title(you.tr),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isMan = true;
                          });
                        },
                        child: Container(
                          height: 40.h,
                          margin: EdgeInsets.only(
                            top: 5.h,
                            left: 20.w,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.o),
                              color:
                                  isMan ? theme.yellow : theme.cardBackground),
                          alignment: Alignment.center,
                          child: Text(
                            man.tr,
                            style: theme.textStyle.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.o,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30.w,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isMan = false;
                          });
                        },
                        child: Container(
                          height: 40.h,
                          margin: EdgeInsets.only(
                            top: 5.h,
                            right: 20.w,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.o),
                              color:
                                  isMan ? theme.cardBackground : theme.yellow),
                          alignment: Alignment.center,
                          child: Text(
                            woman.tr,
                            style: theme.textStyle.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.o,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                title(bornDate.tr),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet<void>(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.h),
                      ),
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      context: context,
                      builder: (BuildContext context) {
                        return PickerDialog(
                          title: selectDate.tr,
                          selected: (year, mounth, day) {
                            bornDay = [
                              day.toString().padLeft(2, '0'),
                              mounth.toString().padLeft(2, '0'),
                              year,
                            ].join('.');
                            checkIs(false);
                          },
                        );
                      },
                    );
                  },
                  child: container(
                    decor: dateError ? theme.redDecor : theme.cardDecor,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          svgIcon.calendar,
                          colorFilter: theme.colorFilter,
                          height: 14.h,
                          width: 14.h,
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Text(
                          bornDay.isEmpty ? selectDate.tr : bornDay,
                          style: theme.textStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.o,
                          ),
                        ),
                        const Spacer(),
                        SvgPicture.asset(
                          svgIcon.goto,
                          height: 7.h,
                          width: 7.h,
                          colorFilter: theme.colorFilter,
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (checkIs(true)) {
                      sendData();
                    }
                  },
                  child: Container(
                    height: 40.h,
                    width: 540.w,
                    margin: EdgeInsets.symmetric(
                      horizontal: 30.w,
                      vertical: 18.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.o),
                      color: theme.yellow.withOpacity(isNext ? 1 : 0.2),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          save.tr,
                          style: theme.textStyle.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.o,
                              color: theme.text.withOpacity(isNext ? 1 : 0.2)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget container({
    required BoxDecoration decor,
    required Widget child,
  }) {
    return Container(
      height: 36.h,
      width: 560.w,
      margin: EdgeInsets.only(
        top: 5.h,
        left: 20.w,
        right: 20.w,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: decor,
      child: child,
    );
  }

  Widget editText(
      {required String hint,
      required BoxDecoration decor,
      TextEditingController? controller}) {
    return container(
      decor: decor,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: theme.textStyle.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 13.h,
                  color: theme.line,
                ),
                hintText: hint,
              ),
              style: theme.textStyle.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 13.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget title(String txt) {
    return Container(
      margin: EdgeInsets.only(
        top: 15.h,
        left: 20.w,
        right: 20.w,
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        txt,
        style: theme.textStyle.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 16.o,
          color: theme.grey,
        ),
        maxLines: 2,
      ),
    );
  }

  bool checkIs(bool isToast) {
    nameError = name.text.length < 3;
    surnameError = surname.text.length < 3;
    dateError = bornDay.isEmpty;
    isNext = false;
    setState(() {});
    if (isToast) {
      if (nameError) {
        toast(context: context, txt: enterName.tr);
        return false;
      } else if (surnameError) {
        toast(context: context, txt: enterSurname.tr);
        return false;
      } else if (dateError) {
        toast(context: context, txt: bornDate.tr);
        return false;
      }
    }
    setState(() {
      isNext = true;
    });
    return true;
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

  void sendData() async {
    setState(() {
      isLoading = true;
    });
    MainModel result = await client.post(
      Links.register,
      data: {
        'first_name': name.text,
        'last_name': surname.text,
        'born': bornDay.split('.').reversed.join('-'),
        'gender': isMan ? 1 : 2
      },
    );
    if (result.status == 200) {
      navigate();
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

  void show(String message) {
    toast(context: context, txt: message);
  }
}
