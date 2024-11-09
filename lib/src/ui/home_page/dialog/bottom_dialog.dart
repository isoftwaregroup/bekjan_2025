import 'dart:async';

import 'package:app/src/helpers/apptheme.dart';
import 'package:app/src/helpers/widgets.dart';
import 'package:app/src/ui/home_page/dialog/cancel_order.dart';
import 'package:app/src/ui/home_page/models/order_model.dart';
import 'package:app/src/ui/home_page/provider/driver_provider.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/links.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:app/src/widgets/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../network/client.dart';
import '../../../network/http_result.dart';

class BottomDialog extends StatefulWidget {
  final Function onCancelOrder;
  final DriverModel data;
  const BottomDialog(
      {super.key, required this.onCancelOrder, required this.data});

  @override
  State<BottomDialog> createState() => _DialgState();
}

class _DialgState extends State<BottomDialog> {
  int ms = 0;
  double height = 180.o;
  bool canCancel = false;
  @override
  Widget build(BuildContext context) {
    if (driverCounter.key == 'order_started') {
      if (height > 180.o) {
        height = 180.o;
      }
    }
    return GestureDetector(
      onDoubleTap: () {
        if (height > 50.o) {
          height = 0;
          canCancel = false;
        } else {
          height = 220.o;
          canCancel = true;
        }
        setState(() {});
      },
      onTap: () {
        if (height > 50.o) {
          height = 0;
          canCancel = false;
        } else {
          height = 180.o;
          canCancel = true;
        }
        setState(() {});
      },
      onPanEnd: (details) {
        double dy = details.velocity.pixelsPerSecond.dy;
        if (dy == 0.0) {
          dy = 50;
        }
        ms = 10000 ~/ dy;
        if (ms < 10) {
          ms = 10;
        }
        height -= dy;
        if (height < 50.o) {
          height = 0;
          canCancel = false;
        } else if (height < 185.o) {
          height = 180.o;
          canCancel = true;
        } else {
          print('canCancel: $canCancel');
          height = canCancel ? 220.o : 180.o;
          canCancel = true;
        }
        setState(() {});
      },
      onPanUpdate: (details) {
        if (ms != 0) {
          ms = 0;
        }
        final dy = details.delta.dy;
        if (dy != 0) {
          height -= details.delta.dy;
          if (height < 0) {
            height = 0;
          } else if (height > (canCancel ? 220.o : 180.o)) {
            height = canCancel ? 220.o : 180.o;
          }
          setState(() {});
        }
      },
      child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 26.o,
            vertical: 24.o,
          ),
          decoration: BoxDecoration(
            color: theme.card,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.o),
              topRight: Radius.circular(30.o),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                svgIcon.down,
                height: 9.o,
                width: 9.o,
              ),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final provider = ref.watch(driverProvider);
                  if (provider.key == 'order_started') {
                    return const SizedBox();
                  }
                  return Column(
                    children: [
                      SizedBox(
                        height: 20.o,
                      ),
                      Row(
                        children: [
                          Text(
                            arrivingTime.tr,
                            style: theme.textStyle.copyWith(
                              fontSize: 16.o,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            provider.waitingMessage,
                            style: theme.textStyle.copyWith(
                              fontSize: 15.o,
                              fontWeight: FontWeight.w500,
                              color: theme.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.o,
                      ),
                    ],
                  );
                },
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: ms),
                height: height,
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 10.o,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.o),
                            color: theme.line,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(17.o),
                            child: Image.network(
                              Links.baseUrl + widget.data.photo,
                              height: 48.o,
                              width: 48.o,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, StackTrace? stackTrace) {
                                return Padding(
                                  padding: EdgeInsets.all(8.o),
                                  child: SvgPicture.asset(
                                    svgIcon.user,
                                    height: 32.o,
                                    width: 32.o,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 8.o),
                                  Text(
                                    '${widget.data.first_name} ${widget.data.last_name}',
                                    style: theme.textStyle.copyWith(
                                      fontSize: 13.o,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    widget.data.rating,
                                    style: theme.textStyle.copyWith(
                                      fontSize: 12.o,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 3.o),
                                  SvgPicture.asset(
                                    svgIcon.star,
                                    height: 13.o,
                                    width: 13.o,
                                  ),
                                  SizedBox(width: 5.o),
                                ],
                              ),
                              SizedBox(
                                height: 7.o,
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 8.o),
                                  Text(
                                    widget.data.car.name,
                                    style: theme.textStyle.copyWith(
                                      fontSize: 14.o,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4.o,
                                      horizontal: 6.o,
                                    ),
                                    decoration: theme.greyDecor,
                                    child: Text(
                                      widget.data.car.number,
                                      style: theme.textStyle.copyWith(
                                        fontSize: 13.o,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.o,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final num = 'tel:${widget.data.phone}';
                        if (!await launchUrl(Uri.parse(num))) {
                          throw 'Could not launch $num';
                        }
                      },
                      child: Container(
                        height: 50.o,
                        width: 560.w,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.o,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.o),
                          color: theme.yellow,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              svgIcon.phone,
                              height: 22.o,
                              width: 22.o,
                              colorFilter: const ColorFilter.mode(
                                Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(
                              width: 5.o,
                            ),
                            Text(
                              call.tr,
                              style: theme.textStyle.copyWith(
                                fontSize: 16.o,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.o,
                    ),
                    GestureDetector(
                      onTap: () async {
                        showBottomDialog(CancelDialog(
                          onCancel: (String comment) async {
                            if (await cancelCurrentOrder(comment)) {
                              widget.onCancelOrder();
                            }
                          },
                        ), context);
                      },
                      child: Container(
                        height: 30.o,
                        width: 560.w,
                        alignment: Alignment.center,
                        child: Text(
                          cancel.tr,
                          style: theme.textStyle.copyWith(
                            fontSize: 18.o,
                            fontWeight: FontWeight.w600,
                            color: theme.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Future<bool> cancelCurrentOrder(String comment) async {
    MainModel result = await client.post(
      Links.cancelOrder,
      data: {'comment': comment},
    );
    if (result.status == 200) {
      return true;
    } else {
      toast(context: context, txt: result.message);
    }
    return false;
  }
}
