import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:vigilate/main.dart';
import 'package:vigilate/view.dart';

import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vigilate/backend.dart';
import 'package:vigilate/report.dart';
import 'package:vigilate/view.dart';

class ReportView extends StatefulWidget {
  @override
  _ReportViewState createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  int tag = 1;

  var descriptionController = TextEditingController();

  List<String> options = [
    'Robbery',
    'Suspicious Person',
    'Potential',
    'Potential',
  ];

  double dangerlevel = 20;

  addReport() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var backendInstance = new Backend();

    var location = await backendInstance.getCurrentLocation();

    var description = descriptionController.text;

    var danger = dangerlevel;

    print("MAIN LOCATION " + location[0] + "," + location[1]);

    firestore
        .collection("Cities")
        .doc(location[2])
        .collection("Reports")
        .doc()
        .set({
      "active": true,
      "latitude": location[0],
      "longitude": location[1],
      "time": new DateTime.now(),
      "danger level": danger,
      "description": description
    }).then((value) => {
              //Navigator.push(
                  //context, MaterialPageRoute(builder: (context) => HomePage()))
          
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Center(
            child: Text(
              "Add Report",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w300),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Concern Level (0 - 100)",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.005),
          Slider(
            activeColor: Colors.deepOrangeAccent[400],
            inactiveColor: Colors.deepOrange[200],
            value: dangerlevel,
            min: 0,
            max: 100,
            divisions: 5,
            label: dangerlevel.round().toString(),
            onChanged: (double value) {
              setState(() {
                dangerlevel = value;
              });
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Event description",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[900], width: 2)),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: TextField(
                  controller: descriptionController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Short and clear description of the event.',
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ChipsChoice<int>.single(
            choiceStyle: C2ChoiceStyle(
                color: Colors.grey[900], brightness: Brightness.dark),
            choiceActiveStyle: C2ChoiceStyle(
              color: Colors.redAccent[400],
              brightness: Brightness.dark,
            ),
            value: tag,
            onChanged: (val) => setState(() => tag = val),
            choiceItems: C2Choice.listFrom<int, String>(
              source: options,
              value: (i, v) => i,
              label: (i, v) => v,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[900]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Upload Image",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Center(
            child: GestureDetector(
              onTap: () async {
                //Add to firebase
                await addReport();
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
                      "Report Activity",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
