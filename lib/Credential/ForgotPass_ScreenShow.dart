import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:thekaamwale/Credential/Login_ScreenShow.dart';

class ForgotPass_ScreenShow extends StatefulWidget {
  const ForgotPass_ScreenShow({super.key});

  @override
  State<ForgotPass_ScreenShow> createState() => _ForgotPass_ScreenShowState();
}

class _ForgotPass_ScreenShowState extends State<ForgotPass_ScreenShow> {
  @override
  TextEditingController email = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  resetpassword() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email.text)
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message Send Successfully')));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const Login_ScreenShow()));
    }).catchError((error) {
      // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error! on Sanding Message')));
    });
  }

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
    onAdLoaded: (Ad ad) => Fluttertoast.showToast(msg:"Forgot"),
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      Fluttertoast.showToast(msg:"Ad Failed to load: $error");
    },
    onAdOpened: (Ad ad) => Fluttertoast.showToast(msg:"Ad opened"),
    onAdClosed: (Ad ad) => Fluttertoast.showToast(msg:"Ad closed"),
    onAdImpression: (Ad ad) => Fluttertoast.showToast(msg:"Password"),
  );


  @override
  Widget build(BuildContext context) {

    final AdWidget adwidget = AdWidget(ad: bannerAd);

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(0.85)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Forgot Password',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff2b3d4f),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Form(
          key: _formkey,
          child: MediaQuery(
            data: MediaQuery.of(context),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff95a6a7), Color(0xff2b3d4f)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 1,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: const Color(0xff2b3d4f),
                                      ),
                          child: Image.asset('assets/images/forgotpass.jpg',
                              height: 350, width: 350),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
            
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xff2b3d4f),
                        ),
                          child: Column(
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: TextFormField(
                                controller: email,
                                decoration: InputDecoration(
                                  hintText: "Enter Email ID (Carefully)",
                                  labelStyle: const TextStyle(color: Colors.grey),
                                  filled: true,
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                          width: 0, style: BorderStyle.none)),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Email cannot be empty";
                                  }
                                  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                      .hasMatch(value)) {
                                    return ("Please enter a valid email");
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {},
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  resetpassword();
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white, // Text color
                            ),
                            child: const Text("Send Link"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "*Please Check Your Email after Clicking on SEND LINK button",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
            
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
            
            
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
