import 'dart:io';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:news/data/api/api_service.dart';
import 'package:news/data/db/database_helper.dart';
import 'package:news/data/model/article.dart';
import 'package:news/data/preferences/preferences_helper.dart';
import 'package:news/navigation.dart';
import 'package:news/provider/database_provider.dart';
import 'package:news/provider/news_provider.dart';
import 'package:news/provider/preferences_provider.dart';
import 'package:news/provider/scheduling_provider.dart';
import 'package:news/ui/detail_page.dart';
import 'package:news/ui/home_page.dart';
import 'package:news/styles.dart';
import 'package:news/utils/background_service.dart';
import 'package:news/utils/notification_helper.dart';
import 'package:news/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NewsProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(create: (_) => SchedulingProvider()),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper())
        ),
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'News App',
            theme: provider.themeData,
            navigatorKey: navigatorKey,
            initialRoute: HomePage.routeName,
            routes: {
              HomePage.routeName: (context) => HomePage(),
              ArticleDetailPage.routeName: (context) => ArticleDetailPage(
                article: ModalRoute.of(context)?.settings.arguments as Article,
              ),
            },
          );
        },
      ),
    );
  }
}