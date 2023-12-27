import 'dart:typed_data';

import 'package:contactsbuddy/ViewContact/ViewContactScreen.dart';
import 'package:flutter/material.dart';
import 'package:contactsbuddy/DatabaseConnection.dart';
import '../ContactModel.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<ContactModel> contacts = [];

  List<String> nameList = [];

  List<ContactModel> filteredContacts = [];
  bool showFilteredResults = false;

  @override
  void initState() {
    super.initState();
    loadContacts();
    filteredContacts = List.from(contacts);
    print(Colors.green[200]);
  }

  //method to filter and store the data when user perform search
  void updateFilteredContacts(String query) {
    setState(() {
      filteredContacts = contacts
          .where((contact) {
        final fullName = '${contact.firstName ?? ''} ${contact.lastName ?? ''}'.toLowerCase();
        return fullName.contains(query.toLowerCase());
      })
          .toList();
      showFilteredResults = true;
      if (query.isEmpty) {
        setState(() {
          showFilteredResults = false;
        });
      }
    });
  }

  //method to load all the contacts
  Future<void> loadContacts() async {
    List<Map<String, dynamic>> queryResult =
        await databaseConnection.instance.queryAll();
    setState(() {
      contacts = queryResult.map((map) {
        nameList.add('${map['First_Name']} ${map['Last_Name']}');
        final contact = ContactModel.fromMap(map);
        return contact;
      }).toList();
      contacts.sort((a, b) {
        final firstNameA = a.firstName ?? '';
        final firstNameB = b.firstName ?? '';
        return firstNameA.compareTo(firstNameB);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      updateFilteredContacts(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(8),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xffeeeeee),
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!showFilteredResults)
                  Text(
                    'All Contacts',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (showFilteredResults)
                  Text('Found ${filteredContacts.length} Contacts',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      )),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder( //to display the contacts
              itemCount: showFilteredResults
                  ? filteredContacts.length
                  : contacts.length,
              itemBuilder: (context, index) {
                //show the filtered contacts if user perform search
                final name = showFilteredResults
                    ? ('${filteredContacts[index].firstName} ${filteredContacts[index].lastName ?? ''}')
                    : ('${contacts[index].firstName} ${contacts[index].lastName ?? ''}');
                final photo = showFilteredResults
                    ? filteredContacts[index].photo
                    : contacts[index].photo;

                //alphabetic order
                if (index == 0 ||
                    contacts[index].firstName![0] !=
                        contacts[index - 1].firstName![0]) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Text(
                          contacts[index].firstName![0],
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      buildContactItem(name, photo, index),
                    ],
                  );
                } else {
                  return buildContactItem(name, photo, index);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  //Contacts ListTime widget
  Widget buildContactItem(String name, Uint8List? photo, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ViewContactScreen(contactID: contacts[index].contactID),
          ),
        );
      },
      child: Container(
        height: 60,
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text(name),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xffa5d6a7),
                      width: 0.5,
                    ),
                  ),
                ),
              )
            ],
          ),
          leading: photo != null
              ? CircleAvatar(
                  backgroundImage: MemoryImage(photo),
                )
              : CircleAvatar(
                  child: Icon(Icons.account_circle),
                ),
        ),
      ),
    );
  }
}
