import 'package:chatify/services/cloud_storage_services.dart';
import 'package:chatify/services/database_services.dart';
import 'package:chatify/services/media_services.dart';
import 'package:chatify/services/navigation_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;
  const SplashPage({
    required Key? key,
     required this.onInitializationComplete,
  }) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState()
  {
    super.initState();
    Future.delayed(const Duration(seconds:1 ,)).then((_)
    {
      _setup().then((_) => widget.onInitializationComplete(),);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat',
      theme: ThemeData(
        //backgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
        scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
        ),
      home: Scaffold(
        body: Center(
            child: Container(
              height: 280,
              width: 280,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(200),
                image: DecorationImage(
                  image:AssetImage(
                    'assets/images/logo.webp',
                  ) ,
                  fit:BoxFit.cover ,
                ),
              ),
            )),
        // body: Center(
        //   child: CircleAvatar(
        //     radius: 120,
        //     backgroundImage: AssetImage(
        //       'assets/images/logo.webp',
        //     ),
        //   ),
        // ),
      ),
      );
  }
  Future<void> _setup() async
  {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    _registerServices();
  }
  void _registerServices()
  {
    GetIt.instance.registerSingleton<NavigationServices>(
      NavigationServices(),
    );

    GetIt.instance.registerSingleton<MediaServices>(
      MediaServices(),
    );

    GetIt.instance.registerSingleton<CloudStorageServices>(
      CloudStorageServices(),
    );

    GetIt.instance.registerSingleton<DatabaseServices>(
      DatabaseServices(),
    );
  }
}
