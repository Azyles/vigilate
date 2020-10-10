import 'package:flutter/material.dart';

class ReportListView extends StatefulWidget {
  @override
  ReportListViewState createState() => ReportListViewState();
}

class ReportListViewState extends State<ReportListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [

          //Title Text and Icon ////
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'West Valley Mall',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w300),
              ),
              Container(
                width: 30,
              ),
              Icon(Icons.message_outlined)
            ],
          )),

          //End of Title Text and Icon ///

          


        ],
      ),
    );
  }
}
