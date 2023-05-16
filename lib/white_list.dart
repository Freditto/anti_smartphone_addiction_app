import 'package:ant_smartphone_addiction_app/select_contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WhiteBoardScreen extends StatefulWidget {
  @override
  State<WhiteBoardScreen> createState() => _WhiteBoardScreenState();
}

class _WhiteBoardScreenState extends State<WhiteBoardScreen> {
  Iterable<MyContact>? my_contacts;

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  Future<bool> isSelected(String identifier) async {
    SharedPreferences localstorage = await SharedPreferences.getInstance();
    var data = localstorage.getString('white_list');
    if (data != null) {
      List my_list = json.decode(data);
      for (var i in my_list) {
        if (i == identifier) return true;
      }
      return false;
    }
    return false;
  }

  Future<void> getContacts() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it

    final Iterable<Contact> contacts = await ContactsService.getContacts();
    List<MyContact> _my_contacts = [];
    print(contacts.toList()[4].identifier);
    print(contacts.toList()[5].identifier);

    for (Contact contact in contacts) {
      bool _is_checked = await MyContact.isWhiteList(contact.identifier!);
      if(_is_checked) {
        _my_contacts.add(MyContact(_is_checked, contact));
      }

    }

    setState(() {
      my_contacts = _my_contacts;
    });
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.limited;
    } else {
      return permission;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    

      body: my_contacts != null
          //Build a list view of all contacts, displaying their avatar and
          // display name
          ? ListView.builder(
              itemCount: my_contacts?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Contact? contact = my_contacts?.elementAt(index).contact;
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                  leading:
                      (contact?.avatar != null && contact!.avatar!.isNotEmpty)
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(contact.avatar!),
                            )
                          : CircleAvatar(
                              child: Text(contact!.initials()),
                              backgroundColor: Colors.blue,
                            ),
                  title: Text(contact.displayName ?? ''),
                  //This can be further expanded to showing contacts detail
                  // onPressed().
                );
              },
            )
          : Center(child: const CircularProgressIndicator()),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SelectContactScreen(MyContact.WHITE_LIST)));
        },
        label: const Text('Add'),
        icon: const Icon(Icons.add),
        backgroundColor: Color(0xFF44B6AF),
      ),
    );
  }
}
