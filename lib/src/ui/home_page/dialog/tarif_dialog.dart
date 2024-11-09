import 'package:app/src/helpers/apptheme.dart';
import 'package:app/src/ui/home_page/models/tarif_odel.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TarifDialog extends StatelessWidget {
  final TarifModel data;
  final int index;
  final String cost;
  final Function onSetOrder;
  const TarifDialog({
    super.key,
    required this.data,
    required this.index,
    required this.cost,
    required this.onSetOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 16.o,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 28.o,
              height: 28.o,
              padding: EdgeInsets.all(8.o),
              decoration: theme.cardDecor.copyWith(
                borderRadius: BorderRadius.circular(18.o),
                color: theme.background,
              ),
              child: SvgPicture.asset(
                svgIcon.clear,
                colorFilter: ColorFilter.mode(theme.red, BlendMode.srcIn),
              ),
            ),
          ),
          SizedBox(
            height: 130.o,
            width: 560.w,
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: '${data.name}title',
                      child: Text(
                        data.name,
                        style: theme.textStyle.copyWith(
                          fontSize: 20.o,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Hero(
                      tag: '${data.name}cost',
                      child: Text(
                        cost,
                        style: theme.textStyle.copyWith(
                          fontSize: 15.o,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Hero(
                    tag: '${data.name}image',
                    child: Image.network(
                      data.img,
                      height: 100.o,
                      width: 560.w,
                      alignment: Alignment.bottomRight,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          images.nexiya,
                          height: 100.o,
                          width: 600.w,
                          alignment: Alignment.bottomRight,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.o,
          ),
          Text(
            data.info,
            maxLines: 50,
            style: theme.textStyle.copyWith(
              fontSize: 15.o,
            ),
          ),
          GestureDetector(
            onTap: () {
              onSetOrder();
              Navigator.pop(context);
            },
            child: Container(
                height: 50.o,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  top: 16.o,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.o),
                  color: theme.yellow,
                ),
                child: Text(
                  save.tr,
                  style: theme.textStyle.copyWith(
                    fontSize: 18.o,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
