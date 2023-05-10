import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazygoauth/login.dart';
import 'package:eazygoauth/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class map extends StatefulWidget {
  const map({super.key});

  @override
  State<map> createState() => _mapState();
}

class _mapState extends State<map> {
  @override
  void initState() {
    super.initState();
  }

  late GoogleMapController mapController;
  void locate() {
    LatLng latlngposition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latlngposition, zoom: 16);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  String? titleB;
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('markersAuth');
  Color color1 = Color.fromRGBO(217, 233, 230, 1);
  Color color2 = Color(0xff1c6758);
  List<Marker> myMarker = [];
  List<Marker> markers = [];
  var font1, font2, font3, font4, height, width;
  void _getMarkersFromFirestore() {
    collectionReference
        .where('title', isEqualTo: titleB)
        .snapshots()
        .listen((querySnapshot) {
      markers.clear();
      for (var doc in querySnapshot.docs) {
        GeoPoint position = doc['position'];
        String title = doc['title'];
        String p = doc['provider'];
        String description = doc['description'];
        String id = doc['id'];
        String color = doc['color'];
        double hue = double.parse(color);
        bool vis = doc['visible'];
        Marker marker = Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(position.latitude, position.longitude),
          visible: vis,
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
          infoWindow: InfoWindow(
            title: title,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    int _counter = 0;
                    return StatefulBuilder(builder: (context, setState) {
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
                            padding: EdgeInsets.only(left: 20),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Description of the Issue:',
                                  style: GoogleFonts.urbanist(
                                      fontSize: font2,
                                      fontWeight: FontWeight.w600),
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
                                          await documentSnapshot.reference
                                              .delete();
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
                                                      Icons
                                                          .report_problem_rounded,
                                                      color: Colors.red,
                                                    ),
                                                    Text(
                                                      'WARNING',
                                                      style:
                                                          GoogleFonts.urbanist(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors.red,
                                                              fontSize: font2),
                                                    )
                                                  ],
                                                ),
                                                actions: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                                                                    fontSize:
                                                                        font2,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    'Remove Issue',
                                                                style: GoogleFonts.urbanist(
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
                                                                style: GoogleFonts.urbanist(
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
                                                                style: GoogleFonts.urbanist(
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
                                                        alignment:
                                                            Alignment.center,
                                                        child: TextButton(
                                                            onPressed:
                                                                () async {
                                                              _counter++;
                                                              // ignore: use_build_context_synchronously
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                              'OK',
                                                              style: GoogleFonts.urbanist(
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
                    });
                  });
            },
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
    print(width);
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 14),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            padding: EdgeInsets.only(top: 250),
            zoomControlsEnabled: false,
            mapType: MapType.hybrid,
            markers: Set.of(markers),
          )
        ],
      ),
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
                  _getMarkersFromFirestore();
                },
                icon: Icon(
                  Icons.remove_road_outlined,
                  color: color2,
                  size: height * 0.05,
                )),
            SizedBox(
              width: width * 0.005,
            ),
            IconButton(
                tooltip: 'Pipe Leakage',
                onPressed: () {
                  setState(() {
                    titleB = 'Pipe Leakage';
                  });
                  _getMarkersFromFirestore();
                },
                icon: Icon(
                  Icons.water_drop_outlined,
                  color: color2,
                  size: height * 0.05,
                )),
            SizedBox(
              width: width * 0.005,
            ),
            IconButton(
                tooltip: 'No Traffic Signals',
                onPressed: () {
                  setState(() {
                    titleB = 'Traffic Signals not Working';
                  });
                  _getMarkersFromFirestore();
                },
                icon: Icon(
                  Icons.traffic_outlined,
                  color: color2,
                  size: height * 0.05,
                )),
            SizedBox(
              width: width * 0.005,
            ),
            IconButton(
                tooltip: 'Poor Side Walks',
                onPressed: () {
                  setState(() {
                    titleB = 'Poor side walks';
                  });
                  _getMarkersFromFirestore();
                },
                icon: Icon(
                  Icons.directions_walk_outlined,
                  color: color2,
                  size: height * 0.05,
                )),
            SizedBox(
              width: width * 0.005,
            ),
            IconButton(
                tooltip: 'No zebra Crossing',
                onPressed: () {
                  setState(() {
                    titleB = 'No zebra Crossing';
                  });
                  _getMarkersFromFirestore();
                },
                icon: Icon(
                  Icons.calendar_view_day,
                  color: color2,
                  size: height * 0.05,
                )),
            SizedBox(
              width: width * 0.005,
            ),
            IconButton(
                tooltip: 'Other Issues',
                onPressed: () {
                  setState(() {
                    titleB = 'Other Issues';
                  });
                  _getMarkersFromFirestore();
                },
                icon: Icon(
                  Icons.error_outline_sharp,
                  color: color2,
                  size: height * 0.05,
                )),
            SizedBox(
              width: width * 0.005,
            ),
            IconButton(
                tooltip: 'Initial location',
                onPressed: locate,
                icon: Icon(
                  Icons.location_on_outlined,
                  color: color2,
                  size: height * 0.05,
                )),
            SizedBox(
              width: width * 0.005,
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
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  void onMapCreated(controller) async {
    setState(() {
      mapController = controller;
      locate();
    });
  }
}
