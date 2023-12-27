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
import '../addImage.dart';

class AddContactScreen extends StatefulWidget {
  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = new GlobalKey<FormState>();

  final _conUserFname = TextEditingController();
  final _conUserLname = TextEditingController();
  final _conMobileNum = TextEditingController();
  final _conEmail = TextEditingController();
  final _conNickname = TextEditingController();
  final _conNotes = TextEditingController();
  Uint8List? _selectedImageBytes;

  //method to get and pass the user input
  Future<void> addContact() async {
    ContactModel newContact = ContactModel(
      firstName: _conUserFname.text.isNotEmpty ? _conUserFname.text : null,
      lastName: _conUserLname.text.isNotEmpty ? _conUserLname.text : null,
      phoneNumber:
          _conMobileNum.text.isNotEmpty ? int.parse(_conMobileNum.text) : null,
      email: _conEmail.text.isNotEmpty ? _conEmail.text : null,
      notes: _conNotes.text.isNotEmpty ? _conNotes.text : null,
      nickname: _conNickname.text.isNotEmpty ? _conNickname.text : null,
      photo: _selectedImageBytes,
    );

    await databaseConnection.instance.saveContact(newContact);
    showToast('Successfully Added', context);
  }

  //method to pick a image
  Future<void> _pickImage() async {
    final pickedImageBytes = await pickImage(context);
    if (pickedImageBytes != null) {
      setState(() {
        Uint8List? Image = pickedImageBytes;
        _selectedImageBytes = resizeImageForCircleAvatar(Image!);
      });
    }
  }

  //method to compress the image
  Uint8List resizeImageForCircleAvatar(Uint8List originalImage,
      {int targetSize = 100}) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "New Contact",
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
                        child: _selectedImageBytes != null
                            ? CircleAvatar(
                                backgroundImage:
                                    MemoryImage(_selectedImageBytes!),
                                radius: 50,
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
              await addContact();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeScreen(),
                ),
              );
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
            "ADD",
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
