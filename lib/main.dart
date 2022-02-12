//https://picsum.photos/200/300   //  ⌘ ñ
//use lint
//import '../widget/detailscreen.dart';
// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overcome_breakup/constants/unityads.dart';
import './screens/home_screens.dart';
import 'widgets/home_page_widget.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
  HttpOverrides.global = MyHttpOverrides();
  // Admob.initialize();
  FacebookAudienceNetwork.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'homepage',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      routes: {
        HomePageWidget.routeName: (ctx) => HomePageWidget(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        UnityAdsPage.routeName: (ctx) => UnityAdsPage(),
      },
    );
  }
}
