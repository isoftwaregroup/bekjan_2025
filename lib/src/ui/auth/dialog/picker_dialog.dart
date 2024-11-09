import 'package:app/src/utils/utils.dart';
import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:app/src/widgets/PickerWidget.dart';
import 'package:flutter/material.dart';

import '../../../helpers/apptheme.dart';

/// Oy va kun husobi 1 dan boshlanadi va oyning maksimal qiymati 12
/// Sanaga tanlashda chegara maksimal va minimal chegaralarni o'rnatishingiz mumkin.
/// Agar maksimal yilning qiymati null bo'lsa maksimal oyning va maksimal kunning qiymati ishlamaydi.
/// Agar maksimal oyning qiymati null bo'lsa maksimal kunning qiymati ishlamaydi.
/// Agar minimal yilning qiymati null bo'lsa minimal oyning va minimal kunning qiymati ishlamaydi.
/// Agar minimal oyning qiymati null bo'lsa minimal kunning qiymati ishlamaydi.

class PickerDialog extends StatefulWidget {
  final String title;
  final int? maxYear, minYear, maxMonth, minMonth, minDay, maxDay;
  final Function(int year, int mounth, int day) selected;

  const PickerDialog({
    Key? key,
    required this.selected,
    required this.title,
    this.maxYear,
    this.minYear,
    this.maxMonth,
    this.minMonth,
    this.minDay,
    this.maxDay,
  })  : assert(maxYear == null || minYear == null || maxYear > minYear),
        assert(maxMonth == null || minMonth == null || maxMonth > minMonth),
        assert(maxDay == null || minDay == null || maxDay > minDay),
        super(key: key);

  @override
  _PickerDialogState createState() => _PickerDialogState();
}

class _PickerDialogState extends State<PickerDialog> {
  DateTime date = DateTime.now();
  int currentMonth = 1;
  int year = 1;
  int mouth = 1;
  int day = 1;
  List<int> yearData = [];
  List<String> monthData = mounths;
  List<int> days = [];

