import 'package:app/src/helpers/apptheme.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';

class CallDispecher extends StatefulWidget {
  const CallDispecher({Key? key}) : super(key: key);

  @override
  State<CallDispecher> createState() => _CallDispecherState();
}

class _CallDispecherState extends State<CallDispecher> {
  @override
  void initState() {
    getInfo();
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
              "assets/icons/back.svg",
              height: 28.o,
              width: 28.o,
            ),
          ),
        ),
        title: Text(
          translate('account_screen.operator'),
          style: theme.textStyle.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 20.o,
            color: theme.text,
          ),
        ),
      ),
      // body: ListView(
      //   children: info == null ? [
      //     Container(
      //       height: 450.h,
      //       alignment: Alignment.center,
      //       child: SizedBox(
      //         height: 26.h,
      //         width: 26.h,
      //         child: CircularProgressIndicator.adaptive(
      //             backgroundColor: theme.text,
      //             valueColor: AlwaysStoppedAnimation<Color>(theme.red)),
      //       ),
      //     )
      //   ] : [
      //     info!.phone.isEmpty ? const SizedBox() :
      //     Container(
      //       width: 553.w,
      //       margin: EdgeInsets.only(
      //         left: 23.5.w,
      //         right: 23.5.w,
      //         top: 8.h,
      //       ),
      //       padding: EdgeInsets.only(
      //         left: 23.5.w,
      //         right: 23.5.w,
      //         top: 13.h,
      //         bottom: 13.h,
      //       ),
      //       alignment: Alignment.topLeft,
      //       decoration: BoxDecoration(
      //         borderRadius: BorderRadius.all(
      //             Radius.circular(8.h)),
      //         color: theme.cardBackground,
      //       ),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           GestureDetector(
      //             onTap: () async {
      //               final num = 'tel:${info?.phone}';
      //               if (!await launchUrl(Uri.parse(num))) {
      //                 throw 'Could not launch $num';
      //               }
      //             },
      //             child: Container(
      //               color: Colors.transparent,
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Row(
      //                     crossAxisAlignment: CrossAxisAlignment.center,
      //                     children: [
      //                       SizedBox(
      //                         width: 36.w,
      //                         child: SvgPicture.asset(
      //                           "assets/icons/divays.svg",
      //                           colorFilter: ColorFilter.mode(
      //                             theme.blue,
      //                             BlendMode.srcIn,
      //                           ),
      //                           height: 18.h,
      //                           width: 18.h,
      //                         ),
      //                       ),
      //                       SizedBox(
      //                         width: 15.w,
      //                       ),
      //                       Text(
      //                         translate('account_screen.call_we'),
      //                         style: theme.textStyle.copyWith(
      //                             fontWeight: FontWeight.w400,
      //                             fontSize: 15.o,
      //                             color: theme.grey
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                   SizedBox(height: 6.h,),
      //                   Text(
      //                     setphoneNumberFormat(info!.phone.replaceAll('+', '')),
      //                     style: theme.textStyle.copyWith(
      //                       fontWeight: FontWeight.w500,
      //                       fontSize: 16.o,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //           Container(
      //             width: 506.w,
      //             color: theme.line,
      //             height: 1.h,
      //             margin: EdgeInsets.symmetric(
      //                 vertical: 10.h
      //             ),
      //           ),
      //           GestureDetector(
      //             onTap: () async {
      //               final url = info!.telegram_url;
      //               if (!await launchUrl(
      //                 Uri.parse(url),
      //                 mode: LaunchMode.externalNonBrowserApplication,
      //               )) {
      //                 throw 'Could not launch $url';
      //               }
      //             },
      //             child: Container(
      //               color: Colors.transparent,
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Row(
      //                     crossAxisAlignment: CrossAxisAlignment.center,
      //                     children: [
      //                       SizedBox(
      //                         width: 36.w,
      //                         child: SvgPicture.asset(
      //                           "assets/icons/telgram.svg",
      //                           colorFilter: ColorFilter.mode(
      //                               theme.blue,
      //                               BlendMode.srcIn),
      //                           height: 18.h,
      //                           width: 18.h,
      //                         ),
      //                       ),
      //                       SizedBox(
      //                         width: 15.w,
      //                       ),
      //                       Text(
      //                         translate('account_screen.call_telegram'),
      //                         style: theme.textStyle.copyWith(
      //                             fontWeight: FontWeight.w400,
      //                             fontSize: 15.o,
      //                             color: theme.grey
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                   SizedBox(height: 6.h,),
      //                   Text(
      //                     '@${info!.telegram_url.split('/').last}',
      //                     style: theme.textStyle.copyWith(
      //                       fontWeight: FontWeight.w500,
      //                       fontSize: 16.o,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //           Container(
      //             width: 506.w,
      //             color: theme.line,
      //             height: 1.h,
      //             margin: EdgeInsets.symmetric(
      //                 vertical: 10.h
      //             ),
      //           ),
      //           GestureDetector(
      //             onTap: () async {
      //               final url = 'mailto:${info!.email}';
      //               if (!await launchUrl(Uri.parse(url))) {
      //                 throw 'Could not launch $url';
      //               }
      //             },
      //             child: Container(
      //               color: Colors.transparent,
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Row(
      //                     crossAxisAlignment: CrossAxisAlignment.center,
      //                     children: [
      //                       SizedBox(
      //                         width: 36.w,
      //                         child: SvgPicture.asset(
      //                           "assets/icons/mail.svg",
      //                           colorFilter: ColorFilter.mode(
      //                               theme.blue,
      //                               BlendMode.srcIn),
      //                           height: 18.h,
      //                           width: 18.h,
      //                         ),
      //                       ),
      //                       SizedBox(
      //                         width: 15.w,
      //                       ),
      //                       Text(
      //                         translate('account_screen.from_mail'),
      //                         style: theme.textStyle.copyWith(
      //                           fontWeight: FontWeight.w400,
      //                           fontSize: 15.o,
      //                           color: theme.grey,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                   SizedBox(height: 6.h,),
      //                   Text(
      //                     info!.email,
      //                     style: theme.textStyle.copyWith(
      //                       fontWeight: FontWeight.w500,
      //                       fontSize: 16.o,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  void _back() {
    Navigator.pop(context);
  }

  void _push(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void getInfo() async {
    //info = await accountBloc.getContactUs();
    setState(() {});
  }
}
