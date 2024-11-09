import 'dart:math';

import 'package:app/src/helpers/apptheme.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TarifItem extends StatelessWidget {
  final EdgeInsets margin;
  final String title, cost, img;
  final Function()? onTap, onSelect;
  final bool isSelected;
  const TarifItem({
    super.key,
    required this.title,
    required this.cost,
    required this.img,
    this.margin = EdgeInsets.zero,
    this.isSelected = false,
    this.onTap,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 125.o,
        margin: margin,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              height: 110.o,
              width: 110.o,
              margin: EdgeInsets.only(right: 15.o),
              decoration: theme.cardDecor.copyWith(
                  borderRadius: BorderRadius.circular(16.o),
                  color: isSelected ? theme.yellow.withOpacity(0.2) : null,
                  border: isSelected
                      ? Border.all(
                          width: 1,
                          color: theme.yellow.withOpacity(0.5),
                        )
                      : null),
            ),
            Container(
              height: 50.o,
              width: 110.o,
              margin: EdgeInsets.only(
                top: 20.o,
                right: 5.o,
              ),
              child: Hero(
                tag: '${title}image',
                child: Image.network(
                  img,
                  alignment: Alignment.bottomRight,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      images.nexiya,
                      alignment: Alignment.bottomRight,
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 6.o,
                  left: 9.o,
                ),
                child: Hero(
                  tag: '${title}title',
                  child: Text(
                    title,
                    style: theme.textStyle.copyWith(
                      fontSize: 14.o,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: 110.o,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 9.o,
                          right: 5.o,
                          bottom: 2.o,
                        ),
                        child: AutoSizeText(
                          cost,
                          style: theme.textStyle.copyWith(
                            fontSize: 11.o,
                            fontWeight: FontWeight.w500,
                          ),
                          minFontSize: 5,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onSelect,
                      child: Container(
                        width: 28.o,
                        height: 28.o,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.o),
                          border: Border.all(
                            width: 3.o,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          color: theme.yellow,
                        ),
                        child: Transform.rotate(
                          angle: -pi / 4,
                          child: SvgPicture.asset(
                            svgIcon.arrowRight,
                            width: 15.o,
                            height: 15.o,
                            colorFilter: const ColorFilter.mode(
                              Colors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
