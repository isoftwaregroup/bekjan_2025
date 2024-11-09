import 'package:app/src/helpers/apptheme.dart';
import 'package:app/src/helpers/log/event_provider.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final notifier = ref.watch(eventProvider);

            return Padding(
              padding: EdgeInsets.all(20.o),
              child: Stack(
                children: [
                  ListView.builder(
                    itemCount: notifier.list.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            notifier.list[index],
                            maxLines: 100,
                            style: theme.textStyle.copyWith(
                              fontSize: 14.o,
                            ),
                          ),
                          Container(
                            height: 2.o,
                            color: theme.line,
                            margin: EdgeInsets.symmetric(
                              vertical: 10.o,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: notifier.clear,
                      child: Container(
                        width: 60.o,
                        height: 60.o,
                        margin: EdgeInsets.only(
                          bottom: 20.o,
                        ),
                        decoration: theme.cardDecor
                            .copyWith(borderRadius: BorderRadius.circular(30)),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.clear,
                          color: theme.text,
                          size: 24.o,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
