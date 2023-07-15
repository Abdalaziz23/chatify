import 'package:chatify/pages/home_page.dart';
import 'package:chatify/pages/login_page.dart';
import 'package:chatify/pages/register_page.dart';
import 'package:chatify/pages/splash_page.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/services/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(SplashPage(
    key: UniqueKey(),
    onInitializationComplete: (){
      runApp(MainApp(),);
    },
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:
      [
        ChangeNotifierProvider<AuthenticationProvider>(create: (BuildContext context)
        {
          return AuthenticationProvider();
        },),
      ],
      child: MaterialApp(
        title: 'Chat',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor:Color.fromRGBO(30, 29, 37, 1.0) ,
          ),
        ),
        navigatorKey: NavigationServices.navigatorKey,
        initialRoute: '/login',
        routes: {
          '/login': (BuildContext context) => const LoginPage(),
          '/register': (BuildContext context) => const RegisterPage(),
          '/home': (BuildContext context) => const HomePage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
