
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thekaamwale/Clients/Client_Profile_Exists.dart';
import 'package:thekaamwale/Clients/Client_ScreenShow.dart';

import '../Models/client_data_modules.dart';

class Client_Update_ProfileShow extends StatefulWidget {
  const Client_Update_ProfileShow({super.key});

  @override
  State<Client_Update_ProfileShow> createState() =>
      _Client_Update_ProfileShowState();
}

class _Client_Update_ProfileShowState extends State<Client_Update_ProfileShow> {

final FirebaseStorage _storage = FirebaseStorage.instance;

File? pickedImage;

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

TextEditingController fullNameController = TextEditingController();
TextEditingController mobileNoController = TextEditingController();
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
    place: placeController.text.trim(),
    city: cityController.text.trim(),
    state: stateController.text.trim(),
    pin: pinController.text.trim(),
    url: downloadURL,
    uid: user,

  );
  DocumentReference usersData = FirebaseFirestore.instance.collection('users').doc(user);
  await
  usersData
      .collection('clients').doc(user)
      .set(newData.toMap())
      .then((value) {
    // Data saved successfully
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Image.asset('assets/images/success.gif',height: 50,width: 50,),
          content: const Text('D A T A  U P D A T E  S U C C E S S F U L L Y'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Client_Profile_Exists()));
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

@override
void initState() {
  super.initState();

  Future.delayed(const Duration(seconds: 1), () => showFillFormDialog(context));
}

void showFillFormDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Create alert dialog
      return AlertDialog(
        title: const Text('Important: Filling the Form'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Please take a moment to carefully review the following information before filling out the form:'),
              SizedBox(height: 15), // Add some spacing between lines
              Text('* Carefully fill Your Mobile Number.'),
              Text('* Make Sure you fill Address properly'),
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

//-----------------------------------------------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(0.85)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("U P D A T E   P R O F I L E",style: TextStyle(color: Colors.white),),
          backgroundColor: const Color(0xff2b3d4f),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          leading:  BackButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context)=> const Client_ScreenShow(),
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
                        backgroundColor: const Color(0xff2b3d4f),
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
                    child: Container(
                      child: TextFormField(
                          controller: fullNameController,
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: TextFormField(
                          controller: mobileNoController,
                          keyboardType: TextInputType.phone,
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: TextFormField(
                          controller: placeController,
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: TextFormField(
                          controller: cityController,
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: TextFormField(
                          controller: stateController,
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
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
                              return "Please Enter Your PinCode Here";
                            } else {
                              return null;
                            }
                          }),
                    ),
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
                    height: 50,
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
                          'U P D A T E',
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
                  height: 50,),
                ],
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
                  "Choose Photo From",
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
