
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../Clients/Client_ScreenShow.dart';

class AboutUsScreenShow extends StatefulWidget {
  const AboutUsScreenShow({super.key});

  @override
  State<AboutUsScreenShow> createState() => _AboutUsScreenShowState();
}

class _AboutUsScreenShowState extends State<AboutUsScreenShow> {

  late final BannerAd bannerAd;
  final String adUnitId = "ca-app-pub-3940256099942544/6300978111";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adUnitId,
        listener: bannerAdListener,
        request: const AdRequest());

    bannerAd.load(); //load ad here
  }

  final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (Ad ad) => Fluttertoast.showToast(msg:"",backgroundColor:Colors.transparent),
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      Fluttertoast.showToast(msg:"Ad Failed to load: $error");
    },
    onAdOpened: (Ad ad) => Fluttertoast.showToast(msg:"Ad opened"),
    onAdClosed: (Ad ad) => Fluttertoast.showToast(msg:"Ad closed"),
    onAdImpression: (Ad ad) => Fluttertoast.showToast(msg:"",backgroundColor:Colors.transparent),
  );

  @override
  void dispose() {

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final AdWidget adwidget = AdWidget(ad: bannerAd);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(0.85)),
      child: Scaffold(
        backgroundColor: const Color(0xffF0F8FF),
        appBar: AppBar(
          title: const Text('A B O U T   U S',style: TextStyle(color: Colors.white),),
          backgroundColor: const Color(0xff2b3d4f),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body:SingleChildScrollView(
          child: PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) async {
              if (didPop) {
                return;
              }
              if (context.mounted) {
                Navigator.of(context).pop();
              }
             },
            child: Column(
              children: [
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      gradient: LinearGradient(
                        colors: [Color(0xff95a6a7), Color(0xff2b3d4f)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                          Image.asset('assets/images/vivek xess.png',
                              height: 200,width: 100),
                          Image.asset('assets/images/badal pradhan.png',
                              height: 200,width: 100),
                          Image.asset('assets/images/Gaurav Kumar.png',
                              height: 200,width: 100),
                      ],
                    ),
                  ),
                ),

                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1 ,
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      gradient: LinearGradient(
                        colors: [Color(0xff95a6a7), Color(0xff2b3d4f)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "\nWelcome to VrkahDev Technology, your trusted partner in navigating the ever-evolving landscape of information technology At VrkahTech , we are committed to delivering innovative solutions that empower businesses to thrive in the digital age With a focus on cutting-edge technology and unwavering dedication to client satisfaction, we strive to exceed expectations and drive success Our journey began with a vision to revolutionize the way businesses harness the power of technology. Since our inception, we have grown into a dynamic team of experts, united by a passion for innovation and a relentless pursuit of excellence.\n\n@VrkahDev Technology Private Limited",
                       textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),
                      ),
                    ),

                  ),
                ),
                //--------------------------------------------------------------------Ad is here-------------------------------------

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(
                      color: const Color(0xff2b3d4f),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SizedBox(
                      height: bannerAd.size.height.toDouble(),
                      width: bannerAd.size.width.toDouble(),
                      child: adwidget,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

