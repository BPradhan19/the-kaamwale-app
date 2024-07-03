import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:thekaamwale/Clients/Clients_ProfileShow.dart';
import 'package:thekaamwale/Credential/Login_ScreenShow.dart';
import 'package:thekaamwale/Clients/SelectWorkers_ScreenShow.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../Workers/AboutUs_ScreenShow.dart';
import 'Client_Profile_Exists.dart';

class FAQ {
  final String question;
  final String answer;

  FAQ({
    required this.question,
    required this.answer,
  });
}

class Client_ScreenShow extends StatefulWidget {
  const Client_ScreenShow({super.key});

  @override
  State<Client_ScreenShow> createState() => _Client_ScreenShowState();
}

class _Client_ScreenShowState extends State<Client_ScreenShow> {
  late final BannerAd bannerAd;
  final String adUnitId = "ca-app-pub-3940256099942544/6300978111";//CC89A94ABBABDB91FB8A678340063412

  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Future.delayed(const Duration(seconds: 1), () => showFillFormDialog(context));
    //-----------------------------------------------videoplayer---------------------------------------------------------------
    _videoPlayerController =
        VideoPlayerController.asset('assets/images/kwclient.mp4');
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      allowMuting: true,
      aspectRatio: 16 / 9,
    );
    // -----------------------------------------------------------------Ads part------------------------------------------------------
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
      Fluttertoast.showToast(msg:"Ad Failed to load");
    },
    onAdOpened: (Ad ad) => Fluttertoast.showToast(msg:"Ad opened"),
    onAdClosed: (Ad ad) => Fluttertoast.showToast(msg:"Ad closed"),
    onAdImpression: (Ad ad) => Fluttertoast.showToast(msg:"",backgroundColor:Colors.transparent),
  );

  final uid = FirebaseAuth.instance.currentUser!.uid;

  final List<FAQ> faqs = [
    FAQ(
      question: 'How to update profile ?',
      answer:
          'To Update your profile, please follow these steps:\n\n 1.Navigate to the left side corner of the application interface.\n 2.Click on the three horizontal lines to access the menu.\n 3.Select PROFILE from the menu options.\n 4.Enter the information you wish to Update. \n 5.Click on Save Profile to confirm the changes. ',
    ),
    FAQ(
      question: 'How to hire a worker on the App?',
      answer:
          'As a client, you can hire a worker by following these steps:\n\n 1.On your homepage, Click on Press here to Hire Workers Image.\n 2.In the subsequent page, you will be prompted to select the type of worker you require, such as an electrician, plumber, or carpenter.\n 3.Upon selection, a screen will display pertinent details about the available worker, including their contact number, experience, and location.\n 4.Simply click on the Contact button, and the worker\s contact number will automatically populate on your device\s dialing screen.',
    ),
    FAQ(
      question: 'When we can expet job ?',
      answer:
          'After successfully registering and completing payment on Kaamwale, you will gain access to client calls pertaining to various needs and requirements. We advise patience while awaiting these inquiries and recommend ensuring your mobile number remains accessible and reachable at all times. This ensures you never miss out on potential opportunities to fulfill client requests effectively.',
    ),
    FAQ(
      question: 'how to hire multiple worker from the app ?',
      answer: 'Repeat the above process and search for another profession',
    ),
    FAQ(
      question: 'how will i get paid ?',
      answer:
          'Our platform operates solely on client-based interactions. We maintain a neutral stance and do not interfere in the communication between you and your clients. We encourage open discussion and direct communication with the clients who reach out to you.',
    ),
    FAQ(
      question: 'How will i pay the worker ?',
      answer:
          'For added convenience and security, payments can be made by directly contacting the workers physically at your location. This method ensures both safety and efficiency in the transaction process.',
    ),

    // Add more FAQs here
  ];

  int _selected = 0;
  void changeSelected(int index) {
    setState(() {
      _selected = index;
    });
  }

  Future checkUser() async {
    DocumentReference usersData =
        FirebaseFirestore.instance.collection('users').doc(uid);
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await usersData
        .collection(
            'clients') // Access the 'workers' sub-collection within that document
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If user data exists, open main page
      Get.off(() => const Client_Profile_Exists());
    } else {
      // If user data doesn't exist, open profile page
      Get.off(() => const Clients_ProfileShow());
    }
  }

  // Function to close the application
  void closeApp() {
    if (Platform.isAndroid || Platform.isIOS) {
      exit(0); // Close the application
    }
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();

  }

  void showFillFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Create alert dialog
        return AlertDialog(
          backgroundColor: const Color(0xff95a6a7),
          title: const Text('*Important Note*',textAlign: TextAlign.center,),
          content:SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Please take a moment to carefully review the following information:'),
                const SizedBox(height: 15), // Add some spacing between lines
                Center(
                  child: Image.asset('assets/images/menugif.gif',
                    height: 30,
                    width: 30,
                  ),
                ),
                const Text('* Go to the Menu',style: TextStyle(fontWeight: FontWeight.bold),),
                const Text('* Click on  P R O F I L E  Option',style: TextStyle(fontWeight: FontWeight.bold),),
                const Text('* Fill the Form Carefully'),
                const SizedBox(height: 10),
                const Text('** If You already Done! then Ignore this Message **',style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close',style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

//----------------------------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final Uri whatsapp = Uri.parse('https://wa.me/+918359004561');
    final Uri insta = Uri.parse('https://www.instagram.com/kaamwale.official/');
    final Uri youtube = Uri.parse('https://www.youtube.com/@Kaamwale.official');
    final Uri facebook = Uri.parse('https://www.facebook.com/people/KaamWale/61558817762441/');
    final Uri x = Uri.parse('https://twitter.com/wale_kaam');
    final Uri feedback = Uri.parse('https://www.vrkahdevtech.com/');

    final AdWidget adwidget = AdWidget(ad: bannerAd);

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(0.85)),
      child: Scaffold(
        backgroundColor: const Color(0xff95a6a7),
        appBar: AppBar(
          title: const Text(
            "T H E  K A A M W A L E",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xff2b3d4f),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.feedback,
            color: Colors.black,
          ),
          onPressed: () {
            launchUrl(feedback);
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              PopScope(
                canPop: false,
                onPopInvoked: (bool didPop) async {
                  if (didPop) {
                    return;
                  }

                  final bool shouldPop = await _showBackDialog() ?? false;
                  if (context.mounted && shouldPop) {
                    Navigator.pop(context); //change here
                  }
                },
                child: TextButton(
                  onPressed: () async {
                    final bool shouldPop = await _showBackDialog() ?? true;
                    if (context.mounted && shouldPop) {
                      closeApp(); //change here
                    }
                  },
                  child: const Text(
                    "W E L C O M E",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Chewie(
                    controller: _chewieController,
                  ),
                ),
              ),
              const Text(
                'Home Workforce Solutions',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    color: const Color(0xff2b3d4f),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text(
                          'H I R E  W O R K E R',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/imgorgf.png'),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SelectWorkers_ScreenShow()));
                              },
                              splashColor: const Color(0xff95a6a7),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    color: const Color(0xff2b3d4f),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text(
                          'F O L L O W   U S',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                                image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/instadark.png'),
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    launchUrl(insta);
                                  },
                                  splashColor: const Color(0xff2b3d4f),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                                image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/youtubedark.png'),
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    launchUrl(youtube);
                                  },
                                  splashColor: const Color(0xff2b3d4f),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                                image: const DecorationImage(
                                  image: AssetImage(
                                      'assets/images/facebookdark.png'),
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    launchUrl(facebook);
                                  },
                                  splashColor: const Color(0xff2b3d4f),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/xlogo.jpg'),
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    launchUrl(x);
                                  },
                                  splashColor: const Color(0xff2b3d4f),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              //  final AdWidget adwidget = AdWidget(ad : bannerAd);                -----------------Ad is here---------------

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

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    color: const Color(0xff2b3d4f),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text(
                          'F A Q   A B O U T   K A A M W A L E',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Column(
                        children: [
                          Center(
                            child: MediaQuery(
                              data: MediaQuery.of(context),
                              child: Container(
                                height: 400,
                                width: 350,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xff95a6a7), Color(0xff2b3d4f)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: ListView.builder(
                                  itemCount: faqs.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return ExpansionTile(
                                      title: Text(
                                        faqs[index].question,
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Text(
                                            faqs[index].answer,
                                            textAlign: TextAlign.justify,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
        drawer: Drawer(
          backgroundColor: const Color(0xff95a6a7),
          child: Column(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/aikaamwale.png'),
                    //fit: BoxFit.cover,
                  ),
                  gradient: LinearGradient(
                    colors: [Color(0xff95a6a7), Color(0xff2b3d4f)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [],
                ),
              ),
              ListTile(
                selected: _selected == 0,
                leading: const Icon(
                  Icons.person_outline,
                  size: 20,
                ),
                title: const Text(
                  "P R O F I L E",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                splashColor: const Color(0xff2b3d4f),
                onTap: () {
                  changeSelected(0);

                  const CircularProgressIndicator(
                    color: Color(0xff2b3d4f),
                    backgroundColor: Colors.white,
                  );
                  checkUser();
                },
              ),
              const Divider(
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              ListTile(
                selected: _selected == 2,
                leading: const Icon(
                  Icons.support_agent_outlined,
                  size: 20,
                ),
                title: const Text(
                  "S U P P O R T",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                splashColor: const Color(0xff2b3d4f),
                onTap: () async {
                  changeSelected(2);
                  launchUrl(whatsapp);
                },
              ),
              const Divider(
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              ListTile(
                selected: _selected == 1,
                leading: const Icon(
                  Icons.people_alt_rounded,
                  size: 20,
                ),
                title: const Text(
                  "A B O U T  U S",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                splashColor: const Color(0xff2b3d4f),
                onTap: () {
                  changeSelected(1);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutUsScreenShow(),
                    ),
                  );
                },
              ),
              const Divider(
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              ListTile(
                selected: _selected == 3,
                leading: const Icon(
                  Icons.logout,
                  size: 20,
                ),
                title: const Text(
                  "L O G O U T",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                splashColor: const Color(0xff2b3d4f),
                onTap: () {
                  changeSelected(3);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('L O G O U T',textAlign: TextAlign.center,),
                        icon: const Icon(Icons.logout),
                        content: const Text('Are you sure you want to LOGOUT and CLOSE the Application?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
                            },
                            child: const Text('N O'),
                          ),
                          TextButton(
                            onPressed: () async {
                              //logout(context);
                              await FirebaseAuth.instance.signOut();
                              closeApp();
                            },
                            child: const Text('Y E S'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(
                height: 200,
              ),
              Image.asset(
                "assets/images/heart.png",
                width: 15,
                height: 15,
              ),
              const Center(
                child: Text(
                  "T H E  K A A M W A L E",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffdb691e),
                  ),
                ),
              ),
              const Center(
                child: Text(
                  "@ Powered By VrkahDev Technology",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showBackDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Are You Sure?',textAlign: TextAlign.center,),
            content:
                const Text('Are You Sure,You want to leave the Application?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  closeApp();
                  Navigator.pop(context, true);
                },
                child: const Text('Leave'),
              ),
            ],
          );
        });
  }

}
