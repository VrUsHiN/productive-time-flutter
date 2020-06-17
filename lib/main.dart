import 'package:flutter/material.dart';
import 'package:productivetimeflutter/providers/items_provider.dart';
import 'package:productivetimeflutter/providers/theme_provider.dart';
import 'package:productivetimeflutter/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//const int _blackPrimaryValue = 0xFF000000;
//const MaterialColor primaryBlack = MaterialColor(
//  _blackPrimaryValue,
//  <int, Color>{
//    50: Color(0xFF000000),
//    100: Color(0xFF000000),
//    200: Color(0xFF000000),
//    300: Color(0xFF000000),
//    400: Color(0xFF000000),
//    500: Color(_blackPrimaryValue),
//    600: Color(0xFF000000),
//    700: Color(0xFF000000),
//    800: Color(0xFF000000),
//    900: Color(0xFF000000),
//  },
//);//LATER FOR DARK THEMES

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future selectNotification(String payload) async {
    //TODO: IMPLEMENT WHAT HAPPENS ON CLICKING THE NOTIFICATION
  }

  void initialiseNotification() async {
    flutterLocalNotificationsPlugin.cancelAll();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  void scheduleNotification(Time time) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      'Hello mate!',
      'How\'s your day going?   :)',
      time,
      platformChannelSpecifics,
    );
  }

  MyApp() {
    initialiseNotification();
    scheduleNotification(Time(10, 0, 0));
    scheduleNotification(Time(5, 0, 0));
    //scheduleNotification(Time(9,43,0));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ItemsProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: CustomThemeApp(),
    );
  }
}

class CustomThemeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<ThemeProvider>(context, listen: false)
          .initialisePreferences(),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : MaterialApp(
                title: 'Productive Time',
                theme: Provider.of<ThemeProvider>(context).themeData,
                home: MainScreen(),
              );
      },
    );
  }
}
