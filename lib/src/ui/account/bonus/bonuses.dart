import 'package:app/src/helpers/widgets.dart';
import 'package:app/src/ui/account/bonus/provider.dart';
import 'package:app/src/ui/home_page/models/order_model.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/links.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:app/src/widgets/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helpers/apptheme.dart';

class MyBonuses extends StatefulWidget {
  final String totalBonus;
  const MyBonuses(this.totalBonus, {Key? key}) : super(key: key);

  @override
  State<MyBonuses> createState() => _MyBonusesState();
}

class _MyBonusesState extends State<MyBonuses> {
  @override
  void initState() {
    if (bonusNotifier.bonuses.isEmpty) {
      bonusNotifier.page = 1;
      bonusNotifier.getMyBonuses('', '');
    }
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
          '${bonusHistory.tr} ',
          style: theme.textStyle.copyWith(
              fontWeight: FontWeight.w500, fontSize: 20.o, color: theme.text),
        ),
      ),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final bonuses = ref.watch(bonusProvider).bonuses;
          if (bonuses.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    svgIcon.info,
                    width: 40.o,
                    height: 40.o,
                    colorFilter: ColorFilter.mode(theme.grey, BlendMode.srcIn),
                  ),
                  Text(
                    empty.tr,
                    style: theme.textStyle.copyWith(
                      color: theme.grey,
                      fontSize: 18.o,
                    ),
                  ),
                ],
              ),
            );
          }
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification.metrics.pixels ==
                  scrollNotification.metrics.maxScrollExtent) {
                bonusNotifier.getMyBonuses('', '');
              }
              return true;
            },
            child: ListView.builder(
              itemCount: bonuses.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    bonusNotifier.setFullOrder(index).then(
                      (value) {
                        showBottomDialog(
                            BonusDialog(
                              data: bonuses[index].order,
                              index: index,
                            ),
                            context);
                      },
                    ).onError((error, stackTrace) {
                      toast(context: context, txt: error.toString());
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 16.o,
                      left: 16.o,
                      right: 16.o,
                    ),
                    padding: EdgeInsets.all(15.o),
                    decoration: BoxDecoration(
                      color: theme.secondary,
                      borderRadius: BorderRadius.circular(16.o),
                      // border: Border.all(
                      //   color: theme.line,
                      //   width: 1.o,
                      // )
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                bonuses[index].reason.name,
                                style: theme.textStyle.copyWith(
                                  fontSize: 18.o,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.o,
                            ),
                            cost(bonuses[index].value),
                          ],
                        ),
                        SizedBox(
                          height: 5.o,
                        ),
                        Text(
                          bonuses[index].datetime,
                          style: theme.textStyle.copyWith(
                            fontSize: 12.o,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _back() {
    Navigator.pop(context);
  }

  Widget cost(int value) {
    String txt = value.toString();
    if (value != 0) {
      txt = value > 0 ? '+$txt' : '-$txt';
    }
    return Text(
      txt,
      style: theme.textStyle.copyWith(
        fontSize: 27.o,
        fontWeight: FontWeight.w600,
        color: value < 0 ? theme.red : theme.green,
      ),
    );
  }
}

Color _getItemColor(CarModel status) {
  if (status.number == '6') {
    return theme.red;
  }
  if (status.number == '5') {
    return theme.green;
  }
  if (status.number == '4') {
    return theme.yellow;
  }
  return theme.mainBlue;
}

class BonusDialog extends StatelessWidget {
  final OrderModel data;
  final index;
  const BonusDialog({super.key, required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final order = ref.watch(bonusProvider).bonuses[index].order;
        final status = order.status;
        final cl = _getItemColor(status);
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20.o, horizontal: 20.o),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                svgIcon.down,
                height: 9.o,
                width: 9.o,
              ),
              SizedBox(
                height: 15.o,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    order.datetime,
                    style: theme.textStyle.copyWith(
                      fontSize: 16.o,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    width: 10.o,
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.o, horizontal: 9.o),
                    decoration: BoxDecoration(
                      color: cl.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.o),
                    ),
                    child: Text(
                      status.name,
                      style: theme.textStyle.copyWith(
                        fontSize: 12.o,
                        fontWeight: FontWeight.w500,
                        color: cl,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16.o,
              ),
              Row(
                children: [
                  Text(
                    '${order.history?.car.colorName} ${order.history?.car.name}',
                    style: theme.textStyle.copyWith(
                      fontSize: 20.o,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    width: 10.o,
                  ),
                  Text(
                    '${order.history?.car.number}',
                    style: theme.textStyle.copyWith(
                      fontSize: 18.o,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                height: 1.o,
                color: theme.line,
                margin: EdgeInsets.symmetric(vertical: 12.o),
              ),
              Row(
                children: [
                  Container(
                    width: 18.o,
                    height: 18.o,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.o),
                      border: Border.all(
                        width: 3.6.o,
                        color: theme.yellow,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.o,
                  ),
                  Expanded(
                    child: Text(
                      order.address1,
                      style: theme.textStyle.copyWith(
                        fontSize: 16.o,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16.o,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 18.o,
                    height: 19.o,
                    child: SvgPicture.asset(
                      svgIcon.location,
                      colorFilter: const ColorFilter.mode(
                        Colors.green,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.o,
                  ),
                  Expanded(
                    child: Text(
                      order.address2,
                      style: theme.textStyle.copyWith(
                        fontSize: 16.o,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 1.o,
                color: theme.line,
                margin: EdgeInsets.symmetric(vertical: 12.o),
              ),
              if (order.history != null)
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 8.o),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.o),
                            color: theme.grey,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(17.o),
                            child: Image.network(
                              Links.baseUrl + order.history!.photo,
                              height: 48.o,
                              width: 48.o,
                              fit: BoxFit.cover,
                              errorBuilder: (
                                context,
                                error,
                                StackTrace? stackTrace,
                              ) {
                                return Padding(
                                  padding: EdgeInsets.all(6.o),
                                  child: SvgPicture.asset(
                                    svgIcon.user,
                                    height: 36.o,
                                    width: 36.o,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.history!.driver,
                                style: theme.textStyle.copyWith(
                                  fontSize: 13.o,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 7.o,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    order.history!.rating,
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
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (!await launchUrl(
                                Uri.parse('tel: ${order.history!.phone}'),
                                mode: LaunchMode.externalApplication)) {
                              throw 'Could not launch $num';
                            }
                          },
                          child: Container(
                            height: 48.o,
                            width: 48.o,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.o),
                              color: theme.mainBlue,
                            ),
                            child: SvgPicture.asset(
                              svgIcon.phone,
                              height: 22.o,
                              width: 22.o,
                              colorFilter: theme.colorFilter,
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: 1.o,
                      color: theme.line,
                      margin: EdgeInsets.symmetric(vertical: 12.o),
                    ),
                    item(
                        title: wait.tr,
                        value: '${order.history!.waitCost} so\'m'),
                    for (int i = 0; i < order.services.length; i++)
                      item(
                          title: order.services[i].name,
                          value: order.services[i].cost.toString()),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          total.tr,
                          style: theme.textStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 17.o,
                            color: theme.grey,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${order.history!.cost} so\'m',
                          style: theme.textStyle.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 22.o,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 1.o,
                      color: theme.line,
                      margin: EdgeInsets.symmetric(vertical: 12.o),
                    ),
                  ],
                ),
              Text(
                thisOrder.tr,
                style: theme.textStyle.copyWith(
                  fontSize: 18.o,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (!await launchUrl(Uri.parse(dispacherLink),
                      mode: LaunchMode.externalApplication)) {
                    throw 'Could not launch $num';
                  }
                },
                child: Text(
                  callOperator.tr,
                  style: theme.textStyle.copyWith(
                      fontSize: 18.o,
                      fontWeight: FontWeight.w500,
                      color: theme.blue),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget item({
    required String title,
    required String value,
  }) =>
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: 12.o,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: theme.textStyle.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 17.o,
                color: theme.grey,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: theme.textStyle.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16.o,
              ),
            ),
          ],
        ),
      );
}
