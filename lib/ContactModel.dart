  import 'dart:typed_data';

class ContactModel {
  int? contactID;
  String? firstName;
  String? lastName;
  int? phoneNumber;
  String? email;
  String? notes;
  String? nickname;
  Uint8List? photo;

  ContactModel({
    this.contactID,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.notes,
    this.nickname,
    this.photo,
  });

    Map<String, dynamic> toMap() {
      var map = <String, dynamic>{
        'Contact_ID' : contactID,
        'First_Name': firstName,
        'Last_Name': lastName,
        'Email': email,
        'Mobile_Num': phoneNumber,
        'Notes': notes,
        'Nick_Name': nickname,
        'Contact_Image': photo
      };
      return map;
    }

  ContactModel.fromMap(Map<String, dynamic> map) {
      contactID = map['Contact_ID'];
    firstName = map['First_Name'];
    lastName = map['Last_Name'];
    phoneNumber = map['Mobile_Num'];
    email = map['Email'];
    notes = map['Notes'];
    nickname = map['Nick_Name'];
    photo = map['Contact_Image'];
  }
  }