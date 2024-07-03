import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thekaamwale/Clients/Client_ScreenShow.dart';
import 'package:thekaamwale/OccupationResults/GlassWorker_Result_ScreenShow.dart';
import 'package:thekaamwale/OccupationResults/AluminiumWorker_Result_ScreenShow.dart';
import 'package:thekaamwale/OccupationResults/Result_ScreenShow.dart';

import '../OccupationResults/Carpenters_Result_ScreenShow.dart';
import '../OccupationResults/Majdurs_Result_ScreenShow.dart';
import '../OccupationResults/Mistrys_Result_ScreenShow.dart';
import '../OccupationResults/Plumbers_Result_ScreenShow.dart';
import '../OccupationResults/PuttyNPainter_Result_ScreenShow.dart';
import '../OccupationResults/Rejas_Result_ScreenShow.dart';
import '../OccupationResults/TilesFitting_Result_ScreenShow.dart';
import '../OccupationResults/Welder_Result_ScreenShow.dart';

class UserData {
  final String userId;
  final String fullName;
  final String place;
  final String city;
  final String workExp;
  final String mobileNo;
  final String state;
  final String pin;
  final String url;
  final List<dynamic> selectedOccupation;

  UserData({
    required this.userId,
    required this.fullName,
    required this.place,
    required this.city,
    required this.workExp,
    required this.mobileNo,
    required this.state,
    required this.pin,
    required this.url,
    required this.selectedOccupation,
  });
}


class SelectWorkers_ScreenShow extends StatefulWidget {
  const SelectWorkers_ScreenShow({super.key});

  @override
  State<SelectWorkers_ScreenShow> createState() =>
      _SelectWorkers_ScreenShowState();
}

class _SelectWorkers_ScreenShowState extends State<SelectWorkers_ScreenShow> {

