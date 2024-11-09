import 'package:app/src/ui/account/provider.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../helpers/apptheme.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  void initState() {
    userNotifier.getFAQ();
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
          myOrders.tr,
          style: theme.textStyle.copyWith(
              fontWeight: FontWeight.w500, fontSize: 20.o, color: theme.text),
        ),
      ),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final faqs = ref.watch(userProvider).faqs;
          return ListView.builder(
            //itemCount: faqs.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // if(selectedIndex == index){
                  //   selectedIndex = -1;
                  // }else{
                  //   selectedIndex = index;
                  // }
                  // userNotifier.update();
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10.o),
                  padding: EdgeInsets.all(15.o),
                  decoration: BoxDecoration(
                    color: theme.secondary,
                    borderRadius: BorderRadius.circular(16.o),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '13- Avgust, 00:30',
                            style: theme.textStyle.copyWith(
                              fontSize: 16.o,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '13 000 UZS',
                            style: theme.textStyle.copyWith(
                              fontSize: 16.o,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.o,
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
                          Text(
                            'Chilonzor 12-uy 5-Qavat',
                            style: theme.textStyle.copyWith(
                              fontSize: 16.o,
                              fontWeight: FontWeight.w400,
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
                          Text(
                            'Chilonzor 12-uy 5-Qavat',
                            style: theme.textStyle.copyWith(
                              fontSize: 16.o,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
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
}
