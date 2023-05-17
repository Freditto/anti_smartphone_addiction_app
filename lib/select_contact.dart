// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectContactScreen extends StatefulWidget {
  String type;

  SelectContactScreen(
    this.type, {super.key}
  );

  @override
  State<SelectContactScreen> createState() => _SelectContactScreenState();
}

class _SelectContactScreenState extends State<SelectContactScreen> {
  Iterable<Contact>? _contacts;
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
      List myList = json.decode(data);
      for (var i in myList) {
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
    List<MyContact> myContacts = [];
    print(contacts.toList()[4].identifier);
    print(contacts.toList()[5].identifier);

    for (Contact contact in contacts) {
      bool isChecked = widget.type == MyContact.WHITE_LIST
          ? await MyContact.isWhiteList(contact.identifier!)
          : await MyContact.isBlackList(contact.identifier!);
          
      myContacts.add(MyContact(isChecked, contact));
    }

    setState(() {
      _contacts = contacts;
      myContacts = myContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (const Text('Select Contacts')),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _contacts != null
          //Build a list view of all contacts, displaying their avatar and
          // display name
          ? ListView.builder(
              itemCount: my_contacts?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                MyContact? contact = my_contacts?.elementAt(index);
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                  leading: (contact?.contact.avatar != null &&
                          contact!.contact.avatar!.isNotEmpty)
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(contact.contact.avatar!),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(contact!.contact.initials()),
                        ),
                  title: Text(contact.contact.displayName ?? ''),
                  //This can be further expanded to showing contacts detail
                  // onPressed().
                  trailing: Checkbox(
                    activeColor: Colors.green,
                    value: contact.is_checked,
                    onChanged: (value) {
                      if (!contact.is_checked) {
                        widget.type == MyContact.BLACK_LIST
                            ? MyContact.addToBlackList(
                                contact.contact.identifier!)
                            : MyContact.addToWhiteList(
                                contact.contact.identifier!);
                      } else {
                        widget.type == MyContact.BLACK_LIST
                            ? MyContact.removeFromBlackList(
                                contact.contact.identifier!)
                            : MyContact.removeFromWhiteList(
                                contact.contact.identifier!);
                      }
                      // else MyContact.add
                      setState(() {
                        contact.is_checked = !contact.is_checked;
                      });
                    },
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class MyContact {
  bool is_checked = false;
  Contact contact;
  MyContact(this.is_checked, this.contact);

  static const WHITE_LIST = 'white_list';
  static const BLACK_LIST = 'black_list';

  static Future<bool> isWhiteList(String identifier) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var data = localStorage.getString(WHITE_LIST);
    if (data != null) {
      List myList = json.decode(data);
      return myList.contains(identifier);
    }
    return false;
  }

  static Future<bool> isBlackList(String identifier) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var data = localStorage.getString(BLACK_LIST);
    if (data != null) {
      List myList = json.decode(data);
      return myList.contains(identifier);
    }
    return false;
  }

  static Future<bool> addToWhiteList(String identifier) async {
    SharedPreferences localstorage = await SharedPreferences.getInstance();
    var data = localstorage.getString(WHITE_LIST);
    List myList = data != null ? json.decode(data) : [];
    myList.add(identifier);
    MyContact.save(myList, WHITE_LIST);
    return true;
  }

  static Future<bool> addToBlackList(String identifier) async {
    SharedPreferences localstorage = await SharedPreferences.getInstance();
    var data = localstorage.getString(BLACK_LIST);
    List myList = data != null ? json.decode(data) : [];
    myList.add(identifier);
    MyContact.save(myList, BLACK_LIST);
    return true;
  }

  static Future<bool> removeFromBlackList(String identifier) async {
    SharedPreferences localstorage = await SharedPreferences.getInstance();
    var data = localstorage.getString(BLACK_LIST);
    if (data != null) {
      List myList = json.decode(data);
      myList.remove(identifier);
      MyContact.save(myList, BLACK_LIST);
      return true;
    }
    return false;
  }

  static Future<bool> removeFromWhiteList(String identifier) async {
    SharedPreferences localstorage = await SharedPreferences.getInstance();
    var data = localstorage.getString(WHITE_LIST);
    if (data != null) {
      List myList = json.decode(data);
      myList.remove(identifier);
      MyContact.save(myList, WHITE_LIST);
      return true;
    }
    return false;
  }

  static Future<bool> save(List list, String saveAs) async {
    SharedPreferences localstorage = await SharedPreferences.getInstance();
    print('Saving');
    print(list);
    localstorage.setString(saveAs, json.encode(list));
    return true;
  }
}
