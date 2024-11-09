import 'package:app/src/helpers/apptheme.dart';
import 'package:app/src/network/client.dart';
import 'package:app/src/network/http_result.dart';
import 'package:app/src/ui/dialogs/warning_dialog.dart';
import 'package:app/src/ui/home_page/models/service_model.dart';
import 'package:app/src/ui/home_page/provider/home_provider.dart';
import 'package:app/src/ui/home_page/util.dart';
import 'package:app/src/variables/icons.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/links.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

class RatingDialog extends StatefulWidget {
  final Map<String, dynamic> data;
  const RatingDialog({
    super.key,
    required this.data,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  bool haveComment = false;
  String commentText = '';
  double settdRating = 0;
  List<SericeModel> services = [];

  @override
  void initState() {
    getOrderServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double bottom = MediaQuery.of(context).viewInsets.bottom - 80.o;
    if (bottom < 0) {
      bottom = 0;
    }
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.o,
          vertical: 25.o,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgIcon.down,
              height: 10.o,
              width: 10.o,
              colorFilter: theme.greyFilter,
            ),
            SizedBox(
              height: 10.o,
            ),
            if (bottom == 0)
              Column(
                children: [
                  Text(
                    orderCompleted.tr,
                    style: theme.textStyle.copyWith(
                      fontSize: 24.o,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 15.o,
                  ),
                  SvgPicture.asset(
                    svgIcon.markerLocation,
                    height: 110.o,
                    width: 110.o,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 15.o,
                      top: 16.o,
                    ),
                    width: 300.o,
                    decoration: theme.greyDecor.copyWith(
                      borderRadius: BorderRadius.circular(15.o),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 10.o),
                        item(
                            title: wait.tr,
                            value: widget.data['wait_cost'].toString()),
                        for (int i = 0; i < services.length; i++)
                          item(
                              title: services[i].name,
                              value: services[i].cost.toString()),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.o,
                            horizontal: 20.o,
                          ),
                          child: Row(
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
                                widget.data['cost'].toString(),
                                style: theme.textStyle.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22.o,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.o),
                        GestureDetector(
                          onTap: () async {
                            MainModel result =
                                await client.post(Links.payFromBonus);
                            showResult(result.message);

                            // showDialog(context: context,
                            //   builder: (BuildContext context) {
                            //     return WarningDialog(
                            //       message: sureCancel.tr,
                            //       onNext: () async {
                            //
                            //       },
                            //     );
                            //   },
                            // );
                          },
                          child: Container(
                            width: 300.o,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              vertical: 10.o,
                              horizontal: 16.o,
                            ),
                            decoration: BoxDecoration(
                                color: theme.yellow,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15.o),
                                  bottomRight: Radius.circular(15.o),
                                )),
                            child: Text(
                              payBonus.tr,
                              style: theme.textStyle.copyWith(
                                fontSize: 16.o,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            Text(
              ratingDriver.tr,
              style: theme.textStyle.copyWith(
                fontSize: 22.o,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 12.o,
            ),
            RatingBar.builder(
              initialRating: settdRating,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 15.w),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                settdRating = rating;
              },
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: 15.o,
                top: 12.o,
              ),
              height: 50.o,
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              decoration: theme.greyDecor,
              child: Column(
                children: [
                  Expanded(
                    child: TextField(
                      maxLines: 4,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: theme.textStyle.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.h,
                          color: theme.line,
                        ),
                        hintText: comment.tr,
                      ),
                      style: theme.textStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 15.o,
                      ),
                      onChanged: (txt) {
                        commentText = txt;
                      },
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: setRating,
              child: Container(
                height: 50.o,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.o),
                  color: theme.yellow,
                ),
                margin: EdgeInsets.only(bottom: bottom),
                child: Text(
                  save.tr,
                  style: theme.textStyle.copyWith(
                    fontSize: 17.o,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                client.post(Links.skipRating);
              },
              child: Container(
                height: 50.o,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 5.o),
                child: Text(
                  skip.tr,
                  style: theme.textStyle.copyWith(
                    fontSize: 17.o,
                    fontWeight: FontWeight.w600,
                    color: theme.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget item({
    required String title,
    required String value,
  }) =>
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: 12.o,
          horizontal: 20.o,
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

  Widget get line => Container(
        width: 600.w - 30.o,
        height: 1.5.o,
        color: theme.line,
      );

  void getOrderServices() async {
    services = await getServices();
    setState(() {});
  }

  void setRating() {
    client.post(
      Links.rating,
      data: {'star': settdRating.toInt(), 'comment': commentText},
    ).then((value) {
      homeNotifier.conditionKey = '';
      homeNotifier.update();
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      Navigator.pop(context);
    });
  }

  void showResult(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WarningDialog(
          btnRight: ok.tr,
          message: message,
          isOne: true,
          onNext: () {},
        );
      },
    );
  }
}
