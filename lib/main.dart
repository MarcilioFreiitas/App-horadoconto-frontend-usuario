import 'package:flutter/material.dart';
import 'package:hora_do_conto/views/home.dart';
import 'package:hora_do_conto/views/login-sigup/login.dart';
import 'package:hora_do_conto/views/login-sigup/redefinir_senha.dart';
import 'package:hora_do_conto/widgets/size_config.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'views/login-sigup/home_page.dart';
import 'views/login-sigup/login_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  const IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;
  String? initialLink;

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  void initUniLinks() async {
    _sub = linkStream.listen((String? link) {
      print("Link recebido: $link");
      if (link != null) {
        setState(() {
          initialLink = link;
        });
      }
    }, onError: (err) {
      print(err);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialLink != null) {
      final uri = Uri.parse(initialLink!);
      final token = uri.queryParameters['token'];
      if (token != null) {
        Future.delayed(Duration.zero, () {
          _navigateToResetPassword(token);
        });
      }
    }
    SizeConfig().init(context);
    return MaterialApp(
      title: 'Meu App Flutter',
      navigatorKey: navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/redefinir_senha') {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) {
              return ResetPasswordPage(token: args);
            },
          );
        }
        return null;
      },
      routes: {
        '/': (context) => Home(),
        '/login': (context) => LogIn(),
        // Adicione outras rotas conforme necessário
      },
    );
  }

  void _navigateToResetPassword(String token) {
    navigatorKey.currentState?.pushNamed('/redefinir_senha', arguments: token);
  }
}
