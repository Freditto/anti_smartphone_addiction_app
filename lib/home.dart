import 'dart:ui';

import 'package:ant_smartphone_addiction_app/select_contact.dart';
import 'package:ant_smartphone_addiction_app/time_slot.dart';
import 'package:ant_smartphone_addiction_app/white_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool on = false;

  bool _darkMode = false;

  TextEditingController selectDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  List<AppInfo>? app_list_data;

  @override
  void initState() {
    selectDateController.text = ""; //set the initial value of text field
    endDateController.text = ""; //set the initial value of text field

    fetchSocialMediaOnlysData();
    super.initState();
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.limited;
    } else {
      return permission;
    }
  }

  _automaticNotification() {
    // TODO set  automa tic notofication in every d ay
  }

  _add_CalendarEvent_Dialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Add Silent Event'),
            content: Column(
              children: [
                TextField(
                  // controller: startDateController,
                  style: Theme.of(context).textTheme.bodyMedium,

                  decoration: InputDecoration(
                    // prefixIcon: const Icon(
                    //   Icons.home,
                    //   color: Colors.grey,
                    // ),
                    hintText: 'Select Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),

                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      print(
                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(
                          formattedDate); //formatted date output using intl package =>  2021-03-16
                      //you can implement different kind of Date Format here according to your requirement

                      setState(() {
                        selectDateController.text =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                ),

                const SizedBox(
                  height: 16,
                ),

                TextFormField(
                  minLines: 5,
                  maxLines: 7,
                  decoration: InputDecoration(
                    // prefixIcon: const Icon(
                    //   Icons.home,
                    //   color: Colors.grey,
                    // ),
                    hintText: 'Additional Infomation',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),

                  // controller: controllerAddress,
                ),

                const SizedBox(
                  height: 16,
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

                MaterialButton(
                  elevation: 0,
                  color: Color(0xFF44B6AF),
                  height: 50,
                  minWidth: 500,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onPressed: () {
                    // _add_project_API();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Save',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ],
            ),
          );
        });
  }

  _clearSetting_Dialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Clear Settings'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text(
                    "Are you sure you want to clear all Settings",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            // _deleteSingleProductTocart(index);
                            // logOUT_User();
                            Navigator.of(context).pop();

                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => LoginScreen()));
                          },
                          child: Text('Yes')),

                      SizedBox(
                        width: 30,
                      ),

                      InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('No')),
                      // onPressed: () {
                      //   Navigator.of(context).pop();
                      // }
                    ])
              ],
            ),
          );
        });
  }

  final List<String> _app_packageNames = [
    'com.instagram.android', // instagram

    // 'com.facebook.orca' // facebook
    'com.facebook.katana' // facebook
        // 'com.example.facebook' // facebook
        // 'com.facebook.android' // facebook

        'com.twitter.android', // twitter
    'com.zhiliaoapp.musically', // ticktok
    'com.whatsapp', // whatsapp
  ];

  fetchSocialMediaOnlysData() async {
    List<AppInfo> _app_list_items = [];

    for (AppInfo info in await InstalledApps.getInstalledApps(true, true)) {
      if (_app_packageNames.contains(info.packageName)) {
        _app_list_items.add(info);
      }
    }

    setState(() {
      app_list_data = _app_list_items;
      // next = body['next'];
    });

    return [];
  }

  final TextEditingController textEditingController = TextEditingController();

  showChangeSMSDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change SMS Content'),
          content: TextField(
            controller: textEditingController,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                String enteredText = textEditingController.text;
                // Perform actions with enteredText
                textEditingController.clear();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Ant Addiction',
          // style: TextStyle(color: Colors.black),
        ),
        leading: Builder(
            builder: (context) => // Ensure Scaffold is in context
                IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer())),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              // Perform action for icon1
            },
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: () {
              // Perform action for icon2
              showChangeSMSDialog();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                  // color: Colors.blue,
                  ),
              child: Text(''),
            ),
            // ListTile(
            //   leading: Icon(
            //     Icons.home,
            //   ),
            //   title: const Text('Page 1'),
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            // ),
            ListTile(
              leading: Icon(
                Icons.person_outline,
              ),
              title: const Text('Contacts'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WhiteBoardScreen()));
              },
            ),

            ListTile(
              leading: Icon(
                Icons.av_timer,
              ),
              title: const Text('Time Slot'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TimeSlotScreen()));
              },
            ),

            ListTile(
              leading: Icon(
                Icons.assessment_outlined,
              ),
              title: const Text('App Usage'),
              onTap: () async {
                Navigator.pop(context);
                final PermissionStatus permissionStatus =
                    await _getPermission();
                if (permissionStatus == PermissionStatus.granted) {
                  //We can now access our contacts here

                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => ContactScreen()));
                } else {
                  //If permissions have been denied show standard cupertino alert dialog
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                            title: Text('Permissions error'),
                            content: Text('Please enable contacts access '
                                'permission in system settings'),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: Text('OK'),
                                onPressed: () => Navigator.of(context).pop(),
                              )
                            ],
                          ));
                }
              },
            ),

            ListTile(
              leading: Icon(
                Icons.settings_outlined,
              ),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: Icon(
                Icons.share_outlined,
              ),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: Icon(
                Icons.help,
              ),
              title: const Text('`Dark Mode'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: Icon(
                Icons.rate_review_outlined,
              ),
              title: const Text('Feedback'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Text(
                'Quick Action',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const Row(
              // Number of columns in the grid
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.web,
                          size: 50,
                        ), // Replace 'icon_name_3' with the desired icon
                        SizedBox(height: 8),
                        Text(
                          'Block Site',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.app_blocking,
                          size: 50,
                        ), // Replace 'icon_name_3' with the desired icon
                        SizedBox(height: 8),
                        Text(
                          'Block App',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.av_timer,
                          size: 50,
                        ), // Replace 'icon_name_3' with the desired icon
                        SizedBox(height: 8),
                        Text(
                          'Screen Time',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Text(
                'My Profile',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: social_mediaComponent()),
          ],
        ),
      ),
    );
  }

  social_mediaComponent() {
    if (app_list_data == null) {
      return Container(
        child: Center(child: Text('Loading...')),
        // color: Colors.black,
        // size: 50.0,
      );
    } else if (app_list_data != null && app_list_data?.length == 0) {
      // No Data
      return Column(children: [
        Image.asset("assets/images/no_data.gif"),
        // Text(
        //   AppLocalizations.of(context)!.no_shipped,
        //   style: TextStyle(fontSize: 18),
        // )
      ]);
    } else {
      // return ListView.builder(
      //   itemCount: app_list_data!.length,
      //   itemBuilder: (context, index) {
      //     AppInfo app = app_list_data![index];
      //     return Card(
      //       child: SwitchListTile(
      //         value: _darkMode,
      //         title: Text(app.name!),
      //         subtitle: Text(app.getVersionInfo()),
      //         secondary: Padding(
      //           padding: const EdgeInsets.all(9.0),
      //           child: CircleAvatar(
      //             backgroundColor: Colors.transparent,
      //             child: Image.memory(app.icon!),
      //           ),
      //         ),
      //         onChanged: (newValue) {
      //           setState(() {
      //             _darkMode = newValue;
      //           });
      //         },
      //         // visualDensity: VisualDensity.adaptivePlatformDensity,
      //         // switchType: SwitchType.material,
      //         activeColor: Colors.indigo,
      //       ),

      //       // child: ListTile(
      //       // leading: CircleAvatar(
      //       //   backgroundColor: Colors.transparent,
      //       //   child: Image.memory(app.icon!),
      //       // ),
      //       //   title: Text(app.name!),
      //       //   subtitle: Text(app.getVersionInfo()),
      //       //   // onTap: () =>
      //       //   //     InstalledApps.startApp(app.packageName!),
      //       //   onLongPress: () =>
      //       //       InstalledApps.openSettings(
      //       //           app.packageName!),
      //       // ),
      //     );
      //   },
      // );

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          childAspectRatio: 1.5, // Adjust the aspect ratio as needed
        ),
        itemCount: app_list_data!.length,
        itemBuilder: (context, index) {
          AppInfo app = app_list_data![index];
          return InkWell(
            onTap: () {
              print(index);
            },
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image.memory(app.icon!),
                    ),
                  ),
                  Text(app.name!),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
