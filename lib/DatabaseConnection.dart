import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

import 'ContactModel.dart';

class databaseConnection {
  static Database? _db;

  //database creation following singletion pattern
  databaseConnection._privateConstructor();

  //instance of the class
  static final databaseConnection instance = databaseConnection
      ._privateConstructor();

  //variables are used for consistant naming
  static const String DB_Name = 'ContactsBuddy'; //Database name
  static const String Table_Contacts = 'Contacts'; //Table name
  static const int Version = 1;

  //column names
  static const String Contact_ID = 'Contact_ID';
  static const String Contact_Fname = 'First_Name';
  static const String Contact_Lname = 'Last_Name';
  static const String Contact_Email = 'Email';
  static const String Contact_MobileNum = 'Mobile_Num';
  static const String Contact_Notes = 'Notes';
  static const String Contact_NickName = 'Nick_Name';
  static const String Contact_Image = 'Contact_Image';

  //getter for the database instance
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  //initialize the database
  initDb() async {
    final databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DB_Name);
    var db = await openDatabase(
        path, version: Version, onCreate: _onCreate);
    return db;
  }

  //create the table
  _onCreate(Database db, int intVersion) async {
    await db.execute('''
      CREATE TABLE $Table_Contacts (
        $Contact_ID INTEGER PRIMARY KEY,
        $Contact_Fname TEXT,
        $Contact_Lname TEXT,
        $Contact_MobileNum INTEGER,
        $Contact_Email TEXT,
        $Contact_Notes TEXT,
        $Contact_NickName TEXT,
        $Contact_Image BLOB
      )
    ''');
  }

  //save contact into database
  Future<int> saveContact(ContactModel contact) async {
    var dbClient = await db;
    var res = await dbClient.insert(Table_Contacts, contact.toMap());
    print(res);
    return res;
  }

  //get a contact by id
  Future<Map<String, dynamic>> queryById(int id) async {
    final dbClient = await db;
    final res = await dbClient.query(Table_Contacts,
        where: '$Contact_ID = ?', whereArgs: [id]);
    if (res.isNotEmpty) {
      return res.first;
    } else {
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    var dbClient = await db;
    var res = await dbClient.query(Table_Contacts);
    return res;
  }

  //delete a contact by id
  Future<void> deleteContact(int userID) async {
    final dbClient = await db;
    final res = await dbClient.delete(
      Table_Contacts,
      where: '$Contact_ID = ?',
      whereArgs: [userID],
    );
  }


  //update contact by id
  Future<int> updateContactInDB(ContactModel updatedContact, int updateID) async {
    final dbClient = await db;
    final res = await dbClient.update(
      Table_Contacts,
      updatedContact.toMap(),
      where: '$Contact_ID = ?',
      whereArgs: [updateID],
    );
    print(res);
    return res;
  }
}