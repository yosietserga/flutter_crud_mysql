import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:fire_crud_mysql/screens/screens.dart';
import 'package:fire_crud_mysql/services/services.dart';
import 'package:fire_crud_mysql/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  if (!kIsWeb) {
  } else {}
  runApp(AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => FichaService())
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login with CRUD',
      initialRoute: CheckAuthScreen.routerName,
      routes: {
        CheckAuthScreen.routerName: (_) => CheckAuthScreen(),
        LoginScreen.routerName: (_) => LoginScreen(),
        RegisterScreen.routerName: (_) => RegisterScreen(),
        HomeScreen.routerName: (_) => HomeScreen(),
      },
      scaffoldMessengerKey: NotificationsService.messengerKey,
      theme: AppTheme.lightTheme,
    );
  }
}
