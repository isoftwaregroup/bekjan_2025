import 'dart:io';

import 'package:app/src/ui/account/provider.dart';
import 'package:app/src/utils/utils.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/apptheme.dart';

class AppInfo extends StatefulWidget {
  const AppInfo({Key? key}) : super(key: key);

  @override
  State<AppInfo> createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
  AboutUs? info;
  @override
  void initState() {
    userNotifier.getAboutUs().then((value) => setState(() {
          info = value;
        }));
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
          about.tr,
          style: theme.textStyle.copyWith(
              fontWeight: FontWeight.w500, fontSize: 20.o, color: theme.text),
        ),
      ),
      body: ListView(
        children: [
          info == null
              ? Container(
                  height: 600.h,
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 26.h,
                    width: 26.h,
                    child: CircularProgressIndicator.adaptive(
                        backgroundColor: theme.text,
                        valueColor: AlwaysStoppedAnimation<Color>(theme.red)),
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 23.5.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        info!.name,
                        style: theme.textStyle.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 36.o,
                          color: theme.text,
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        '${appVersion.tr} ${info!.version_name}',
                        style: theme.textStyle.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.o,
                          color: theme.text,
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        info!.description,
                        style: theme.textStyle.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.o,
                          color: theme.text,
                        ),
                        maxLines: 10,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final num = 'tel:${info!.support_phone}';
                          if (!await launchUrl(Uri.parse(num))) {
                            throw 'Could not launch $num';
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              supportNum.tr,
                              style: theme.textStyle.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.o,
                                color: theme.text,
                              ),
                              maxLines: 10,
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              setphoneNumberFormat(
                                  info!.support_phone.replaceAll('+', '')),
                              style: theme.textStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 18.o,
                                color: theme.text,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        telegram.tr,
                        style: theme.textStyle.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 20.o,
                          color: theme.text,
                        ),
                        maxLines: 10,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final num = info!.telegram_url;
                          if (!await launchUrl(
                            Uri.parse(num),
                            mode: LaunchMode.externalNonBrowserApplication,
                          )) {
                            throw 'Could not launch $num';
                          }
                        },
                        child: Text(
                          info!.telegram_name,
                          style: theme.textStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 18.o,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final num = 'tel:${info!.designed_by_phone}';
                              if (!await launchUrl(Uri.parse(num))) {
                                throw 'Could not launch $num';
                              }
                            },
                            child: Column(
                              children: [
                                Text(
                                  madedBy.tr,
                                  style: theme.textStyle.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.o,
                                    color: theme.text,
                                  ),
                                  maxLines: 10,
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  setphoneNumberFormat(info!.designed_by_phone
                                      .replaceAll('+', '')),
                                  style: theme.textStyle.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18.o,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 25.w,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (!await launchUrl(
                                Uri.parse(info!.logo_link),
                                mode: LaunchMode.externalNonBrowserApplication,
                              )) {
                                throw 'Could not launch $num';
                              }
                            },
                            child: Image.network(
                              info!.logo,
                              width: 130.w,
                              errorBuilder: (
                                context,
                                error,
                                StackTrace? stackTrace,
                              ) =>
                                  const SizedBox(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }

  void _back() {
    Navigator.pop(context);
  }
}

class AboutUs {
  AboutUs({
    this.version = 0,
    required this.name,
    required this.description,
    required this.support_phone,
    required this.designed_by_phone,
    required this.telegram_url,
    required this.telegram_name,
    required this.logo,
    required this.logo_link,
    required this.version_name,
  });
  String name,
      description,
      support_phone,
      telegram_url,
      telegram_name,
      version_name,
      logo,
      logo_link,
      designed_by_phone;
  int version;

  factory AboutUs.fromJson(Map<String, dynamic> json) => AboutUs(
        version:
            Platform.isAndroid ? json['android_version'] : json['ios_version'],
        name: json['name'] == null ? '' : json['name'].toString(),
        description:
            json['description'] == null ? '' : json['description'].toString(),
        support_phone: json['support_phone'] == null
            ? ''
            : json['support_phone'].toString(),
        designed_by_phone: json['designed_by_phone'] == null
            ? ''
            : json['designed_by_phone'].toString(),
        telegram_url:
            json['telegram_url'] == null ? '' : json['telegram_url'].toString(),
        telegram_name: json['telegram_name'] == null
            ? ''
            : json['telegram_name'].toString(),
        logo: json['logo'] == null ? '' : json['logo'].toString(),
        logo_link:
            json['logo_link'] == null ? '' : json['logo_link'].toString(),
        version_name:
            json['version_name'] == null ? '' : json['version_name'].toString(),
      );

  AboutUs copyWith({
    String? name,
    String? description,
    String? support_phone,
    String? telegram_url,
    String? telegram_name,
    String? version_name,
    String? designed_by_phone,
    String? logo,
    String? logo_link,
    int? version,
  }) {
    return AboutUs(
      name: name ?? this.name,
      description: description ?? this.description,
      support_phone: support_phone ?? this.support_phone,
      designed_by_phone: designed_by_phone ?? this.designed_by_phone,
      telegram_url: telegram_url ?? this.telegram_url,
      telegram_name: telegram_name ?? this.telegram_name,
      logo: logo ?? this.logo,
      logo_link: logo_link ?? this.logo_link,
      version_name: version_name ?? this.version_name,
      version: version ?? this.version,
    );
  }
}
