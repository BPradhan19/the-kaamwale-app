import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:thekaamwale/Workers/Worker_ScreenShow.dart';

import 'Worker_Update_ProfileShow.dart';

class Worker_Profile_Exists extends StatefulWidget {
  const Worker_Profile_Exists({super.key});

  @override
  State<Worker_Profile_Exists> createState() => _Worker_Profile_ExistsState();
}

final uid = FirebaseAuth.instance.currentUser!.uid;

Future<List<DocumentSnapshot>> _fetchData() async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
      .instance
      .collection('users') // Access the 'users' collection
      .doc(uid) // Access a specific document within the 'users' collection
      .collection(
          'workers') // Access the 'workers' sub-collection within that document
      .get();
  return querySnapshot.docs;
}




//-------------------------------------------------------------------------------------------------------------------------------------------

class _Worker_Profile_ExistsState extends State<Worker_Profile_Exists> {

  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {



    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(0.85)),
      child: Scaffold(
        //  backgroundColor: const Color(0xffF0F8FF),
        appBar: AppBar(
          title: const Text('M Y  P R O F I L E',
              style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xff2b3d4f),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          leading: BackButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Worker_ScreenShow(),
              ),
            ),
          ),
        ),
        body: FutureBuilder(
          future: _fetchData(),
          builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmer();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return PopScope(
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
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: const BoxDecoration(
                            image: DecorationImage(image: AssetImage('assets/images/cwallpaper.jpg'),fit: BoxFit.cover),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.indigo, width: 1),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.9),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Image(
                                      image: NetworkImage(
                                          '${snapshot.data![index]['url']}'),
                                      width: 125,
                                      height: 125,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        MediaQuery(
                          data: MediaQuery.of(context),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1,
                            height: MediaQuery.of(context).size.height ,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xff95a6a7), Color(0xff2b3d4f)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  SelectableText(
                                    'WUID:- ${snapshot.data![index]['uid']}',
                                    cursorColor: Colors.amber,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  MediaQuery(
                                    data: MediaQuery.of(context),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height * 0.2,
                                      width: 360,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff95a6a7),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text('P E R S O N A L  D E T A I L S'),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                width: 55,
                                              ),
                                              const Text(
                                                'F U L L  N A M E :-',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Expanded(
                                                child: AutoSizeText(
                                                  ' ${snapshot.data![index]['fullName']}',
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 55,
                                              ),
                                              const Text(
                                                'M O B I L E  N U M B E R :-',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  ' ${snapshot.data![index]['mobileNo']}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                          
                                  MediaQuery(
                                    data: MediaQuery.of(context),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height * 0.2,
                                      width: 360,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff95a6a7),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child:  Column(
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text('W O R K  D E T A I L S'),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                width: 55,
                                              ),
                                              const Text('O C C U P A T I O N :-',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              Expanded(
                                                child: AutoSizeText(' ${snapshot.data![index]['selectedOccupation']}',
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 55,
                                              ),
                                              const Text('E X P E R I E N C E :-',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(' ${snapshot.data![index]['workExp']}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold
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
                                    height: 10,
                                  ),
                                  MediaQuery(
                                    data: MediaQuery.of(context),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height * 0.3,
                                      width: 360,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff95a6a7),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text('A D D R E S S  D E T A I L S'),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 55,
                                              ),
                                              const Text('P L A C E :-',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              Expanded(
                                                child: AutoSizeText(' ${snapshot.data![index]['place']}',
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 55,
                                              ),
                                              const Text('C I T Y :-',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              Expanded(
                                                child: AutoSizeText(' ${snapshot.data![index]['city']}',
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                                              
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 55,
                                              ),
                                              const Text('S T A T E :-',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              Expanded(
                                                child: AutoSizeText(' ${snapshot.data![index]['state']}',
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                                              
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 55,
                                              ),
                                              const Text('P I N C O D E :-',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(' ${snapshot.data![index]['pin']}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold
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
                                    height: 25,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                          
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Worker_Update_ProfileShow(),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.update),
                                        label: const Text("U P D A T E"),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: const Color(
                                              0xff2b3d4f), // Set the text color
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 45,
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Worker_ScreenShow(),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.home),
                                        label: const Text("H O M E"),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: const Color(
                                              0xff95a6a7), // Set the text color
                                        ),
                                      ),
                          
                                    ],
                                  ),
                                  const SizedBox(height: 50,),
                          
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

Widget _buildShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    enabled: true,
    child: SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 16.0),
          // Placeholder for profile picture
          Center(
            child: Container(
              width: 125,
              height: 125,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          const SizedBox(height: 35.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(20,0,20,0),
            child: Container(
              width: double.infinity,
              height: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 45),
          // Placeholder for personal details
          Padding(
            padding: const EdgeInsets.fromLTRB(20,0,20,0),
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          // Placeholder for address details
          Padding(
            padding: const EdgeInsets.fromLTRB(20,0,20,0),
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(20,0,20,0),
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
