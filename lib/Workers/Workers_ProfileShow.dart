import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:thekaamwale/Workers/Worker_Profile_Exists.dart';
import 'package:thekaamwale/Workers/Worker_ScreenShow.dart';

import '../Models/user_data_models.dart';


class Workers_ProfileShow extends StatefulWidget {
  const Workers_ProfileShow({super.key});

  @override
  State<Workers_ProfileShow> createState() => _Workers_ProfileShowState();
}
class _Workers_ProfileShowState extends State<Workers_ProfileShow> {

  final FirebaseStorage _storage = FirebaseStorage.instance;

  File? pickedImage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  List<String> _selectedOccupation = [];
  TextEditingController workExpController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType, imageQuality: 5);
      if (photo == null) return;
      var tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> _saveDataToFirestore(BuildContext context) async {

    showDialog(context: context, builder: (context)
    {
      return const Center(child: CircularProgressIndicator(
        color: Color(0xff2b3d4f),
        backgroundColor: Colors.white,
      ));
    });

    String user = FirebaseAuth.instance.currentUser!.uid;

    if (pickedImage == null) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Image.asset('assets/images/avatarimg.png',height: 50,width: 50,),
            content: const Text('Please Add Your Image',textAlign: TextAlign.center,),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    // Upload image to Firebase Storage
    final Reference ref = _storage.ref().child('images/${DateTime.now()}.png');
    await ref.putFile(pickedImage!);

    // Get download URL
    final String downloadURL = await ref.getDownloadURL();

    final MyData newData = MyData(
      fullName: fullNameController.text.trim(),
      mobileNo: mobileNoController.text.trim(),
      selectedOccupation: _selectedOccupation,
      workExp: workExpController.text.trim(),
      place: placeController.text.trim(),
      city: cityController.text.trim(),
      state: stateController.text.trim(),
      pin: pinController.text.trim(),
      url: downloadURL,
      uid: user,

    );
    var usersData = FirebaseFirestore.instance.collection('users').doc(user);
   await
         usersData
        .collection('workers').doc(user)
        .set(newData.toMap())
        .then((value) {

      // Data saved successfully
           showDialog(
             context: context,
             builder: (BuildContext context) {
               return AlertDialog(
                 title: Image.asset('assets/images/success.gif',height: 50,width: 50,),
                 content: const Text('**SUCCESSFULLY SAVE**',textAlign: TextAlign.center, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                 actions: <Widget>[
                   TextButton(
                     onPressed: () {
                       Navigator.of(context).pop();
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Worker_Profile_Exists()));
                     },
                     child: const Text('OK'),
                   ),
                 ],
               );
             },
           );
         }).catchError((error) {
           // Error handling
           showDialog(
             context: context,
             builder: (BuildContext context) {
               return AlertDialog(
                 title: const Text('Error'),
                 content: const Text('Error saving profile.'),
                 actions: <Widget>[
                   TextButton(
                     onPressed: () {
                       Navigator.of(context).pop();
                     },
                     child: const Text('OK'),
                   ),
                 ],
               );
             },
           );
         });
  }


  late final BannerAd bannerAd;
  final String adUnitId = "ca-app-pub-3940256099942544/6300978111";

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Future.delayed(const Duration(seconds: 1), () => showFillFormDialog(context));

    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adUnitId,
        listener: bannerAdListener,
        request: const AdRequest());

    bannerAd.load(); //load ad here

  }
  final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (Ad ad) => Fluttertoast.showToast(msg:"Carefully!"),
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      Fluttertoast.showToast(msg:"Ad Failed to load: $error");
    },
    onAdOpened: (Ad ad) => Fluttertoast.showToast(msg:"Ad opened"),
    onAdClosed: (Ad ad) => Fluttertoast.showToast(msg:"Ad closed"),
    onAdImpression: (Ad ad) => Fluttertoast.showToast(msg:"Imp Note!"),
  );


  @override
  void dispose() {
    // TODO: implement dispose
     fullNameController.dispose();
     mobileNoController.dispose();
     workExpController.dispose();
     placeController.dispose();
     cityController.dispose();
     stateController.dispose();
     pinController.dispose();
    super.dispose();
  }

  void showFillFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Create alert dialog
        return AlertDialog(
          title: const Text('*Important Note*',textAlign: TextAlign.center,),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please take a moment to carefully review the following information before filling out the form:'),
                SizedBox(height: 15), // Add some spacing between lines
                Text('* Carefully fill Your Mobile Number.'),
                Text('* Select Occupation 1 or 2 (Max),Any 2'),
                Text('* Make Sure you fill Address properly'),
                Text('* Fill PinCode properly that will help Clients to Reach you'),
                Text('* Double-check all entered information for accuracy.'),
                Text('* If unsure about any field, seek Clarification before Submitting.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  //-------------------------------------------------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    final AdWidget adwidget = AdWidget(ad: bannerAd);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(0.85)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("R E G I S T R A T I O N",style: TextStyle(color: Colors.white),),
          backgroundColor: const Color(0xff2b3d4f),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          leading:  BackButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context)=> const Worker_ScreenShow(),
              ),
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff95a6a7), Color(0xff2b3d4f)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: PopScope(
                canPop: false,
                onPopInvoked: (bool didPop) async {
                  if (didPop) {
                    return;
                  }
                  if (context.mounted) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Worker_ScreenShow(),
                    ),
                    );
                  }
                },
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.indigo, width: 1),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                            child: ClipOval(
                              child: pickedImage != null
                                  ? Image.file(
                                pickedImage!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                                  : Image.network(
                                'https://imgs.search.brave.com/MWlI8P3aJROiUDO9A-LqFyca9kSRIxOtCg_Vf1xd9BA/rs:fit:860:0:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzAyLzE1Lzg0LzQz/LzM2MF9GXzIxNTg0/NDMyNV90dFg5WWlJ/SXllYVI3TmU2RWFM/TGpNQW15NEd2UEM2/OS5qcGc',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: -10,
                            child: IconButton(
                              onPressed: imagePickerOption,
                              icon: const Icon(
                                Icons.add_a_photo_outlined,
                                color: Color(0xff2b3d4f),
                                size: 30,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                          onPressed: imagePickerOption,
                          icon: const Icon(Icons.add_a_photo_sharp),
                          label: const Text('SELECT YOUR PHOTO'),
                          style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xff2b3d4f), // Text color
                        ),
                      ),

                    ),
                    const Divider(
                      height: 10,
                      thickness: 2,
                      indent: 10,
                      endIndent: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: fullNameController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(25), // Limit input length to 6 characters
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.person),
                            hintText: 'Enter Your Full Name',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onChanged: (value) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Your FullName Here";
                            } else {
                              return null;
                            }
                          }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: mobileNoController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10), // Limit input length to 10 characters
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Enter Your Mobile Number',
                            prefixIcon: const Icon(Icons.phone),
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onChanged: (value) {
                            //_formKey.currentState?.validate();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Your Mobile Number Here";
                            } else if (!RegExp(
                                r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$')
                                .hasMatch(value)) {
                              return "Please Enter a Valid Mobile Number Here";
                            } else {
                              return null;
                            }
                          }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: MultiSelectFormField(
                          autovalidate: AutovalidateMode.disabled,
                          chipBackGroundColor: const Color(0xff95a6a7),
                          chipLabelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          dialogTextStyle:
                          const TextStyle(fontWeight: FontWeight.bold),
                          checkBoxActiveColor: const Color(0xff2b3d4f),
                          checkBoxCheckColor: const Color(0xff95a6a7),
                          dialogShapeBorder: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                          title: const Text(
                            "Types of Occupation (Kaam)",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          validator: (value) {
                            if (value == null || value.length == 0) {
                              return 'Please select one or more options(Any 2)';
                            }
                            return null;
                          },
                          dataSource: const [
                            {
                              "display": "Electrician",
                              "value": "Electrician",
                            },
                            {
                              "display": "Plumber",
                              "value": "Plumber",
                            },
                            {
                              "display": "Reja",
                              "value": "Reja",
                            },
                            {
                              "display": "Majdur",
                              "value": "Majdur",
                            },
                            {
                              "display": "Mistry",
                              "value": "Mistry",
                            },
                            {
                              "display": "Putty/Painter",
                              "value": "Putty/Painter",
                            },
                            {
                              "display": "Carpenter",
                              "value": "Carpenter",
                            },
                            {
                              "display": "Tiles Fitting",
                              "value": "Tiles Fitting",
                            },
                          ],
                          textField: 'display',
                          valueField: 'value',
                          okButtonLabel: 'OK',
                          cancelButtonLabel: 'CANCEL',
                          hintWidget: const Text('Please choose one or more(Any 2)'),
                          initialValue: _selectedOccupation,
                          onSaved: (value) {
                            if (value == null) return;
                            setState(() {
                              _selectedOccupation = List<String>.from(value);
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: workExpController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2), // Limit input length to 2 characters
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Enter Your Year of Work Experience',
                            prefixIcon: const Icon(Icons.person_pin_rounded),
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onChanged: (value) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Your Year of Work Experience";
                            } else {
                              return null;
                            }
                          }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: placeController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(25), // Limit input length to 6 characters
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Enter Your Place(Address)',
                            prefixIcon: const Icon(Icons.location_city_sharp),
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onChanged: (value) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Your Address Here ";
                            } else {
                              return null;
                            }
                          }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: cityController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20), // Limit input length to 6 characters
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Enter Your City',
                            prefixIcon: const Icon(Icons.pin_drop_outlined),
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onChanged: (value) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Your City Here";
                            } else {
                              return null;
                            }
                          }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: stateController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20), // Limit input length to 6 characters
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Enter Your State',
                            prefixIcon: const Icon(Icons.pin_drop_sharp),
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onChanged: (value) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Your State Here";
                            } else {
                              return null;
                            }
                          }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: pinController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(6), // Limit input length to 6 characters
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Enter Your PinCode',
                            prefixIcon: const Icon(Icons.pin_drop_sharp),
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onChanged: (value) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Your PinCode Here";
                            } else {
                              return null;
                            }
                          }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      height: 10,
                      thickness: 2,
                      indent: 10,
                      endIndent: 10,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        ElevatedButton.icon(
                          onPressed: () {
                            _submitForm();
                          },
                          icon: const Icon(Icons.save),
                          label: const Text(
                            'S A V E  P R O F I L E',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xff95a6a7), // Text color
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(
                      height: 30,
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

  void _submitForm() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      //save data to firestore
      _saveDataToFirestore(context);
    }
  }

  void imagePickerOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "C H O O S E  P H O T O",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("CAMERA"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xff95a6a7), // Text color
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("GALLERY"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xff95a6a7), // Text color
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("CANCEL"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xff2b3d4f), // Text color
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
