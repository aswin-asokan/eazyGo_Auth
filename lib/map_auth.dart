import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazygoauth/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'dart:html';

import 'login.dart';

class map_auth extends StatefulWidget {
  const map_auth({super.key});

  @override
  State<map_auth> createState() => _map_authState();
}

class _map_authState extends State<map_auth> {
  late MapController _mapController = MapController();
  @override
  void initState() {
    super.initState();
    _mapController =
        MapController(); // Initialize the MapController in the initState method
  }

  bool isEmail(String input) {
    // Regular expression pattern to match an email address
    final pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(input);
  }

  String? titleB;
  var font1, font2, font3, font4, height, width;
  Color color1 = Color.fromRGBO(217, 233, 230, 1);
  Color color2 = Color(0xff1c6758);

  LatLng initialLocation = LatLng(position.latitude, position.longitude);
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('markersAuth');
  List<Marker> markers = [];
  int _counter = 0;
  void getMarker() {
    collectionReference
        .where('title', isEqualTo: titleB)
        .snapshots()
        .listen((querySnapshot) {
      markers.clear();
      for (var doc in querySnapshot.docs) {
        GeoPoint position = doc['position'];
        String title = doc['title'];
        String p = doc['provider'];
        String u = doc['user'];
        String description = doc['description'];
        String id = doc['id'];
        String color = doc['color'];
        double hue = double.parse(color);
        bool vis = doc['visible'];
        Color IconColor;
        if (title == 'Poor Road Condition') {
          IconColor = Colors.red;
        } else if (title == 'Pipe Leakage') {
          IconColor = Colors.blue;
        } else if (title == 'Traffic Signals not Working') {
          IconColor = Colors.green;
        } else if (title == 'Poor side walks') {
          IconColor = Colors.yellow;
        } else if (title == 'No zebra Crossing') {
          IconColor = Colors.orange;
        } else if (title == 'Other Issues') {
          IconColor = Colors.purple;
        } else {
          IconColor = Colors.red;
        }
        Marker marker = Marker(
          point: LatLng(position.latitude, position.longitude),
          builder: (ctx) => GestureDetector(
            onTap: () => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: color1,
                    titleTextStyle: GoogleFonts.urbanist(),
                    title: Text(
                      title,
                      style: GoogleFonts.urbanist(
                          color: color2,
                          fontWeight: FontWeight.bold,
                          fontSize: font2),
                    ),
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(left: 17),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Description of the Issue:',
                              style: GoogleFonts.urbanist(
                                  fontSize: font2, fontWeight: FontWeight.w600),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              description,
                              style: GoogleFonts.urbanist(
                                fontSize: font2,
                              ),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Report made by: $p',
                              style: GoogleFonts.urbanist(
                                fontSize: font2,
                              ),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            TextButton(
                                onPressed: () async {
                                  if (_counter == 1) {
                                    _counter = 0;
                                    QuerySnapshot querySnapshot =
                                        await FirebaseFirestore.instance
                                            .collection('markersAuth')
                                            .where('id', isEqualTo: id)
                                            .get();
                                    if (querySnapshot.docs.isNotEmpty) {
                                      DocumentSnapshot documentSnapshot =
                                          querySnapshot.docs.first;
                                      await documentSnapshot.reference.delete();
                                    }
                                    QuerySnapshot querySnapshot2 =
                                        await FirebaseFirestore.instance
                                            .collection('markers')
                                            .where('id', isEqualTo: id)
                                            .get();
                                    if (querySnapshot2.docs.isNotEmpty) {
                                      DocumentSnapshot documentSnapshot2 =
                                          querySnapshot2.docs.first;
                                      await documentSnapshot2.reference
                                          .delete();
                                    }
                                    if (isEmail(p)) {
                                      final Uri emailUri = Uri(
                                        scheme: 'https',
                                        path: p,
                                        queryParameters: {
                                          'subject': 'Feedback for your Report',
                                          'body':
                                              'Dear $u,\n\tWe hope this email finds you well. We wanted to take a moment to highlight the importance of reporting issues or concerns to the relevant authorities. As a valued member of our community, your active involvement plays a crucial role in maintaining a safe and secure environment for everyone.\n\tWe are happy to inform that the $title you reported on eazyGo app is fixed and removed from the application\n\nThank you for your time and support, we hope that you continue to support us.\n\nBest regards,\n\n[Your Name]\n[Your Title/Position]\n[Your Contact Information]',
                                        },
                                      );
                                      final gmailUrl = Uri(
                                        scheme: 'https',
                                        host: 'mail.google.com',
                                        path: '/mail/u/0/',
                                        queryParameters: {
                                          'view': 'cm',
                                          'to': emailUri.path,
                                          'su': emailUri
                                              .queryParameters['subject'],
                                          'body':
                                              emailUri.queryParameters['body'],
                                        },
                                      );
                                      window.open(
                                          gmailUrl.toString(), '_blank');
                                    }
                                    Navigator.pop(context);
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: color1,
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.report_problem_rounded,
                                                  color: Colors.red,
                                                ),
                                                Text(
                                                  'WARNING',
                                                  style: GoogleFonts.urbanist(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red,
                                                      fontSize: font2),
                                                )
                                              ],
                                            ),
                                            actions: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: width * 0.3,
                                                    child: RichText(
                                                      textAlign:
                                                          TextAlign.start,
                                                      text: TextSpan(
                                                        text:
                                                            'You are about to remove a reported issue from the map. Before proceeding, please confirm that the reported issue is fixed by the authority. If you are sure that the issue is fixed press on ',
                                                        style: GoogleFonts
                                                            .urbanist(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: font2,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                'Remove Issue',
                                                            style: GoogleFonts
                                                                .urbanist(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        font2,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                ' again to remove the marker after pressing ',
                                                            style: GoogleFonts
                                                                .urbanist(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        font2,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                          ),
                                                          TextSpan(
                                                            text: 'OK',
                                                            style: GoogleFonts
                                                                .urbanist(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        font2,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: TextButton(
                                                        onPressed: () async {
                                                          _counter++;
                                                          // ignore: use_build_context_synchronously
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          'OK',
                                                          style: GoogleFonts
                                                              .urbanist(
                                                                  fontSize:
                                                                      font2,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .red),
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                },
                                child: Text(
                                  'Remove Issue',
                                  style: GoogleFonts.urbanist(
                                      fontSize: font2,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red),
                                )),
                            TextButton(
                                onPressed: () {
                                  _counter--;
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.urbanist(
                                      fontSize: font2,
                                      fontWeight: FontWeight.w500,
                                      color: color2),
                                )),
                          ],
                        ),
                      )
                    ],
                  );
                }),
            child: Icon(
              Icons.location_on,
              color: IconColor,
              size: 30,
            ),
          ),
        );
        markers.add(marker);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    //Font size
    font1 = height * 0.03;
    font2 = height * 0.02;
    font3 = width * 0.039;
    font4 = width * 0.07;
    var w;
    if (width < 1466 && width > 1285) {
      w = width * 0.3;
    } else if (width < 1285 && width > 1140) {
      w = width * 0.35;
    } else if (width < 1140 && width > 1005) {
      w = width * 0.4;
    } else if (width < 1005 && width > 880) {
      w = width * 0.45;
    } else if (width < 880 && width > 755) {
      w = width * 0.5;
    } else if (width < 755) {
      w = width;
    } else if (width > 1466) {
      w = width * 0.27;
    }
    return Scaffold(
      body: Stack(children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(center: initialLocation, zoom: 16, maxZoom: 18),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(markers: markers),
          ],
        )
      ]),
      floatingActionButton: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: color1),
        height: height * 0.08,
        width: w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                tooltip: 'Road Issues',
                onPressed: () {
                  setState(() {
                    titleB = 'Poor Road Condition';
                  });
                  getMarker();
                },
                icon: Icon(
                  Icons.remove_road_outlined,
                  color: color2,
                  size: height * 0.05,
                )),
            SizedBox(
              width: width * 0.01,
            ),
            IconButton(
                tooltip: 'Pipe Leakage',
                onPressed: () {
                  setState(() {
                    titleB = 'Pipe Leakage';
                  });
                  getMarker();
                },
                icon: Icon(
                  Icons.water_drop_outlined,
                  color: color2,
                  size: height * 0.05,
                )),
            SizedBox(
              width: width * 0.01,
            ),
            IconButton(
                tooltip: 'No Traffic Signals',
                onPressed: () {
                  setState(() {
                    titleB = 'Traffic Signals not Working';
                  });
                  getMarker();
                },
                icon: Icon(
                  Icons.traffic_outlined,
                  color: color2,
                  size: height * 0.05,
                )),
            SizedBox(
              width: width * 0.01,
            ),
            IconButton(
                tooltip: 'Poor Side Walks',
                onPressed: () {
                  setState(() {
                    titleB = 'Poor side walks';
                  });
                  getMarker();
                },
                icon: Icon(
                  Icons.directions_walk_outlined,
                  color: color2,
                  size: height * 0.05,
                )),
            SizedBox(
              width: width * 0.01,
            ),
            IconButton(
                tooltip: 'No zebra Crossing',
                onPressed: () {
                  setState(() {
                    titleB = 'No zebra Crossing';
                  });
                  getMarker();
                },
                icon: Icon(
                  Icons.calendar_view_day,
                  color: color2,
                  size: height * 0.05,
                )),
            SizedBox(
              width: width * 0.01,
            ),
            IconButton(
                tooltip: 'Other Issues',
                onPressed: () {
                  setState(() {
                    titleB = 'Other Issues';
                  });
                  getMarker();
                },
                icon: Icon(
                  Icons.error_outline_sharp,
                  color: color2,
                  size: height * 0.05,
                )),
            SizedBox(
              width: width * 0.01,
            ),
            IconButton(
                tooltip: 'Initial location',
                onPressed: () {
                  _mapController.move(initialLocation, 15);
                },
                icon: Icon(
                  Icons.location_on_outlined,
                  color: color2,
                  size: height * 0.05,
                )),
            SizedBox(
              width: width * 0.01,
            ),
            IconButton(
                tooltip: 'Log Out',
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context,
                      (MaterialPageRoute(builder: (context) => loginPage())));
                },
                icon: Icon(
                  Icons.logout_outlined,
                  color: color2,
                  size: height * 0.05,
                )),
            SizedBox(
              width: width * 0.01,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
