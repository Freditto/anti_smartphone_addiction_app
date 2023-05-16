import 'package:ant_smartphone_addiction_app/select_app.dart';
import 'package:flutter/material.dart';

class TimeSlotScreen extends StatefulWidget {
  @override
  State<TimeSlotScreen> createState() => _TimeSlotScreenState();
}

class _TimeSlotScreenState extends State<TimeSlotScreen> {
  

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text('My Blocked Apps', style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () async {
              
              // do something

              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SelectAppScreen()));


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
            },
          )
        ],
      ),

      body: Container(),
    );
  }

  
}