  // Initialize Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//-------------------------------------------------------------------------------------------------------------------------

  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }


  Future<List<UserData>> getElectricians() async {

    showDialog(context: context, builder: (context)
    {
      return Center(
        child: Container(
          height: 100,
          width: 390,
          decoration: BoxDecoration(
            color: const Color(0xff2b3d4f),
            borderRadius: BorderRadius.circular(20),
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30,0,0,0),
                    child: CircularProgressIndicator(
                      color: Color(0xff2b3d4f),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20,),
                  RichText(
                    text: const TextSpan(
                      text: "Processing Data Please Wait...",
                      style: TextStyle(color: Colors.white, decoration: TextDecoration.none),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      );
    });

    List<UserData> electricians = [];

    try {
      // Query to get users with role 'WORKER'
      QuerySnapshot usersSnapshot = await _firestore.collection('users').where(
          'role', isEqualTo: 'WORKER').get();

      // Iterate through each user document
      for (DocumentSnapshot userDoc in usersSnapshot.docs) {
        // Get the reference to the 'workers' subcollection for each user
        CollectionReference workersCollectionRef = userDoc.reference.collection('workers');

        // Query the 'workers' subcollection to get the occupation data
        QuerySnapshot workersSnapshot = await workersCollectionRef.get();

        // Iterate through each document in the 'workers' subcollection
        for (DocumentSnapshot workerDoc in workersSnapshot.docs) {
          // Fetch additional data from the worker document
          String fullName = workerDoc['fullName'];
          String place = workerDoc['place'];
          String city = workerDoc['city'];
          String workExp = workerDoc['workExp'];
          String mobileNo = workerDoc['mobileNo'];
          String url = workerDoc['url'];
          String state = workerDoc['state'];
          String pin = workerDoc['pin'];

          // Access the occupation data
          List<dynamic> occupation = workerDoc['selectedOccupation'];

          // Check if the occupation contains 'Electrician'
          if (occupation.contains('Electrician')) {
            // Create UserData object and add to the list
            UserData userData = UserData(
              userId: userDoc.id,
              fullName: fullName,
              place: place,
              city: city,
              workExp: workExp,
              mobileNo: mobileNo,
              url: url,
              state: state,
              pin: pin,
              selectedOccupation: occupation,
            );
            electricians.add(userData);
           // print('User ID: ${userDoc.id}, Occupation: $occupation ,Full Name: $name ,Mobile No.: $mobileNumber');
          }
        }
      }
    } catch (error) {
      // Handle errors
      Fluttertoast.showToast(msg:'Error fetching electricians, check Internet!');
    }

    return electricians;
  }

  Future<List<UserData>> getPlumbers() async {

    showDialog(context: context, builder: (context)
    {
      return Center(
        child: Container(
          height: 100,
          width: 390,
          decoration: BoxDecoration(
            color: const Color(0xff2b3d4f),
            borderRadius: BorderRadius.circular(20),
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30,0,0,0),
                    child: CircularProgressIndicator(
                      color: Color(0xff2b3d4f),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20,),
                  RichText(
                    text: const TextSpan(
                      text: "Processing Data Please Wait...",
                      style: TextStyle(color: Colors.white, decoration: TextDecoration.none),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      );
    });

    List<UserData> plumbers = [];

    try {
      // Query to get users with role 'WORKER'
      QuerySnapshot usersSnapshot = await _firestore.collection('users').where(
          'role', isEqualTo: 'WORKER').get();

      // Iterate through each user document
      for (DocumentSnapshot userDoc in usersSnapshot.docs) {
        // Get the reference to the 'workers' subcollection for each user
        CollectionReference workersCollectionRef =
        userDoc.reference.collection('workers');

        // Query the 'workers' subcollection to get the occupation data
        QuerySnapshot workersSnapshot = await workersCollectionRef.get();

        // Iterate through each document in the 'workers' subcollection
        for (DocumentSnapshot workerDoc in workersSnapshot.docs) {
          // Fetch additional data from the worker document
          String fullName = workerDoc['fullName'];
          String place = workerDoc['place'];
          String city = workerDoc['city'];
          String workExp = workerDoc['workExp'];
          String mobileNo = workerDoc['mobileNo'];
          String url = workerDoc['url'];
          String state = workerDoc['state'];
          String pin = workerDoc['pin'];

          // Access the occupation data
          List<dynamic> occupation = workerDoc['selectedOccupation'];

          // Check if the occupation contains 'Plumber'
          if (occupation.contains('Plumber')) {
            // Create UserData object and add to the list
            UserData userData = UserData(
              userId: userDoc.id,
              fullName: fullName,
              place: place,
              city: city,
              workExp: workExp,
              mobileNo: mobileNo,
              url: url,
              state: state,
              pin: pin,
              selectedOccupation: occupation,
            );
            plumbers.add(userData);
            // print('User ID: ${userDoc.id}, Occupation: $occupation ,Full Name: $name ,Mobile No.: $mobileNumber');
          }
        }
      }
    } catch (error) {
      // Handle errors
      Fluttertoast.showToast(msg:'Error fetching Plumber, check Internet!');
    }

    return plumbers;
  }

  Future<List<UserData>> getRejas() async {

    showDialog(context: context, builder: (context)
    {
      return Center(
        child: Container(
          height: 100,
          width: 390,
          decoration: BoxDecoration(
            color: const Color(0xff2b3d4f),
            borderRadius: BorderRadius.circular(20),
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30,0,0,0),
                    child: CircularProgressIndicator(
                      color: Color(0xff2b3d4f),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20,),
                  RichText(
                    text: const TextSpan(
                      text: "Processing Data Please Wait...",
                      style: TextStyle(color: Colors.white, decoration: TextDecoration.none),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      );
    });

    List<UserData> rejas = [];

    try {
      // Query to get users with role 'WORKER'
      QuerySnapshot usersSnapshot = await _firestore.collection('users').where(
          'role', isEqualTo: 'WORKER').get();

      // Iterate through each user document
      for (DocumentSnapshot userDoc in usersSnapshot.docs) {
        // Get the reference to the 'workers' subcollection for each user
        CollectionReference workersCollectionRef =
        userDoc.reference.collection('workers');

        // Query the 'workers' subcollection to get the occupation data
        QuerySnapshot workersSnapshot = await workersCollectionRef.get();

        // Iterate through each document in the 'workers' subcollection
        for (DocumentSnapshot workerDoc in workersSnapshot.docs) {
          // Fetch additional data from the worker document
          String fullName = workerDoc['fullName'];
          String place = workerDoc['place'];
          String city = workerDoc['city'];
          String workExp = workerDoc['workExp'];
          String mobileNo = workerDoc['mobileNo'];
          String url = workerDoc['url'];
          String state = workerDoc['state'];
          String pin = workerDoc['pin'];

          // Access the occupation data
          List<dynamic> occupation = workerDoc['selectedOccupation'];

          // Check if the occupation contains 'Reja'
          if (occupation.contains('Reja')) {
            // Create UserData object and add to the list
            UserData userData = UserData(
              userId: userDoc.id,
              fullName: fullName,
              place: place,
              city: city,
              workExp: workExp,
              mobileNo: mobileNo,
              url: url,
              state: state,
              pin: pin,
              selectedOccupation: occupation,
            );
            rejas.add(userData);
            // print('User ID: ${userDoc.id}, Occupation: $occupation ,Full Name: $name ,Mobile No.: $mobileNumber');
          }
        }
      }
    } catch (error) {
      // Handle errors
      Fluttertoast.showToast(msg:'Error fetching Reja, check Internet!');
    }

    return rejas;
  }

  Future<List<UserData>> getMajdurs() async {

    showDialog(context: context, builder: (context)
    {
      return Center(
        child: Container(
          height: 100,
          width: 390,
          decoration: BoxDecoration(
            color: const Color(0xff2b3d4f),
            borderRadius: BorderRadius.circular(20),
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30,0,0,0),
                    child: CircularProgressIndicator(
                      color: Color(0xff2b3d4f),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20,),
                  RichText(
                    text: const TextSpan(
                      text: "Processing Data Please Wait...",
                      style: TextStyle(color: Colors.white, decoration: TextDecoration.none),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      );
    });

    List<UserData> majdurs = [];

    try {
      // Query to get users with role 'WORKER'
      QuerySnapshot usersSnapshot = await _firestore.collection('users').where(
          'role', isEqualTo: 'WORKER').get();

      // Iterate through each user document
      for (DocumentSnapshot userDoc in usersSnapshot.docs) {
        // Get the reference to the 'workers' subcollection for each user
        CollectionReference workersCollectionRef =
        userDoc.reference.collection('workers');

        // Query the 'workers' subcollection to get the occupation data
        QuerySnapshot workersSnapshot = await workersCollectionRef.get();

        // Iterate through each document in the 'workers' subcollection
        for (DocumentSnapshot workerDoc in workersSnapshot.docs) {
          // Fetch additional data from the worker document
          String fullName = workerDoc['fullName'];
          String place = workerDoc['place'];
          String city = workerDoc['city'];
          String workExp = workerDoc['workExp'];
          String mobileNo = workerDoc['mobileNo'];
          String url = workerDoc['url'];
          String state = workerDoc['state'];
          String pin = workerDoc['pin'];

          // Access the occupation data
          List<dynamic> occupation = workerDoc['selectedOccupation'];

          // Check if the occupation contains 'Majdur'
          if (occupation.contains('Majdur')) {
            // Create UserData object and add to the list
            UserData userData = UserData(
              userId: userDoc.id,
              fullName: fullName,
              place: place,
              city: city,
              workExp: workExp,
              mobileNo: mobileNo,
              url: url,
              state: state,
              pin: pin,
              selectedOccupation: occupation,
            );
            majdurs.add(userData);
            // print('User ID: ${userDoc.id}, Occupation: $occupation ,Full Name: $name ,Mobile No.: $mobileNumber');
          }
        }
      }
    } catch (error) {
      // Handle errors
      Fluttertoast.showToast(msg:'Error fetching Majdur, check Internet');
    }

    return majdurs;
  }

  Future<List<UserData>> getMistrys() async {

    showDialog(context: context, builder: (context)
    {
      return Center(
        child: Container(
          height: 100,
          width: 390,
          decoration: BoxDecoration(
            color: const Color(0xff2b3d4f),
            borderRadius: BorderRadius.circular(20),
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30,0,0,0),
                    child: CircularProgressIndicator(
                      color: Color(0xff2b3d4f),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20,),
                  RichText(
                    text: const TextSpan(
                      text: "Processing Data Please Wait...",
                      style: TextStyle(color: Colors.white, decoration: TextDecoration.none),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      );
    });

    List<UserData> mistrys = [];

    try {
      // Query to get users with role 'WORKER'
      QuerySnapshot usersSnapshot = await _firestore.collection('users').where(
          'role', isEqualTo: 'WORKER').get();

      // Iterate through each user document
      for (DocumentSnapshot userDoc in usersSnapshot.docs) {
        // Get the reference to the 'workers' subcollection for each user
        CollectionReference workersCollectionRef =
        userDoc.reference.collection('workers');

        // Query the 'workers' subcollection to get the occupation data
        QuerySnapshot workersSnapshot = await workersCollectionRef.get();

        // Iterate through each document in the 'workers' subcollection
        for (DocumentSnapshot workerDoc in workersSnapshot.docs) {
          // Fetch additional data from the worker document
          String fullName = workerDoc['fullName'];
          String place = workerDoc['place'];
          String city = workerDoc['city'];
          String workExp = workerDoc['workExp'];
          String mobileNo = workerDoc['mobileNo'];
          String url = workerDoc['url'];
          String state = workerDoc['state'];
          String pin = workerDoc['pin'];

          // Access the occupation data
          List<dynamic> occupation = workerDoc['selectedOccupation'];

          // Check if the occupation contains 'Mistry'
          if (occupation.contains('Mistry')) {
            // Create UserData object and add to the list
            UserData userData = UserData(
              userId: userDoc.id,
              fullName: fullName,
              place: place,
              city: city,
              workExp: workExp,
              mobileNo: mobileNo,
              url: url,
              state: state,
              pin: pin,
              selectedOccupation: occupation,
            );
            mistrys.add(userData);
            // print('User ID: ${userDoc.id}, Occupation: $occupation ,Full Name: $name ,Mobile No.: $mobileNumber');
          }
        }
      }
    } catch (error) {
      // Handle errors
      Fluttertoast.showToast(msg:'Error fetching Mistry, check Internet!');
    }

    return mistrys;
  }

  Future<List<UserData>> getPutty_Painters() async {

    showDialog(context: context, builder: (context)
    {
      return Center(
        child: Container(
          height: 100,
          width: 390,
          decoration: BoxDecoration(
            color: const Color(0xff2b3d4f),
            borderRadius: BorderRadius.circular(20),
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30,0,0,0),
                    child: CircularProgressIndicator(
                      color: Color(0xff2b3d4f),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20,),
                  RichText(
                    text: const TextSpan(
                      text: "Processing Data Please Wait...",
                      style: TextStyle(color: Colors.white, decoration: TextDecoration.none),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      );
    });

    List<UserData> putty_painters = [];

    try {
      // Query to get users with role 'WORKER'
      QuerySnapshot usersSnapshot = await _firestore.collection('users').where(
          'role', isEqualTo: 'WORKER').get();

      // Iterate through each user document
      for (DocumentSnapshot userDoc in usersSnapshot.docs) {
        // Get the reference to the 'workers' subcollection for each user
        CollectionReference workersCollectionRef =
        userDoc.reference.collection('workers');

        // Query the 'workers' subcollection to get the occupation data
        QuerySnapshot workersSnapshot = await workersCollectionRef.get();

        // Iterate through each document in the 'workers' subcollection
        for (DocumentSnapshot workerDoc in workersSnapshot.docs) {
          // Fetch additional data from the worker document
          String fullName = workerDoc['fullName'];
          String place = workerDoc['place'];
          String city = workerDoc['city'];
          String workExp = workerDoc['workExp'];
          String mobileNo = workerDoc['mobileNo'];
          String url = workerDoc['url'];
          String state = workerDoc['state'];
          String pin = workerDoc['pin'];

          // Access the occupation data
          List<dynamic> occupation = workerDoc['selectedOccupation'];

          // Check if the occupation contains 'Putty/Painter'
          if (occupation.contains('Putty/Painter')) {
            // Create UserData object and add to the list
            UserData userData = UserData(
              userId: userDoc.id,
              fullName: fullName,
              place: place,
              city: city,
              workExp: workExp,
              mobileNo: mobileNo,
              url: url,
              state: state,
              pin: pin,
              selectedOccupation: occupation,
            );
          putty_painters.add(userData);
            // print('User ID: ${userDoc.id}, Occupation: $occupation ,Full Name: $name ,Mobile No.: $mobileNumber');
          }
        }
      }
    } catch (error) {
      // Handle errors
      Fluttertoast.showToast(msg:'Error fetching putty/painters, check Internet!');
    }

    return putty_painters;
  }

  Future<List<UserData>> getCarpenters() async {

    showDialog(context: context, builder: (context)
    {
      return Center(
        child: Container(
          height: 100,
          width: 390,
          decoration: BoxDecoration(
            color: const Color(0xff2b3d4f),
            borderRadius: BorderRadius.circular(20),
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30,0,0,0),
                    child: CircularProgressIndicator(
                      color: Color(0xff2b3d4f),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20,),
                  RichText(
                    text: const TextSpan(
                      text: "Processing Data Please Wait...",
                      style: TextStyle(color: Colors.white, decoration: TextDecoration.none),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      );
    });

    List<UserData> carpenters = [];

    try {
      // Query to get users with role 'WORKER'
      QuerySnapshot usersSnapshot = await _firestore.collection('users').where(
          'role', isEqualTo: 'WORKER').get();

      // Iterate through each user document
      for (DocumentSnapshot userDoc in usersSnapshot.docs) {
        // Get the reference to the 'workers' subcollection for each user
        CollectionReference workersCollectionRef =
        userDoc.reference.collection('workers');

        // Query the 'workers' subcollection to get the occupation data
        QuerySnapshot workersSnapshot = await workersCollectionRef.get();

        // Iterate through each document in the 'workers' subcollection
        for (DocumentSnapshot workerDoc in workersSnapshot.docs) {
          // Fetch additional data from the worker document
          String fullName = workerDoc['fullName'];
          String place = workerDoc['place'];
          String city = workerDoc['city'];
          String workExp = workerDoc['workExp'];
          String mobileNo = workerDoc['mobileNo'];
          String url = workerDoc['url'];
          String state = workerDoc['state'];
          String pin = workerDoc['pin'];

          // Access the occupation data
          List<dynamic> occupation = workerDoc['selectedOccupation'];

          // Check if the occupation contains 'Carpenter'
          if (occupation.contains('Carpenter')) {
            // Create UserData object and add to the list
            UserData userData = UserData(
              userId: userDoc.id,
              fullName: fullName,
              place: place,
              city: city,
              workExp: workExp,
              mobileNo: mobileNo,
              url: url,
              state: state,
              pin: pin,
              selectedOccupation: occupation,
            );
            carpenters.add(userData);
            // print('User ID: ${userDoc.id}, Occupation: $occupation ,Full Name: $name ,Mobile No.: $mobileNumber');
          }
        }
      }
    } catch (error) {
      // Handle errors
      Fluttertoast.showToast(msg:'Error fetching Carpenters, check Internet!');
    }

    return carpenters;
  }

  Future<List<UserData>> getTiles_Fitting() async {

    showDialog(context: context, builder: (context)
    {
      return Center(
        child: Container(
          height: 100,
          width: 390,
          decoration: BoxDecoration(
            color: const Color(0xff2b3d4f),
            borderRadius: BorderRadius.circular(20),
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30,0,0,0),
                    child: CircularProgressIndicator(
                      color: Color(0xff2b3d4f),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20,),
                  RichText(
                    text: const TextSpan(
                      text: "Processing Data Please Wait...",
                      style: TextStyle(color: Colors.white, decoration: TextDecoration.none),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      );
    });

    List<UserData> tiles_fitting = [];

    try {
      // Query to get users with role 'WORKER'
      QuerySnapshot usersSnapshot = await _firestore.collection('users').where(
          'role', isEqualTo: 'WORKER').get();

      // Iterate through each user document
      for (DocumentSnapshot userDoc in usersSnapshot.docs) {
        // Get the reference to the 'workers' subcollection for each user
        CollectionReference workersCollectionRef =
        userDoc.reference.collection('workers');

        // Query the 'workers' subcollection to get the occupation data
        QuerySnapshot workersSnapshot = await workersCollectionRef.get();

        // Iterate through each document in the 'workers' subcollection
        for (DocumentSnapshot workerDoc in workersSnapshot.docs) {
          // Fetch additional data from the worker document
          String fullName = workerDoc['fullName'];
          String place = workerDoc['place'];
          String city = workerDoc['city'];
          String workExp = workerDoc['workExp'];
          String mobileNo = workerDoc['mobileNo'];
          String url = workerDoc['url'];
          String state = workerDoc['state'];
          String pin = workerDoc['pin'];

          // Access the occupation data
          List<dynamic> occupation = workerDoc['selectedOccupation'];

          // Check if the occupation contains 'Tiles Fitting'
          if (occupation.contains('Tiles Fitting')) {
            // Create UserData object and add to the list
            UserData userData = UserData(
              userId: userDoc.id,
              fullName: fullName,
              place: place,
              city: city,
              workExp: workExp,
              mobileNo: mobileNo,
              url: url,
              state: state,
              pin: pin,
              selectedOccupation: occupation,
            );
            tiles_fitting.add(userData);
            // print('User ID: ${userDoc.id}, Occupation: $occupation ,Full Name: $name ,Mobile No.: $mobileNumber');
          }
        }
      }
    } catch (error) {
      // Handle errors
      Fluttertoast.showToast(msg:'Error fetching Tiles Fitting, check Internet!');
    }

    return tiles_fitting;
  }

  Future<List<UserData>> getGlass_Worker() async {

    showDialog(context: context, builder: (context)
    {
      return Center(
        child: Container(
          height: 100,
          width: 390,
          decoration: BoxDecoration(
            color: const Color(0xff2b3d4f),
            borderRadius: BorderRadius.circular(20),
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30,0,0,0),
                    child: CircularProgressIndicator(
                      color: Color(0xff2b3d4f),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20,),
                  RichText(
                    text: const TextSpan(
                      text: "Processing Data Please Wait...",
                      style: TextStyle(color: Colors.white, decoration: TextDecoration.none),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      );
    });

    List<UserData> glass_worker = [];

    try {
      // Query to get users with role 'WORKER'
      QuerySnapshot usersSnapshot = await _firestore.collection('users').where(
          'role', isEqualTo: 'WORKER').get();

      // Iterate through each user document
      for (DocumentSnapshot userDoc in usersSnapshot.docs) {
        // Get the reference to the 'workers' subcollection for each user
        CollectionReference workersCollectionRef =
        userDoc.reference.collection('workers');

        // Query the 'workers' subcollection to get the occupation data
        QuerySnapshot workersSnapshot = await workersCollectionRef.get();

        // Iterate through each document in the 'workers' subcollection
        for (DocumentSnapshot workerDoc in workersSnapshot.docs) {
          // Fetch additional data from the worker document
          String fullName = workerDoc['fullName'];
          String place = workerDoc['place'];
          String city = workerDoc['city'];
          String workExp = workerDoc['workExp'];
          String mobileNo = workerDoc['mobileNo'];
          String url = workerDoc['url'];
          String state = workerDoc['state'];
          String pin = workerDoc['pin'];

          // Access the occupation data
          List<dynamic> occupation = workerDoc['selectedOccupation'];

          // Check if the occupation contains 'Tiles Fitting'
          if (occupation.contains('Glass Worker')) {
            // Create UserData object and add to the list
            UserData userData = UserData(
              userId: userDoc.id,
              fullName: fullName,
              place: place,
              city: city,
              workExp: workExp,
              mobileNo: mobileNo,
              url: url,
              state: state,
              pin: pin,
              selectedOccupation: occupation,
            );
            glass_worker.add(userData);
            // print('User ID: ${userDoc.id}, Occupation: $occupation ,Full Name: $name ,Mobile No.: $mobileNumber');
          }
        }
      }
    } catch (error) {
      // Handle errors
      Fluttertoast.showToast(msg:'Error fetching Glass Worker, check Internet!');
    }

    return glass_worker;
  }

  Future<List<UserData>> getWelder() async {

    showDialog(context: context, builder: (context)
    {
      return Center(
        child: Container(
          height: 100,
          width: 390,
          decoration: BoxDecoration(
            color: const Color(0xff2b3d4f),
            borderRadius: BorderRadius.circular(20),
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30,0,0,0),
                    child: CircularProgressIndicator(
                      color: Color(0xff2b3d4f),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20,),
                  RichText(
                    text: const TextSpan(
                      text: "Processing Data Please Wait...",
                      style: TextStyle(color: Colors.white, decoration: TextDecoration.none),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      );
    });

    List<UserData> welder = [];

    try {
      // Query to get users with role 'WORKER'
      QuerySnapshot usersSnapshot = await _firestore.collection('users').where(
          'role', isEqualTo: 'WORKER').get();

      // Iterate through each user document
      for (DocumentSnapshot userDoc in usersSnapshot.docs) {
        // Get the reference to the 'workers' subcollection for each user
        CollectionReference workersCollectionRef =
        userDoc.reference.collection('workers');

        // Query the 'workers' subcollection to get the occupation data
        QuerySnapshot workersSnapshot = await workersCollectionRef.get();

        // Iterate through each document in the 'workers' subcollection
        for (DocumentSnapshot workerDoc in workersSnapshot.docs) {
          // Fetch additional data from the worker document
          String fullName = workerDoc['fullName'];
          String place = workerDoc['place'];
          String city = workerDoc['city'];
          String workExp = workerDoc['workExp'];
          String mobileNo = workerDoc['mobileNo'];
          String url = workerDoc['url'];
          String state = workerDoc['state'];
          String pin = workerDoc['pin'];

          // Access the occupation data
          List<dynamic> occupation = workerDoc['selectedOccupation'];

          // Check if the occupation contains 'Tiles Fitting'
          if (occupation.contains('Welder')) {
            // Create UserData object and add to the list
            UserData userData = UserData(
              userId: userDoc.id,
              fullName: fullName,
              place: place,
              city: city,
              workExp: workExp,
              mobileNo: mobileNo,
              url: url,
              state: state,
              pin: pin,
              selectedOccupation: occupation,
            );
            welder.add(userData);
            // print('User ID: ${userDoc.id}, Occupation: $occupation ,Full Name: $name ,Mobile No.: $mobileNumber');
          }
        }
      }
    } catch (error) {
      // Handle errors
      Fluttertoast.showToast(msg:'Error fetching Welder, check Internet!');
    }

    return welder;
  }

  Future<List<UserData>> getAluminium_Worker() async {

    showDialog(context: context, builder: (context)
    {
      return Center(
        child: Container(
          height: 100,
          width: 390,
          decoration: BoxDecoration(
            color: const Color(0xff2b3d4f),
            borderRadius: BorderRadius.circular(20),
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30,0,0,0),
                    child: CircularProgressIndicator(
                      color: Color(0xff2b3d4f),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20,),
                  RichText(
                    text: const TextSpan(
                      text: "Processing Data Please Wait...",
                      style: TextStyle(color: Colors.white, decoration: TextDecoration.none),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      );
    });

    List<UserData> aluminium_worker = [];

    try {
      // Query to get users with role 'WORKER'
      QuerySnapshot usersSnapshot = await _firestore.collection('users').where(
          'role', isEqualTo: 'WORKER').get();

      // Iterate through each user document
      for (DocumentSnapshot userDoc in usersSnapshot.docs) {
        // Get the reference to the 'workers' subcollection for each user
        CollectionReference workersCollectionRef =
        userDoc.reference.collection('workers');

        // Query the 'workers' subcollection to get the occupation data
        QuerySnapshot workersSnapshot = await workersCollectionRef.get();

        // Iterate through each document in the 'workers' subcollection
        for (DocumentSnapshot workerDoc in workersSnapshot.docs) {
          // Fetch additional data from the worker document
          String fullName = workerDoc['fullName'];
          String place = workerDoc['place'];
          String city = workerDoc['city'];
          String workExp = workerDoc['workExp'];
          String mobileNo = workerDoc['mobileNo'];
          String url = workerDoc['url'];
          String state = workerDoc['state'];
          String pin = workerDoc['pin'];

          // Access the occupation data
          List<dynamic> occupation = workerDoc['selectedOccupation'];

          // Check if the occupation contains 'Tiles Fitting'
          if (occupation.contains('Aluminium Worker')) {
            // Create UserData object and add to the list
            UserData userData = UserData(
              userId: userDoc.id,
              fullName: fullName,
              place: place,
              city: city,
              workExp: workExp,
              mobileNo: mobileNo,
              url: url,
              state: state,
              pin: pin,
              selectedOccupation: occupation,
            );
            aluminium_worker.add(userData);
            // print('User ID: ${userDoc.id}, Occupation: $occupation ,Full Name: $name ,Mobile No.: $mobileNumber');
          }
        }
      }
    } catch (error) {
      // Handle errors
      Fluttertoast.showToast(msg:'Error fetching Aluminium Worker, check Internet!');
    }

    return aluminium_worker;
  }

//-------------------------------------------------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(0.85)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('S E L E C T   W O R K E R',style: TextStyle(color: Colors.white),),
          centerTitle: true,
          backgroundColor: const Color(0xff2b3d4f),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          leading: BackButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Client_ScreenShow(),
              ),
            ),
          ),
        ),
        body: PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) async {
            if (didPop) {
              return;
            }
            if (context.mounted) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Client_ScreenShow(),
              ),
              );
            }
          },
          child: GridView.count(
            crossAxisCount: 2,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage('assets/images/electrician.png'),
                    ),
                    boxShadow: [
                      BoxShadow(
                        // color: Colors.grey.withOpacity(0.9),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),

                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async{
                        // Fetch electricians data
                        List<UserData> electricians = await getElectricians();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Result_ScreenShow(electricians: electricians)));
                      },
                      splashColor: const Color(0xff95a6a7),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage('assets/images/plumber.png'),
                    ),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async{
                        // Fetch plumbers data
                        List<UserData> plumbers = await getPlumbers();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Plumbers_Result_ScreenShow(plumbers: plumbers)));
                      },
                      splashColor: const Color(0xff95a6a7),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage('assets/images/reja.png'),
                    ),
                    boxShadow: [
                      BoxShadow(
                        // color: Colors.grey.withOpacity(0.9),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: ()  async{
                              // Fetch plumbers data
                                 List<UserData> rejas = await getRejas();
                                  Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                    builder: (context) => Rejas_Result_ScreenShow(rejas: rejas)));
                                  },
                      splashColor: const Color(0xff95a6a7),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage('assets/images/majdur.png'),
                    ),
                    boxShadow: [
                      BoxShadow(
                        // color: Colors.grey.withOpacity(0.9),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async{
                        // Fetch plumbers data
                        List<UserData> majdurs = await getMajdurs();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Majdurs_Result_ScreenShow(majdurs: majdurs)));
                      },
                      splashColor: const Color(0xff95a6a7),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage('assets/images/raj-mistry.png'),
                    ),
                    boxShadow: [
                      BoxShadow(
                        // color: Colors.grey.withOpacity(0.9),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async{
                        // Fetch plumbers data
                        List<UserData> mistrys = await getMistrys();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Mistrys_Result_ScreenShow(mistrys: mistrys)));
                      },
                      splashColor: const Color(0xff95a6a7),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage('assets/images/putty-n-painter.png'),
                    ),
                    boxShadow: [
                      BoxShadow(
                        // color: Colors.grey.withOpacity(0.9),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async{
                        // Fetch plumbers data
                        List<UserData> putty_painter = await getPutty_Painters();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PuttyNPainter_Result_ScreenShow(putty_painter: putty_painter)));
                      },
                      splashColor: const Color(0xff95a6a7),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage('assets/images/carpenter.png'),
                    ),
                    boxShadow: [
                      BoxShadow(
                        // color: Colors.grey.withOpacity(0.9),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async{
                        // Fetch plumbers data
                        List<UserData> carpenters = await getCarpenters();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Carpenters_Result_ScreenShow(carpenters: carpenters)));
                      },
                      splashColor: const Color(0xff95a6a7),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage('assets/images/tiles-fitting.png'),
                    ),
                    boxShadow: [
                      BoxShadow(
                        // color: Colors.grey.withOpacity(0.9),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async{
                        // Fetch plumbers data
                        List<UserData> tiles_fitting = await getTiles_Fitting();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TilesFitting_Result_ScreenShow(tiles_fitting: tiles_fitting)));
                      },
                      splashColor: const Color(0xff95a6a7),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage('assets/images/glass-worker.jpg'),
                    ),
                    boxShadow: [
                      BoxShadow(
                        // color: Colors.grey.withOpacity(0.9),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async{
                        // Fetch plumbers data
                        List<UserData> glass_worker = await getGlass_Worker();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GlassWorker_Result_ScreenShow(glass_worker: glass_worker)));
                      },
                      splashColor: const Color(0xff95a6a7),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage('assets/images/welder.jpg'),
                    ),
                    boxShadow: [
                      BoxShadow(
                        // color: Colors.grey.withOpacity(0.9),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async{
                        // Fetch plumbers data
                        List<UserData> welder = await getWelder();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Welder_Result_ScreenShow(welder: welder)));
                      },
                      splashColor: const Color(0xff95a6a7),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage('assets/images/aluminium-worker.jpg'),
                    ),
                    boxShadow: [
                      BoxShadow(
                        // color: Colors.grey.withOpacity(0.9),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async{
                        // Fetch plumbers data
                        List<UserData> aluminium_worker = await getAluminium_Worker();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AluminiumWorker_Result_ScreenShow(aluminium_worker: aluminium_worker)));
                      },
                      splashColor: const Color(0xff95a6a7),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  

}