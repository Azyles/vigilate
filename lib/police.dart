import 'package:flutter/material.dart';

class PoliceView extends StatefulWidget {
  @override
  _PoliceViewState createState() => _PoliceViewState();
}

class _PoliceViewState extends State<PoliceView> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 80
              ),
              Column(
                children: [
                  Text(
                'Alert',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w300),
              ),
              Container(
                height: 50
              ),
               GestureDetector(
                 child: Container(
                  height: 300,
                  width: 300,
                   decoration:
                     BoxDecoration(color: Colors.red[300],
                    borderRadius: BorderRadius.circular(300)
                    ),

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

               Row(
                 children: [
                   Switch(
                      value: isSwitched,
                      onChanged: (value){
                        setState(() {
                          isSwitched=value;
                          print(isSwitched);
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                  ),
                 ],
               )
              
                ],
              )
            ],
          )),
        ],
      ),
    );
  }
}
