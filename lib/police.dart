import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vigilate/backend.dart';
import 'package:vigilate/main.dart';

class PoliceView extends StatefulWidget {
  @override
  _PoliceViewState createState() => _PoliceViewState();
}

class _PoliceViewState extends State<PoliceView> {
  bool isSwitched = false;

  var descriptionController = new TextEditingController();

  alertNearby() async {
    var firestore = FirebaseFirestore.instance;

    var backendInstance = new Backend();

    var location = await backendInstance.getCurrentLocation();

    var id = new DateTime.now().toString();

    firestore
        .collection("Cities")
        .doc(location[2])
        .collection("Alerts")
        .doc(id)
        .set({
      "longitude": location[0],
      "latitude": location[1],
      "description": descriptionController.text,
      "street": location[3],
      "location": GeoPoint(location[0], location[1]),
      "time": new DateTime.now()
    }).then((value) {
      print("CREATED");

      Future.delayed(Duration(seconds: 2)).then((value) {
        firestore
            .collection("Cities")
            .doc(location[2])
            .collection("Alerts")
            .doc(id)
            .delete()
            .then((value) {
              print("DELETED");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(height: 80),
              Column(
                children: [
                  Text(
                    'Alert',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w300),
                  ),
                  Container(height: 50),
                  GestureDetector(
                    onTap: () async {
                      await alertNearby();
                    },
                    child: Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.red[300],
                          borderRadius: BorderRadius.circular(300)),
                      child: Center(
                        child: Text(
                          'ALERT CURRENT LOCATION',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Row(children: [
                    Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                          print(isSwitched);
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                    Container(
                      width: 40,
                    ),
                    Text(
                      'Alert Sound',
                      style: TextStyle(fontSize: 20),
                    )
                  ]),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey[900], width: 2)),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        child: TextField(
                          controller: descriptionController,
                          maxLines: 10,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                'Short and clear description of the event.',
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                        width: 300,
                        child: Text(
                            'Info: Keep in mind before you alert everyone at your location.  Once you alert everyone, each person will get a notification.  Only use Alert Sound when situation is dire')),
                  ),
                ],
              )
            ],
          )),
        ],
      ),
    );
  }
}
