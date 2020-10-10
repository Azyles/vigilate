import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vigilate/backend.dart';

class ReportListView extends StatefulWidget {
  @override
  ReportListViewState createState() => ReportListViewState();
}

class ReportListViewState extends State<ReportListView> {
  @override
  Widget build(BuildContext context) {
    var backendInstance = new Backend();

    return Scaffold(
        body: FutureBuilder(
            future: backendInstance.getCurrentLocation(),
            builder: (BuildContext context, snapshot) {
              var location = snapshot.data;

              var city = location[2];

              var reports = FirebaseFirestore.instance
                  .collection('Cities')
                  .doc(location[2])
                  .collection("Reports")
                  .orderBy("time", descending: true);

              return new StreamBuilder(
                  stream: reports.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    return Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              city,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        )),

                        //End of Title Text and Icon ///

                        Container(
                          height: 40,
                        ),

                        Container(
                          height: MediaQuery.of(context).size.height*0.79,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {

                            print(snapshot.data.docs[index].data());

                            
                            return Column(
                              children: [
                                Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 160,
                               
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Time: ',
                                    ),
                                    Text('Situation: ')
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                              ],
                            );
                          },
                        ),
                        ),

           
                      ],
                    );
                  });
            }));
  }
}
