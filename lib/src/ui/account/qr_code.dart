import 'package:app/src/ui/account/provider.dart';
import 'package:app/src/ui/auth/model/user.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/links.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../helpers/apptheme.dart';

class QrCodeScreen extends StatelessWidget {
  final String package;
  final User user;
  const QrCodeScreen({super.key, required this.package, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset(
              svgIcon.back,
              height: 22.o,
              width: 22.o,
              colorFilter: theme.colorFilter,
            ),
          ),
        ),
        title: Text(
          qrCode.tr,
          style: theme.textStyle.copyWith(
              fontWeight: FontWeight.w500, fontSize: 20.o, color: theme.text),
        ),
      ),
      backgroundColor: theme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 100.o,
                    ),
                    decoration: theme.cardDecor.copyWith(
                      borderRadius: BorderRadius.circular(20.o),
                    ),
                    padding: EdgeInsets.all(20.o),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 40.o,
                            bottom: 20.o,
                          ),
                          child: Text(
                            offer.tr,
                            style: theme.textStyle.copyWith(
                              fontSize: 15.o,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 210.o,
                          width: 210.o,
                          child: QrImageView(
                            data:
                                'https://play.google.com/store/apps/details?id=$package&referrer=${userNotifier.user?.id}',
                            version: QrVersions.auto,
                            size: 320.o,
                            eyeStyle: QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: theme.orange,
                            ),
                            dataModuleStyle: QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.circle,
                              color: theme.orange,
                            ),
                            // embeddedImage: AssetImage(
                            //   isDark ? images.darkLogo : images.lightLogo,
                            // ),
                            // embeddedImageStyle: QrEmbeddedImageStyle(
                            //   size: Size(80.o, 80.o),
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 80.o,
                  width: 80.o,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 60.o),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(80.o),
                    ),
                    color: const Color(0xFFD9D9D9),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(112.o),
                    child: Image.network(
                      '${Links.baseUrl}${user.photo}',
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
              ],
            ),
            GestureDetector(
              onTap: () {
                String msg = userNotifier.shareMsg;
                final link =
                    'https://play.google.com/store/apps/details?id=$package&referrer=${userNotifier.user?.id}';
                final name =
                    '${userNotifier.user?.firstname ?? ''} ${userNotifier.user?.lastname ?? ''}';
                if (msg.contains('[fish]')) {
                  msg = msg.replaceFirst('[fish]', name);
                } else {
                  msg = '$name $msg';
                }
                if (msg.contains('[link]')) {
                  msg = msg.replaceFirst('[link]', '$link ');
                } else {
                  msg = '$msg $link';
                }
                print('msg: $msg');
                Share.share(msg);
              },
              child: Container(
                width: 70.o,
                height: 70.o,
                margin: EdgeInsets.only(
                  top: 40.o,
                ),
                alignment: Alignment.center,
                decoration: theme.cardDecor.copyWith(
                  borderRadius: BorderRadius.circular(35.o),
                ),
                child: SvgPicture.asset(
                  svgIcon.share,
                  colorFilter: theme.colorFilter,
                  width: 26.o,
                  height: 26.o,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
