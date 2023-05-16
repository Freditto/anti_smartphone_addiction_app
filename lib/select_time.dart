// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class Select_TimeScreen extends StatefulWidget {
  String? packageName;

  Select_TimeScreen(
    
    this.packageName,
  );
  @override
  State<Select_TimeScreen> createState() => _Select_TimeScreenState();
}

class _Select_TimeScreenState extends State<Select_TimeScreen> {
  bool _dailyMode = true;
  String? chooseEndTimeValue;

  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text('Select Time', style: TextStyle(color: Colors.black)),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(
        //       Icons.add,
        //       color: Colors.black,
        //     ),
        //     onPressed: () async {

        // do something
        // final PermissionStatus permissionStatus =
        //     await _getPermission();
        // if (permissionStatus ==
        //     PermissionStatus.granted) {
        //   //We can now access our contacts here

        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) =>
        //               SelectContactScreen()));
        // } else {
        //   //If permissions have been denied show standard cupertino alert dialog
        //   showDialog(
        //       context: context,
        //       builder: (BuildContext context) =>
        //           CupertinoAlertDialog(
        //             title:
        //                 Text('Permissions error'),
        //             content: Text(
        //                 'Please enable contacts access '
        //                 'permission in system settings'),
        //             actions: <Widget>[
        //               CupertinoDialogAction(
        //                 child: Text('OK'),
        //                 onPressed: () =>
        //                     Navigator.of(context)
        //                         .pop(),
        //               )
        //             ],
        //           ));
        // }
        // },
        // )
        // ],
      ),
      body: ListView(
        children: [
          _timeSpinnnerView(),

          // TextFormField(
          //   // minLines: 5,
          //   // maxLines: 7,
          //   decoration: InputDecoration(
          //     hintText: 'Silent Name eg: meeting',
          //   ),

          //   // controller: controllerAddress,
          // ),

          const SizedBox(
            height: 16,
          ),

          SwitchListTile(
            value: _dailyMode,
            title: Text(
              'Everyday',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'Silence 1 hr On time setted',
            ),
            secondary: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Icon(Icons.wifi),
            ),
            onChanged: (newValue) {
              setState(() {
                _dailyMode = newValue;
              });
            },
            // visualDensity: VisualDensity.adaptivePlatformDensity,
            // switchType: SwitchType.material,
            activeColor: Colors.indigo,
          ),

          SwitchListTile(
            value: _dailyMode,
            title: Text(
              'EveryWeek',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'Silence 1 hr On time setted',
            ),
            secondary: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Icon(Icons.wifi),
            ),
            onChanged: (newValue) {
              setState(() {
                _dailyMode = newValue;
              });
            },
            // visualDensity: VisualDensity.adaptivePlatformDensity,
            // switchType: SwitchType.material,
            activeColor: Colors.indigo,
          ),

          Container(
            // padding: const EdgeInsets.all(0.0),
            padding:
                EdgeInsets.only(left: 10.0, right: 10.0, top: 0, bottom: 0),
            // decoration: BoxDecoration(
            //     border: Border.all(color: Colors.grey),
            //     borderRadius: BorderRadius.circular(12)),
            child: DropdownButton<String>(
              value: chooseEndTimeValue,
              //elevation: 5,
              // style: TextStyle(color: Colors.black),

              hint: Text('Select End Time Interval'),
              dropdownColor: Colors.white,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 36,
              isExpanded: true,
              underline: SizedBox(),
              style: TextStyle(color: Colors.black, fontSize: 15),

              items: <String>[
                '15 Minutes',
                '30 Minutes', 
                '1 Hour',
                '3 Hour',
                '6 Hour',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),

              onChanged: (String? value) {
                print(value);
                // var v = '0';
                // if (value == 'Revenue') {
                //   v = '1';
                // }
                setState(() {
                  chooseEndTimeValue = value;
                  // _visible_tag = v;
                });
              },
            ),
          ),

          // RadioButtonGroup(
          //   labels: [
          //     "Personal",
          //     "Business",
          //   ],
          //   labelStyle:
          //       TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
          //   // disabled: ["Option 1"],
          //   onChange: (String label, int index) => setState(() {
          //     value = index;
          //     print("label: $label index: $index");
          //   }),

          //   onSelected: (String label) => print(label),
          // ),

          // const SizedBox(
          //   height: 16,
          // ),
        ],
      ),
      bottomNavigationBar: Container(
        // height: 100,
        // color: Colors.white,
        padding: EdgeInsets.all(20),
        // margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              spreadRadius: -4,
              blurRadius: 25,
              offset: Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Cancel'),
              Text('Save'),
            ],
          ),
        ),
      ),
    );
  }

  _timeSpinnnerView() {
    return Container(
      padding: EdgeInsets.only(top: 50),
      child: Column(
        children: <Widget>[
          //            hourMinute12H(),
          hourMinute15Interval(),
          //            hourMinuteSecond(),
          //            hourMinute12HCustomStyle(),
          Container(
            margin: EdgeInsets.symmetric(vertical: 50),
            child: Text(
              _dateTime.hour.toString().padLeft(2, '0') +
                  ':' +
                  _dateTime.minute.toString().padLeft(2, '0') +
                  ':' +
                  _dateTime.second.toString().padLeft(2, '0'),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// SAMPLE
  Widget hourMinute12H() {
    return new TimePickerSpinner(
      is24HourMode: false,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }

  Widget hourMinuteSecond() {
    return new TimePickerSpinner(
      isShowSeconds: true,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }

  Widget hourMinute15Interval() {
    return new TimePickerSpinner(
      spacing: 40,
      minutesInterval: 1,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }

  Widget hourMinute12HCustomStyle() {
    return new TimePickerSpinner(
      is24HourMode: false,
      normalTextStyle: TextStyle(fontSize: 24, color: Colors.deepOrange),
      highlightedTextStyle: TextStyle(fontSize: 24, color: Colors.yellow),
      spacing: 50,
      itemHeight: 80,
      isForce2Digits: true,
      minutesInterval: 15,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }
}
