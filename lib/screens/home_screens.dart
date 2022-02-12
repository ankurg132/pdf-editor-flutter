// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable, avoid_print

import 'dart:async' show Future;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:overcome_breakup/constants/colors.dart';
import 'package:overcome_breakup/constants/unityads.dart';
import 'package:overcome_breakup/widgets/home_page_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart' as unity_ads_plugin;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/homescreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

int daysCompleted = 0;

class FacebookAdManager {
  static String get getBannerAdUnitId {
    return '616737582947184_619185919369017';
  }

  static String get getInterstitialAdUnitId {
    return '616737582947184_616740896280186';
  }
}

class _HomeScreenState extends State<HomeScreen> {
  List data = [];
  bool isLoading = true;

  Future<String> loadJsonData() async {
    // var jsonText = await rootBundle.loadString('assets/data.json');
    var jsonText = await http.get(Uri.parse(
        "https://raw.githubusercontent.com/ankurg132/ankurg132.github.io/master/data.json"));
    print(jsonText);
    setState(() => data = json.decode(jsonText.body));
    setState(() {
      isLoading = false;
    });
    return 'success';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sharedpref();
  }

  @override
  void initState() {
    super.initState();
    // print("INITHOMEMAIN");
    unity_ads_plugin.UnityAds.init(
      gameId: AdManager.gameId,
      // testMode: true,
      onComplete: () => print(
          '-------------------Initialization Complete-------------------'),
      onFailed: (error, message) =>
          print('-------------------Initialization Failed-------------------'),
    );

    if (data.isEmpty) {
      loadJsonData();
    }
    sharedpref();
  }

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        title: const Text('BreakUp Overcome'),
      ),
      backgroundColor: MyColors.backColor,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 50),
                    height: mediaquery.height * 0.9,
                    child: GridView.builder(
                      itemCount: data.length,
                      itemBuilder: (ctx, index) =>
                          HomePageCard(index: index, data: data),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2 / 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                    ),
                  ),
                ],
              ),
            ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'BreakUp Overcome',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              decoration: BoxDecoration(
                color: MyColors.primaryColor,
              ),
            ),
            ListTile(
              title: Text('About'),
              onTap: () {
                const snackBar = SnackBar(
                  content: Text(
                      'Developed by The Breakup Association for the Overcome of Breakup'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
            ListTile(
              title: Text('View Ads to Support Us'),
              onTap: () {
                unity_ads_plugin.UnityAds.showVideoAd(
                    placementId: AdManager.interstitialVideoAdPlacementId);
              },
            ),
            // ListTile(
            //   title: Text('Open Unity Ads Page'),
            //   onTap: () {
            //     // UnityAds.showVideoAd(placementId: 'Interstitial_Android');
            //     Navigator.of(context).pushNamed(
            //       UnityAdsPage.routeName,
            //     );
            //   },
            // ),
          ],
        ),
      ),
      // bottomNavigationBar: UnityBannerAd(
      //   placementId: AdManager.bannerAdPlacementId,
      // size: AdSize.banner,
      bottomNavigationBar: FacebookBannerAd(
        placementId: FacebookAdManager.getBannerAdUnitId,
        bannerSize: BannerSize.STANDARD,
      ),
    );
  }
}

class AdManager {
  static String get gameId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return '4601948';
    }
    // if (defaultTargetPlatform == TargetPlatform.iOS) {
    //   return 'your_ios_game_id';
    // }
    return '';
  }

  static String get bannerAdPlacementId {
    return 'Banner_Android';
  }

  static String get interstitialVideoAdPlacementId {
    return 'Interstitial_Android';
  }

  static String get rewardedVideoAdPlacementId {
    return 'Rewarded_Android';
  }
}

void sharedpref() async {
  print("INITHOME");
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  if (prefs.getInt('counter') == null) {
    prefs.setInt('counter', 0);
  }
  int counter = prefs.getInt('counter') ?? 0;
  daysCompleted = (counter / 3).floor();
  print("DAYS" + daysCompleted.toString());
}

class HomePageCard extends StatelessWidget {
  const HomePageCard({
    Key? key,
    required this.index,
    required this.data,
  }) : super(key: key);
  final int index;
  final List data;
  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    return InkWell(
      onTap: () async {
        // UnityAds.showVideoAd(placementId: 'Interstitial_Android');
        if (index > daysCompleted) {
          AwesomeDialog(
            dismissOnBackKeyPress: false,
            showCloseIcon: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE, //awesome_dialog: ^2.1.1
            title: 'Please Complete previous $index days',
            btnOkText: 'OK',
            btnOkColor: Theme.of(context).primaryColor,
            btnCancelOnPress: () async {
              FacebookInterstitialAd.loadInterstitialAd(
                placementId: FacebookAdManager.getInterstitialAdUnitId,
                listener: (result, value) {
                  if (result == InterstitialAdResult.LOADED)
                    FacebookInterstitialAd.showInterstitialAd(delay: 50);
                },
              );
            },
            btnOkOnPress: () async {
              FacebookInterstitialAd.loadInterstitialAd(
                placementId: FacebookAdManager.getInterstitialAdUnitId,
                listener: (result, value) {
                  if (result == InterstitialAdResult.LOADED)
                    FacebookInterstitialAd.showInterstitialAd(delay: 50);
                },
              );
              // UnityAds.showVideoAd(placementId: 'Interstitial_Android');
            },
          ).show();
        } else {
          final Future<SharedPreferences> _prefs =
              SharedPreferences.getInstance();
          final SharedPreferences prefs = await _prefs;
          if (daysCompleted >= index) {
            if (daysCompleted == index &&
                prefs.getBool('first') == true &&
                prefs.getBool('second') == true &&
                prefs.getBool('third') == true) {
              taskData = [false, false, false];
              prefs.setBool('first', false);
              prefs.setBool('second', false);
              prefs.setBool('third', false);
            }
            Navigator.pushNamed(context, HomePageWidget.routeName,
                arguments: [data[index]["task"], index]);
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          color: daysCompleted >= index ? Colors.green[100] : Colors.white,
          elevation: 5,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: mediaquery.height * 0.15,
                child: daysCompleted == index
                    ? Image.asset(
                        'assets/healing.jpg',
                        fit: BoxFit.fill,
                      )
                    : daysCompleted > index
                        ? Image.asset(
                            'assets/fixed.png',
                            fit: BoxFit.fill,
                          )
                        : Image.asset(
                            'assets/broken.png',
                            fit: BoxFit.contain,
                          ),
              ),
              Spacer(
                flex: 2,
              ),
              Center(
                child: Row(
                  children: [
                    Spacer(),
                    Text(
                      "Day ",
                      style: TextStyle(
                          fontSize: mediaquery.height * 0.02,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '''${index + 1}  ''',
                      style: TextStyle(
                          fontSize: mediaquery.height * 0.02,
                          fontWeight: FontWeight.bold),
                    ),
                    daysCompleted == index
                        ? Icon(Icons.favorite_border)
                        : daysCompleted > index
                            ? Icon(Icons.check)
                            : Icon(
                                Icons.lock_clock_outlined,
                                color: Colors.grey,
                                size: 30,
                              ),
                    Spacer(),
                  ],
                ),
              ),
              Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void log(String string) {
  print(string);
}
