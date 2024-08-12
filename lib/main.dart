import 'dart:convert';

import 'package:coinapp/models/app_config.dart';
import 'package:coinapp/pages/home_page.dart';
import 'package:coinapp/services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadConfig();
  registerHTTPservices();
  await locator.get<HTTPServices>().get("/coins/bitcoin");
  runApp(const MyApp());
}

GetIt locator = GetIt.instance;

Future<void> loadConfig () async{
  String _configContent =await rootBundle.loadString("assets/config/main.json");
  Map _configData =jsonDecode(_configContent);
  locator.registerSingleton<appConfig>(appConfig(COIN_API_BASE_URL: _configData["COIN_API_BASE_URL"]));
}

void registerHTTPservices(){
  locator.registerSingleton<HTTPServices>(HTTPServices(),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue,
        useMaterial3: true,
   
      ),
      home: const homePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}