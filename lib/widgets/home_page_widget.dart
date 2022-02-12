// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:overcome_breakup/constants/colors.dart';
import 'package:overcome_breakup/screens/home_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'delete.dart';

bool first = false;
bool second = false;
bool third = false;
int counter = 0;
late int currPage;
late List<bool> taskData = [first, second, third];

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);
  static const routeName = '/homepagewidget';
  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  @override
  void initState() {
    super.initState();
    sharedPref();
  }

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    final List<dynamic> both =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final List<dynamic> task = both[0] as List<dynamic>;
    currPage = both[1] as int;
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: MyColors.primaryColor,
            title: Text('💘 Daily Tasks 💘'),
            leading: IconButton(
              icon: Icon(Icons.navigate_before),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, HomeScreen.routeName, (route) => false),
            ),
          ),
          backgroundColor: MyColors.backColor,
          body: SingleChildScrollView(
            child: SizedBox(
              height: mediaquery.height * 0.9,
              child: ListView.builder(
                itemCount: task.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    ExpansionTile(
                        title: Text(''' ${task[index]["title"]} 👇''',
                            style: TextStyle(
                              fontSize: 20,
                              overflow: TextOverflow.ellipsis,
                            )),
                        initiallyExpanded: index == 0 ? true : false,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Text(
                                  '''    ${task[index]["description"]}
                              ''',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                task[index]["url"] != null
                                    ? TextButton(
                                        child: Text('Click Here'),
                                        onPressed: () =>
                                            launch(task[index]["url"]))
                                    : Text(''),
                                Row(
                                  children: [
                                    // Flex(direction: direction)
                                    Spacer(
                                      flex: 2,
                                    ),
                                    Center(
                                      child: Text(
                                        '💘💘❌💘💘',
                                      ),
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        taskData[index] ||
                                                currPage < daysCompleted
                                            ? null
                                            : AwesomeDialog(
                                                dismissOnBackKeyPress: false,
                                                showCloseIcon: false,
                                                dismissOnTouchOutside: false,
                                                context: context,
                                                dialogType: DialogType.QUESTION,
                                                animType: AnimType.BOTTOMSLIDE,
                                                title: 'Are you Sure?',
                                                btnCancelOnPress: () {
                                                  FacebookInterstitialAd
                                                      .loadInterstitialAd(
                                                    placementId:
                                                        FacebookAdManager.getInterstitialAdUnitId,
                                                    listener: (result, value) {
                                                      if (result ==
                                                          InterstitialAdResult
                                                              .LOADED)
                                                        FacebookInterstitialAd
                                                            .showInterstitialAd(
                                                                delay:50);
                                                    },
                                                  );
                                                },
                                                btnOkText: 'OK',
                                                btnCancelText: 'NO',
                                                btnOkColor: Theme.of(context)
                                                    .primaryColor,
                                                btnOkOnPress: () async {
                                                  final Future<
                                                          SharedPreferences>
                                                      _prefs = SharedPreferences
                                                          .getInstance();
                                                  final SharedPreferences
                                                      prefs = await _prefs;
                                                  print("Before");
                                                  print(
                                                      prefs.getInt('counter'));
                                                  print(prefs.getBool('first'));
                                                  print(
                                                      prefs.getBool('second'));
                                                  print(prefs.getBool('third'));
                                                  print(index);
                                                  if (index == 0)
                                                    prefs.setBool(
                                                        'first', true);
                                                  if (index == 1)
                                                    prefs.setBool(
                                                        'second', true);
                                                  if (index == 2)
                                                    prefs.setBool(
                                                        'third', true);
                                                  prefs.setInt(
                                                      'counter', counter + 1);
                                                  counter++;
                                                  setState(() {
                                                    taskData[index] = true;
                                                  });
                                                  // print(prefs.getInt('counter'));
                                                  // print(prefs.getBool('first'));
                                                  // print(prefs.getBool('second'));
                                                  // print(prefs.getBool('third'));
                                                  // print(taskData);
                                                  daysCompleted =
                                                      (counter / 3).floor();
                                                  FacebookInterstitialAd
                                                      .loadInterstitialAd(
                                                    placementId:
                                                        FacebookAdManager.getInterstitialAdUnitId,
                                                    listener: (result, value) {
                                                      if (result ==
                                                          InterstitialAdResult
                                                              .LOADED)
                                                        FacebookInterstitialAd
                                                            .showInterstitialAd(
                                                                delay:50);
                                                    },
                                                  );
                                                },
                                              ).show();
                                      },
                                      child: Text(
                                        taskData[index] ||
                                                currPage < daysCompleted
                                            ? 'Complete ✔ '
                                            : 'Mark Complete ',
                                        style: TextStyle(
                                            color: (taskData[index] ||
                                                    currPage < daysCompleted
                                                ? Colors.green
                                                : Colors.red)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ]),
                    SizedBox(height: 10),
                    FacebookBannerAd(placementId: FacebookAdManager.getBannerAdUnitId,
                        bannerSize: BannerSize.STANDARD,),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

void sharedPref() async {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  // print("INIT");
  // print(prefs.getInt('counter'));
  // print(prefs.getBool('first'));
  // print(prefs.getBool('second'));
  // print(prefs.getBool('third'));
  counter = prefs.getInt('counter') ?? 0;
  first = prefs.getBool('first') ?? false;
  second = prefs.getBool('second') ?? false;
  third = prefs.getBool('third') ?? false;
  if (prefs.getBool('first') == null) {
    prefs.setBool('first', false);
  }
  if (prefs.getBool('second') == null) {
    prefs.setBool('second', false);
  }
  if (prefs.getBool('third') == null) {
    prefs.setBool('third', false);
  }
  taskData = [first, second, third];
}