  @override
  void initState() {
    setDateTimeLimit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 15.h,
        bottom: 15.h,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.h),
            topRight: Radius.circular(20.h),
          ),
          color: theme.cardBackground),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 20.h,
              bottom: 10.h,
            ),
            child: Text(
              widget.title,
              style: theme.textStyle
                  .copyWith(fontSize: 22.o, fontWeight: FontWeight.w500),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PickerWidet(
                    itemWidth: 100.w,
                    itemHeight: 40.h,
                    itemCount: days.length,
                    currentIndex: date.day,
                    builder: (context, index, isSelected) {
                      return Text(
                        days[index].toString(),
                        style: theme.textStyle.copyWith(
                          fontSize: isSelected ? 22.o : 16.o,
                          color: isSelected ? theme.text : theme.grey,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      );
                    },
                    onChange: (index) {
                      setState(() {
                        day = days[index];
                        date = DateTime(date.year, date.month, days[index]);
                      });
                    },
                  ),
                  PickerWidet(
                    itemWidth: 130.w,
                    itemHeight: 40.h,
                    itemCount: mounths.length,
                    currentIndex: currentMonth,
                    builder: (context, index, isSelected) {
                      return Text(
                        mounths[index],
                        style: theme.textStyle.copyWith(
                          fontSize: isSelected ? 22.o : 16.o,
                          color: isSelected ? theme.text : theme.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                    onChange: (index) {
                      date = DateTime(date.year, index + 1, date.day);
                      mouth = index + 1;
                      if (widget.minYear != null && widget.minMonth != null) {
                        mouth += widget.minMonth!;
                      }
                      final lastDay =
                          DateTime(date.year, date.month + 1, 0).day;
                      days = [for (var i = 1; i <= lastDay; i++) i];
                      setState(() {});
                    },
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  PickerWidet(
                    itemWidth: 120.w,
                    itemHeight: 40.h,
                    itemCount: yearData.length,
                    currentIndex: yearData.length - 2,
                    builder: (context, index, isSelected) {
                      return Text(
                        '${yearData[index]}',
                        style: theme.textStyle.copyWith(
                          fontSize: isSelected ? 22.o : 16.o,
                          color: isSelected ? theme.text : theme.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                    onChange: (index) {
                      setState(() {
                        date =
                            DateTime(yearData[index], date.month + 1, date.day);
                        year = yearData[index];
                        if (index == yearData.length - 1) {
                          setDateTimeLimit();
                        } else {
                          monthData = mounths;
                          final lastDay =
                              DateTime(date.year, date.month + 1, 0).day;
                          days = [for (var i = 1; i <= lastDay; i++) i];
                        }
                      });
                    },
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 1.h,
                    width: 520.w,
                    color: theme.line.withOpacity(0.5),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Container(
                    height: 1.h,
                    width: 520.w,
                    color: theme.line.withOpacity(0.5),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40.h,
                    margin: EdgeInsets.only(
                      top: 5.h,
                      left: 20.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.o),
                      color: theme.line,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      cancel.tr,
                      style: theme.textStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.o,
                        color: theme.text.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 30.w,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    widget.selected(year, mouth, day);
                    print('$day.$mouth.$year');
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40.h,
                    margin: EdgeInsets.only(
                      top: 5.h,
                      right: 20.w,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.o),
                        color: theme.yellow),
                    alignment: Alignment.center,
                    child: Text(
                      save.tr,
                      style: theme.textStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.o,
                        color: const Color(0xFF302E2B),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void setDateTimeLimit() {
    int maxYear = date.year,
        maxMonth = 12,
        maxDay = 31,
        minYear = date.year - 120,
        minMonth = 1,
        minDay = 1;
    if (widget.minYear != null) {
      minYear = widget.minYear! - 120;
      if (widget.minMonth != null) {
        if (widget.minMonth! > 0) {
          minMonth = widget.minMonth!;
          if (widget.minDay != null) {
            if (widget.minDay! > 0) {
              minDay = widget.minDay!;
            }
          }
        }
      }
      if (date.year <= minYear) {
        /// ushbu soha real holatda ishlamaydi.
        /// ammo vaqti noto'g'ri qurimalar uchun ehtiyot shart yozilmoqda
        int settedMonth = date.month + 1, settedDay = date.day;
        if (date.year == minYear && date.month <= minMonth) {
          settedMonth = minMonth;
          if (date.month == minMonth && date.day < minDay) {
            settedDay = minDay;
          }
        }
        date = DateTime(minYear, settedMonth, settedDay);
      }
    }
    if (widget.maxYear != null) {
      maxYear = widget.maxYear!;
      if (widget.maxMonth != null) {
        if (widget.maxMonth! <= 12) {
          maxMonth = widget.maxMonth!;
          if (widget.maxDay != null) {
            if (widget.maxDay! <= 31) {
              maxDay = widget.maxDay!;
            }
          }
        }
      }
      if (date.year >= maxYear) {
        int settedMonth = date.month + 1, settedDay = date.day;
        if (date.year == maxYear && date.month >= maxMonth) {
          settedMonth = maxMonth;
          if (date.month == maxMonth && date.day > maxDay) {
            settedDay = maxDay;
          }
        }
        date = DateTime(maxYear, settedMonth, settedDay);
      }
    }
    yearData = [for (var i = minYear; i <= maxYear; i++) i];
    monthData = [for (var i = minMonth; i <= maxMonth; i++) mounths[i - 1]];
    final lastDay = DateTime(date.year, date.month + 1, 0).day;
    if (lastDay < maxDay) {
      maxDay = lastDay;
    }
    days = [for (var i = minDay; i <= maxDay; i++) i];
    setState(() {
      if (date.month > 1) {
        currentMonth = date.month;
      }
    });
  }
}
