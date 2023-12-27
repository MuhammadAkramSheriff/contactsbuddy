import 'dart:typed_data';

import 'package:contactsbuddy/UpdateContact/UpdateContactScreen.dart';
import 'package:flutter/material.dart';
import 'package:contactsbuddy/DatabaseConnection.dart';

import '../ContactModel.dart';
import '../HomeScreen.dart';
import '../SearchContacts/SearchContact.dart';

class ViewContactScreen extends StatefulWidget {
  int? contactID;

  ViewContactScreen({required this.contactID});

  @override
  State<ViewContactScreen> createState() => _ViewContactScreenState();
}

class _ViewContactScreenState extends State<ViewContactScreen> {
  Map<String, dynamic> contactDetails = {};

  @override
  void initState() {
    super.initState();
    fetchDataById(widget.contactID!);
  }

  //method to get contact details with contact id
  Future<void> fetchDataById(int id) async {
    try {
      Map<String, dynamic> data =
          await databaseConnection.instance.queryById(id);
      if (data.isNotEmpty) {
        setState(() {
          contactDetails = data;
        });
      } else {
        print('No data found for ID $id');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: Column(children: [
          Container(
            color: Colors.green[400],
            height: 300,
            child: Stack(
              children: [
                Positioned(
                  top: 35,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.2),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      },
                    ),
                  ),
                ),
                Center(
                  child: Column(children: [
                    SizedBox(height: 100),
                    contactDetails['Contact_Image'] != null
                        ? Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white, // Set the border color
                                width: 2.0, // Set the border width
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage:
                                  MemoryImage(contactDetails['Contact_Image']!),
                              radius: 50,
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.grey[400],
                            radius: 50,
                            child: Icon(
                              Icons.account_circle,
                              size: 50,
                              color: Colors.grey[50],
                            ),
                          ),
                    SizedBox(height: 10),
                    Text(
                      '${contactDetails['First_Name']} ${contactDetails['Last_Name'] ?? ''}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(
              contactDetails['Mobile_Num'].toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mobile'),
                Divider(),
              ],
            ),
          ),
          Visibility(
            visible: contactDetails['Email'] != null,
            child: ListTile(
              title: Text(
                '${contactDetails['Email']}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email'),
                  Divider(),
                ],
              ),
            ),
          ),
          Visibility(
            visible: contactDetails['Nick_Name'] != null,
            child: ListTile(
              title: Text(
                '${contactDetails['Nick_Name']}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nickname'),
                  Divider(),
                ],
              ),
            ),
          ),
          Visibility(
            visible: contactDetails['Notes'] != null,
            child: ListTile(
              title: Text(
                '${contactDetails['Notes']}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Notes'),
                  Divider(),
                ],
              ),
            ),
          )
        ]),
      ),
      bottomNavigationBar: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white70,
                  width: 4.0,
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateContactScreen(
                                    contactID: widget.contactID)));
                      },
                    ),
                    PopupMenuButton<String>(
                      onSelected: (String result) {
                        if (result == 'delete') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirmation'),
                                content:
                                    Text('Do you want to delete the contact?'),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      await databaseConnection.instance
                                          .deleteContact(widget.contactID!);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen()));
                                    },
                                    child: Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('No'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete),
                            title: Text('Delete'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
