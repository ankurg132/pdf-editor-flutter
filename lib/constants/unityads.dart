// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:overcome_breakup/screens/home_screens.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class UnityAdsPage extends StatelessWidget {
  // var UnityAds;

  UnityAdsPage({Key? key}) : super(key: key);
  static const routeName = '/unityads';
  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('UNITY ADS'),
      ),
      body: Column(
        children: [
          Center(
            child: TextButton(
                onPressed: () {
                  UnityAds.showVideoAd(
                      placementId: AdManager.rewardedVideoAdPlacementId);
                },
                child: const Text(
                  'See Revarded Ads',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                )),
          ),
          SizedBox(height: mediaquery.height * 0.05),
          Center(
            child: TextButton(
                onPressed: () {
                  UnityAds.showVideoAd(
                      placementId: AdManager.interstitialVideoAdPlacementId);
                },
                child: const Text(
                  'See Interstial Ads',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                )),
          ),
          SizedBox(height: mediaquery.height * 0.05),
          Text(
            'Banner Ads 👇',
            style: const TextStyle(
              fontSize: 30,
            ),
          ),
          Bannerads(),
          Bannerads(),
          Bannerads(),
          Bannerads(),
          Bannerads(),
          Bannerads(),
          UnityBannerAd(
            placementId: AdManager.bannerAdPlacementId,
            // size: AdSize.banner,
          ),
        ],
      ),
      //floatingActionButton: FloatingActionButton(onPressed: (){},),
    );
  }
}

class Bannerads extends StatelessWidget {
  const Bannerads({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnityBannerAd(
      placementId: AdManager.bannerAdPlacementId,
      // size: AdSize.banner,
    );
  }
}
