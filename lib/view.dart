import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
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
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
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
                            height: MediaQuery.of(context).size.height * 0.02),
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

                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),

                        Container(
                          height: MediaQuery.of(context).size.height * 0.735,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              var data = snapshot.data.docs[index].data();

                              var time = data['time'].toDate();

                              print(Jiffy(time).yMMMMEEEEdjm);

                              var timeFormatted = Jiffy(time).fromNow();

                              var description = data['description'];

                              var dangerLevel = data['danger level'];

                              return Column(
                                children: [
                                  Center(
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10, top: 10),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  Colors.white.withOpacity(0.1),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20,
                                                  left: 20,
                                                  bottom: 20,
                                                  right: 20),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text('Time: ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                      Text(
                                                          timeFormatted
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300)),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('Situation: ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                      Flexible(
                                                        child: Text(description,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 50,
                                          width: 50,
                                          child: Center(
                                            child: Text((dangerLevel/10).round().toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                      ],
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
