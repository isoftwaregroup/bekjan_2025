import 'package:app/src/ui/dialogs/warning_dialog.dart';
import 'package:app/src/ui/home_page/provider/home_provider.dart';
import 'package:app/src/ui/home_page/util.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../helpers/apptheme.dart';

class LoadOrder extends StatefulWidget {
  const LoadOrder({super.key});

  @override
  State<LoadOrder> createState() => _LoadOrderState();
}

class _LoadOrderState extends State<LoadOrder> with TickerProviderStateMixin {
  late final AnimationController _animController = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _animController,
    curve: Curves.elasticOut,
  );

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        AvatarGlow(
          glowColor: theme.mainBlue,
          // endRadius: 100.o,
          duration: const Duration(milliseconds: 2000),
          repeat: true,
          // repeatPauseDuration: const Duration(milliseconds: 100),
          child: Container(
            width: 110.o,
            height: 110.o,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(55.o),
              color: theme.mainBlue,
            ),
            child: RotationTransition(
              turns: _animation,
              child: SvgPicture.asset(
                svgIcon.tire,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
                height: 50.o,
                width: 50.o,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30.o,
              ),
              child: Stack(
                children: [
                  Text(
                    waitCar.tr,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: theme.textStyle.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.o,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2.5
                        ..color = theme.secondary,
                    ),
                  ),
                  Text(
                    waitCar.tr,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: theme.textStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.o,
                        color: theme.text),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: 160.o,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return WarningDialog(
                    message: sureCancel.tr,
                    onNext: () async {
                      if (await cancelCurrentOrder('')) {
                        deleteServices();
                        deleteLastorder();
                        homeNotifier.conditionKey = '';
                        homeNotifier.update();
                      }
                    },
                  );
                },
              );
            },
            child: Container(
              height: 55.o,
              width: 55.o,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35.o),
                color: theme.greyBG,
              ),
              child: SvgPicture.asset(
                svgIcon.clear,
                height: 16.o,
                width: 18.o,
                colorFilter: theme.colorFilter,
              ),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
