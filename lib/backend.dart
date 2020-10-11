import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class Backend {
  var city = '';

  getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    print('location: ${position.latitude}, ${position.longitude}');
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");

    print("City : ${first.locality}");

    city = first.locality;

    var location = first.addressLine;

    var street = location.substring(0, location.indexOf(','));

    return ([position.latitude, position.longitude, first.locality, street]);
  }

  getLiveAlerts(city, context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    print("GEtting live alerts");

    //var location = await getCurrentLocation();

    //var latitude = location[0];
    //var longitude = location[1];

    // ~1 mile of lat and lon in degrees
    //var lat = 0.0144927536231884;
    //var lon = 0.0181818181818182;

    //var lowerLat = latitude - (lat * 3);
    //var lowerLon = longitude - (lon * 3);

    //var greaterLat = latitude + (lat * 3);
    //var greaterLon = longitude + (lon * 3);

    //var lesserGeopoint = GeoPoint(lowerLat, lowerLon);
    //var greaterGeopoint = GeoPoint(greaterLat, greaterLon);

    var reference =
        firestore.collection('Cities').doc(city).collection("Alerts");

    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((point) async {
        print("NEW POLICE ALERT" + point.doc.data().toString());

        var data = point.doc.data();

        //var long = data['longitude'];

        //var lat = data['latitude'];

        var reportTime = data['time'].toDate();

        //var id = point.doc.id;

        var description = data['description'];

        showDialog(
          barrierColor: Colors.transparent,
          context: context,
          builder: (_) => Material(
            type: MaterialType.transparency,
            child: Center(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: ClipRect(
                        child: new BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: 10.0, sigmaY: 10.0),
                            child: new Container(
                              height: 200.0,
                              decoration: new BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "New incident reported",
                                        style: TextStyle(fontSize: 24),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Time: " + Jiffy(reportTime).fromNow() + "\n" + "Description: " + description,
                                        style: TextStyle(fontSize: 18),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 170, right: 20),
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Center(
                          child: Text("⚠️",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700)),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}
