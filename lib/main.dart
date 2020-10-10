import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vigilate/backend.dart';
import 'package:vigilate/report.dart';
import 'package:vigilate/view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vigilate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  getLivePoints(city) async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var reference = firestore
        .collection('Cities')
        .doc(city)
        .collection("Reports")
        .where("active", isEqualTo: true);
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((point) {
        print(point.doc.data());

        var data = point.doc.data();

        var longitude = data['longitude'];

        var latitude = data['latitude'];

        var reportTime = data['time'];

        var id = point.doc.id;

        addMarker(longitude, latitude, id);
      });
    });
  }

  Future addMarker(long, lat, id) async {
    setState(() {
      var marker = new Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: MarkerId(id),
        position: LatLng(long, lat),
        infoWindow: InfoWindow(title: "Incident", snippet: '*'),
      );
      markers[id] =
          marker; // What I do here is modify the only marker in the Map.
    });
    markers.forEach((id, marker) {
      // This is used to see if the marker properties did change, and they did.
      debugPrint("MarkerId: $id");
      debugPrint(
          "Marker: [${marker.position.latitude},${marker.position.longitude}]");
    });
  }

  Future startup() async {
    Backend backendInstance = new Backend();

    var location = await backendInstance.getCurrentLocation();

    print(location);

    final CameraPosition _default = CameraPosition(
      target: LatLng(location[0], location[1]),
      zoom: 12,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_default));

    getLivePoints(location[2]);
  }

  @override
  void initState() {
    startup();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Vigilate"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: const LatLng(-100, 0),
            zoom: 2,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: Set<Marker>.of(markers.values),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        color: Colors.black,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                    child: Text(
                  "Dashboard",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600),
                )),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReportView()),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.redAccent[400]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "Report",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReportListView()),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue[300]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "Recent Reports",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            )),
      ),
    );
  }
}
