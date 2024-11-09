import 'package:app/src/helpers/apptheme.dart';
import 'package:app/src/ui/home_page/provider/home_provider.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../provider/map_provider.dart';

class LocationChecker extends StatelessWidget {
  const LocationChecker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<bool>(
        stream: mapNotifier.mapScrollStream,
        builder: (context, snapshot) {
          return AnimatedContainer(
            height: 70.o,
            duration: const Duration(milliseconds: 250),
            margin: EdgeInsets.only(
              bottom: snapshot.data == true ? 100.o : 70.o,
            ),
            child: Column(
              children: [
                Container(
                  height: 45.o,
                  width: 45.o,
                  decoration: theme.cardDecor.copyWith(
                    color: theme.yellow,
                    border: Border.all(
                      width: 2.5.o,
                      color: Colors.white,
                    ),
                  ),
                  padding: EdgeInsets.all(5.o),
                  child: Center(
                    child: homeNotifier.streetLoading
                        ? const CircularProgressIndicator.adaptive(
                            backgroundColor: Colors.black)
                        : homeNotifier.isWhere == true
                            ? Padding(
                                padding: EdgeInsets.all(4.o),
                                child: SvgPicture.asset(svgIcon.passenger),
                              )
                            : SvgPicture.asset(svgIcon.flagFinish),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2.o,
                    decoration: BoxDecoration(
                      color: theme.text,
                      borderRadius: BorderRadius.circular(2.o),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
