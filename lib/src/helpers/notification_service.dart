import 'package:app/src/variables/util_variables.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
    notifIntialzed = true;
  }

  Future<void> showNotification(
    int id,
    String title,
    String body,
    String? payload,
  ) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
          android: AndroidNotificationDetails(
            'main_channel',
            'Main Channel',
            importance: Importance.max,
            priority: Priority.max,
            icon: '@mipmap/ic_launcher',
            largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          ),
          iOS: DarwinNotificationDetails(
            sound: 'default.wav',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          )),
      payload: payload,
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> createChannel(String? id) async {
    if (!notifIntialzed) {
      await initNotification();
    }
    id ??= 'EVR_TAXI';
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(AndroidNotificationChannel(
          id.toString(),
          'Evr taxi',
          description: 'ishlamoqda.',
          importance:
              Importance.low, // importance must be at low or higher level
        ));
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    String payload = '';
    if (notificationResponse.payload != null) {
      payload = notificationResponse.payload!;
      if (payload.isNotEmpty) {
        // final context = navigatorKey.currentState?.context;
        // if(context != null){
        //   print('push to see order');
        //   await Navigator.push(
        //     context,
        //     MaterialPageRoute<void>(builder: (context) =>
        //         SeeOrder(order: Order.fromJson(jsonDecode(payload)))),
        //   );
        // }
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('notif_order', payload);
      }
    }
  }
}
