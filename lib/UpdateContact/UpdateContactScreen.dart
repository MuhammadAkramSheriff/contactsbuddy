import 'dart:typed_data';

import 'package:contactsbuddy/DatabaseConnection.dart';
import 'package:contactsbuddy/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../Common/TextFormField.dart';
import '../Common/ToastMessage.dart';
import '../ContactModel.dart';
import '../DropdownLists/EmailCategory.dart';
import '../DropdownLists/NumberCategory.dart';
import '../ViewContact/ViewContactScreen.dart';
import '../addImage.dart';

class UpdateContactScreen extends StatefulWidget {

  int? contactID;

  UpdateContactScreen({required this.contactID});

  @override
  State<UpdateContactScreen> createState() => _UpdateContactScreenState();
}

class _UpdateContactScreenState extends State<UpdateContactScreen> {
  Map<String, dynamic> contactDetails = {};

  final _formKey = new GlobalKey<FormState>();

  final _conUserFname = TextEditingController();
  final _conUserLname = TextEditingController();
  final _conMobileNum = TextEditingController();
  final _conEmail = TextEditingController();
  final _conNickname = TextEditingController();
  final _conNotes = TextEditingController();
  Uint8List? _contactImage;

  Future<void> getContactDetails(int id) async {
    try {
      Map<String, dynamic> data = await databaseConnection.instance.queryById(id);
      if (data.isNotEmpty) {
        setState(() {
          contactDetails = data;

          _conUserFname.text = contactDetails['First_Name'];
          _conUserLname.text = contactDetails['Last_Name'];
          _conMobileNum.text = contactDetails['Mobile_Num'].toString();
          _conEmail.text = contactDetails['Email'];
          _conNickname.text = contactDetails['Nick_Name'];
          _conNotes.text = contactDetails['Notes'];
          _contactImage = contactDetails['Contact_Image'];
        });
      } else {
        print('No data found for ID $id');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateContact(int? contactID) async {
    ContactModel updateContact = ContactModel(
      contactID: contactID,
      firstName: _conUserFname.text.isNotEmpty ? _conUserFname.text : null,
      lastName: _conUserLname.text.isNotEmpty ? _conUserLname.text : null,
      phoneNumber: _conMobileNum.text.isNotEmpty ? int.parse(_conMobileNum.text) : null,
      email: _conEmail.text.isNotEmpty ? _conEmail.text : null,
      notes: _conNotes.text.isNotEmpty ? _conNotes.text : null,
      nickname: _conNickname.text.isNotEmpty ? _conNickname.text : null,
      photo: _contactImage,
    );

    await databaseConnection.instance.updateContactInDB(updateContact, contactID!);
    showToast('Successfully Updated', context);
  }

  Future<void> _pickImage() async {
    final pickedImageBytes = await pickImage(context);
    if (pickedImageBytes != null) {
      setState(() {
        Uint8List? Image= pickedImageBytes;
        _contactImage = resizeImageForCircleAvatar(Image!);
      });
    }
  }

  Uint8List resizeImageForCircleAvatar(Uint8List originalImage, {int targetSize = 100}) {
    //decode the original image
    img.Image? image = img.decodeImage(originalImage);
    //resize the image to the target size
    image = img.copyResize(image!, width: targetSize, height: targetSize);
    //encode the optimized image
    Uint8List resizedImage = img.encodePng(image);

    return resizedImage;
  }

  @override
  void initState() {
    super.initState();
    getContactDetails(widget.contactID!);
    print(widget.contactID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Contact",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: _contactImage != null
                            ? Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.green,  // Set the border color
                              width: 3.0,           // Set the border width
                            ),
                          ),
                              child: CircleAvatar(
                                                        backgroundImage: MemoryImage(_contactImage!),
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
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200],
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 22,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: getTextFormField(
                        controller: _conUserFname,
                        inputType: TextInputType.name,
                        hintName: 'First Name',
                        enableValidation: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    SizedBox(width: 36),
                    Expanded(
                      child: getTextFormField(
                        controller: _conUserLname,
                        inputType: TextInputType.name,
                        hintName: 'Last Name',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      size: 22,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 16),
                    NumberCategoryDropDown(),
                    SizedBox(width: 10),
                    Expanded(
                      child: getTextFormField(
                        controller: _conMobileNum,
                        inputType: TextInputType.phone,
                        hintName: 'Phone Number',
                        enableValidation: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 22,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 16),
                    EmailCategoryDropDown(),
                    SizedBox(width: 10),
                    Expanded(
                      child: getTextFormField(
                        controller: _conEmail,
                        inputType: TextInputType.name,
                        hintName: 'Email',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 22,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: getTextFormField(
                        controller: _conNotes,
                        inputType: TextInputType.name,
                        hintName: 'Notes',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 22,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: getTextFormField(
                        controller: _conNickname,
                        inputType: TextInputType.name,
                        hintName: 'Nickname',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextButton(
          onPressed: () async {
            //store the final values in the textformfield to the provider
            if (_formKey.currentState!.validate()) {
              _formKey.currentState?.save();
              await updateContact(widget.contactID);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewContactScreen(contactID: widget.contactID)));
            }

          },

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: Size(MediaQuery.of(context).size.width, 50),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          child: Text(
            "UPDATE",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}