// ignore_for_file: prefer_const_constructors

// Mengabaikan aturan prefer_const_constructors, karena dalam proyek ini beberapa constructor tidak menggunakan const.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hahahaha/contact_list.dart';
import 'package:hahahaha/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

import 'db_manager.dart';
import 'mydrawal.dart';
// Mengimport dependensi yang diperlukan oleh flutter atau dart project

//membuat class add contact
class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  _AddContactState createState() => _AddContactState();
}

//membuat add contact state dengan isian nama depan,nama akhiran,nomor telpon,email
class _AddContactState extends State<AddContact> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _mobileNumber = TextEditingController();
  final TextEditingController _emailAddress = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  File? imageFile;
  final ImagePicker _picker = ImagePicker();
  String currentCategory = "";
  var imageEncoded;
  List<String> allCategoryData = [];
  final dbHelper = DatabaseHelper.instance;
  late Future<Uint8List> imageBytes;
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.red,
    exportBackgroundColor: Colors.blue,
  );

// INITIALIZE. RESULT IS A WIDGET, SO IT CAN BE DIRECTLY USED IN BUILD METHOD
// Memanggil method _query() saat widget diinisialisasi
  @override
  void initState() {
    super.initState();
    _query();
    // Inisialisasi objek Signature untuk menggambar tanda tangan
    var signatureCanvas = Signature(
      controller: _controller,
      width: 300,
      height: 300,
      backgroundColor: Colors.lightBlueAccent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawal(), // Menggunakan custom drawer MyDrawal
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          centerTitle: true,
          title: Text("Add Contact"),
        ),
        body: ListView(
          children: [
            SizedBox(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: formGlobalKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          // Memanggil image picker untuk memilih gambar dari galeri
                          final XFile? pickedFile = await _picker.pickImage(
                              source: ImageSource.gallery);

                          if (pickedFile != null) {
                            // Mengambil data gambar sebagai bytes dan mengubahnya menjadi File
                            imageBytes = pickedFile.readAsBytes();
                            setState(() {
                              imageFile = File(pickedFile.path);
                            });
                          }
                        },
                        child: imageFile == null
                            ? CircleAvatar(
                                backgroundColor: MyColors.primaryColor,
                                minRadius: 50,
                                child: Icon(
                                  Icons.image,
                                  color: Colors.white,
                                ),
                              )
                            : CircleAvatar(
                                backgroundImage: Image.file(
                                  imageFile!,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ).image,
                                minRadius: 100,
                              ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.primaryColor, width: 1.0),
                          ),
                          hintText: 'First Name',
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                        controller: _firstName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter First Name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.primaryColor, width: 1.0),
                          ),
                          hintText: 'Last Name',
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                        controller: _lastName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Last First Name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.primaryColor, width: 1.0),
                          ),
                          hintText: 'Mobile Number',
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                        controller: _mobileNumber,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Mobile Number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyColors.primaryColor, width: 1.0),
                          ),
                          hintText: 'Email Address',
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                        controller: _emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Email Address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Text form fields for user input
                      Container(
                        // Dropdown button for selecting category
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: MyColors.primaryColor),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            items: allCategoryData.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (selectedItem) => setState(() {
                              currentCategory = selectedItem!;
                            }),
                            hint: Text("Select Category "),
                            value: currentCategory.isEmpty
                                ? null
                                : currentCategory,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButtonTheme(
                        data: TextButtonThemeData(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                MyColors.primaryColor),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            // Menyimpan data ketika tombol Save ditekan
                            if (formGlobalKey.currentState!.validate()) {
                              _insert();
                            }
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method untuk menyisipkan data kontak ke dalam database
  void _insert() async {
    String base64image;
    if (imageFile?.exists() != null) {
      base64image = base64Encode(imageFile!.readAsBytesSync().toList());
    }

    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: _firstName.text,
      DatabaseHelper.columnLName: _lastName.text,
      DatabaseHelper.columnMobile: _mobileNumber.text,
      DatabaseHelper.columnEmail: _emailAddress.text,
      DatabaseHelper.columnCategory: currentCategory,
    };
    print('insert stRT');
    currentCategory = "";

    final id = await dbHelper.insertContact(row);
    if (kDebugMode) {
      print('inserted row id: $id');
    }
    _query();
    Navigator.push(context, MaterialPageRoute(builder: (_) => ContactList()));
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    if (kDebugMode) {
      print('query all rows:');
    }
    for (var element in allRows) {
      allCategoryData.add(element["name"]);
    }
    setState(() {});
  }
}
