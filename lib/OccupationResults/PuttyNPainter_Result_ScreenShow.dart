import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Clients/SelectWorkers_ScreenShow.dart';

class PuttyNPainter_Result_ScreenShow extends StatefulWidget {
  final List<UserData> putty_painter;

  const PuttyNPainter_Result_ScreenShow({Key? key, required this.putty_painter})
      : super(key: key);

  @override
  State<PuttyNPainter_Result_ScreenShow> createState() => _PuttyNPainter_Result_ScreenShowState();
}

class _PuttyNPainter_Result_ScreenShowState extends State<PuttyNPainter_Result_ScreenShow> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchpinController = TextEditingController();
  bool _isAscending = true;

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
        appBar: AppBar(
          title: const Text(
            'S E A R C H   R E S U L T',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xff2b3d4f),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          leading: BackButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SelectWorkers_ScreenShow(),
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isAscending = !_isAscending;
                  widget.putty_painter.sort((a, b) {
                    if (_isAscending) {
                      return a.place.compareTo(b.place);
                    } else {
                      return b.place.compareTo(a.place);
                    }
                  });

                  widget.putty_painter.sort((a, b) {
                    if (_isAscending) {
                      return a.pin.compareTo(b.pin);
                    } else {
                      return b.pin.compareTo(a.pin);
                    }
                  });

                });
              },
              icon: const Icon(Icons.sort),
            ),
          ],
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: Column(
            children: [
              const SizedBox(height: 20,),
              PopScope(
                canPop: false,
                onPopInvoked: (bool didPop) async {
                  if (didPop) {
                    return;
                  }
                  if (context.mounted) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectWorkers_ScreenShow(),
                    ),
                    );
                  }
                },
                child: const AutoSizeText(
                  "*Search Putty/Painter with Place and Pincode here*",
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2b3d4f)
                  ),
                ),
              ),

              const SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,0),
                      child: TextFormField(

                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            widget.putty_painter.sort((a, b) {
                              if (a.place.toLowerCase().contains(value.toLowerCase()) &&
                                  !b.place.toLowerCase().contains(value.toLowerCase())) {
                                return -1;
                              } else if (!a.place
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) &&
                                  b.place.toLowerCase().contains(value.toLowerCase())) {
                                return 1;
                              } else {
                                return 0;
                              }
                            });
                          });
                        },
                        decoration:  InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'P L A C E...',
                          focusedBorder: OutlineInputBorder(
                            borderSide:  const BorderSide(color: Color(0xff2b3d4f)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:  const BorderSide(color: Color(0xff2b3d4f)),
                            borderRadius: BorderRadius.circular(20),
                          ),

                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 50,
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,0),
                      child: TextFormField(

                        controller: _searchpinController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6), // Limit input length to 6 characters
                        ],
                        onChanged: (value) {
                          setState(() {
                            widget.putty_painter.sort((a, b) {
                              if (a.pin.toLowerCase().contains(value.toLowerCase()) &&
                                  !b.pin.toLowerCase().contains(value.toLowerCase())) {
                                return -1;
                              } else if (!a.pin
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) &&
                                  b.pin.toLowerCase().contains(value.toLowerCase())) {
                                return 1;
                              } else {
                                return 0;
                              }
                            });
                          });
                        },
                        decoration:  InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'P I N C O D E...',
                          focusedBorder: OutlineInputBorder(
                            borderSide:  const BorderSide(color: Color(0xff2b3d4f)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:  const BorderSide(color: Color(0xff2b3d4f)),
                            borderRadius: BorderRadius.circular(20),
                          ),

                        ),
                      ),
                    ),
                  ),

                ],
              ),


              const SizedBox(height: 10,),
              Flexible(
                child: ListView.builder(
                  itemCount: widget.putty_painter.length,
                  itemBuilder: (context, index) {
                    // Build a ListTile for each electrician
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: MediaQuery(
                        data: MediaQuery.of(context),
                        child: Container(
                        
                          //height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width * 1,
                        
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff95a6a7), Color(0xff2b3d4f)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    MediaQuery(
                                      data: MediaQuery.of(context),
                                      child: Container(
                                        height: 120,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff95a6a7),
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundImage: NetworkImage(
                                              widget.putty_painter[index].url), //
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: MediaQuery(
                                        data: MediaQuery.of(context),
                                        child: Container(
                                          height: 120,
                                          width: 195,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff95a6a7),
                                            borderRadius: BorderRadius.circular(15.0),
                                          ),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Expanded(
                                                child: AutoSizeText(
                                                  widget.putty_painter[index]
                                                      .selectedOccupation
                                                      .join(", "),
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  AutoSizeText(
                                                    widget.putty_painter[index].workExp,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const AutoSizeText(
                                                    ' (Year Experience)',
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              AutoSizeText(
                                                widget.putty_painter[index].place,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              AutoSizeText(
                                                widget.putty_painter[index].city,
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              AutoSizeText(
                                                widget.putty_painter[index].state,
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              AutoSizeText(
                                                widget.putty_painter[index].pin,
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    MediaQuery(
                                      data: MediaQuery.of(context),
                                      child: Container(
                                        height: 120,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            color: const Color(0xff95a6a7),
                                            borderRadius: BorderRadius.circular(15.0)),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () async {
                                              final String mobileNo = widget.putty_painter[index].mobileNo;
                                              final Uri phoneNumber = Uri.parse('tel:$mobileNo');
                                              if (await canLaunchUrl(phoneNumber)) { // Use canLaunchUrl
                                                await launchUrl(phoneNumber); // Use launchUrl
                                              } else {
                                                // Handle error if the phone call cannot be launched
                                                Fluttertoast.showToast(msg:'Could not launch phone call');
                                              }
                                            },
                                            splashColor: const Color(0xff2b3d4f),
                                            child: const Icon(
                                              Icons.call,
                                              size: 35,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                AutoSizeText(
                                  widget.putty_painter[index].fullName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
