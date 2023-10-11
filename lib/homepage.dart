// ignore_for_file: prefer_const_constructors
// Mengabaikan aturan prefer_const_constructors karena beberapa constructor tidak menggunakan const.
// Import package yang diperlukan
import 'package:flutter/material.dart';
import 'package:hahahaha/colors.dart';

// Import file yang diperlukan
import 'mydrawal.dart';
import 'db_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

// Membuat instance dari DatabaseHelper untuk berinteraksi dengan database.
class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper.instance;

  // List yang akan digunakan untuk menyimpan data kategori dari database
  List<Map<String, dynamic>> allCategoryData = [];

  // Controller untuk input field kategori.
  final TextEditingController _categoryName = TextEditingController();

  // GlobalKey untuk form.
  final formGlobalKey = GlobalKey<FormState>();
  @override
  void initState() {
    _query();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Memanggil method _query() saat widget diinisialisasi.
    return SafeArea(
        child: Scaffold(
      // Drawer untuk menu navigasi.
      drawer: MyDrawal(),
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        centerTitle: true,
        title: Text("create and store category"),
      ),
      body: Form(
        key: formGlobalKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      // Input field untuk menambah kategori.
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Menampilkan detail kategori dan ikon untuk mengedit dan menghapus.

                        SizedBox(
                          width: 250,
                          child: TextFormField(
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.greenAccent, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: MyColors.primaryColor, width: 1.0),
                              ),
                              hintText: 'Add Category',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                            ),
                            controller: _categoryName,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter category name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
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
                    const SizedBox(
                      height: 50,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: allCategoryData.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (_, index) {
                          var item = allCategoryData[index];
                          return Container(
                            color: MyColors.orangeTile,
                            padding: EdgeInsets.zero,
                            margin: EdgeInsets.zero,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text("${item['name']}"),
                                    Spacer(),
                                    IconButton(
                                      onPressed: null,
                                      icon: Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _delete(item['_id']);
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: MyColors.orangeDivider,
                                  thickness: 1,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

// Method untuk menyisipkan data kategori ke dalam database.
  void _insert() async {
    // Baris data yang akan disisipkan.
    // row to insert
    Map<String, dynamic> row = {DatabaseHelper.columnName: _categoryName.text};
    print('insert stRT');
// Memanggil method insert pada dbHelper.
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
    _categoryName.text = "";
    _query();
  }

// Method untuk mengambil data kategori dari database.
  void _query() async {
    // Memanggil method queryAllRows pada dbHelper.
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach(print);
    allCategoryData = allRows;
    setState(() {});
  }

// Method untuk menghapus data berdasarkan id dari database.
  void _delete(int id) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete(id);
    // Menghapus data menggunakan method delete pada dbHelper.
    print('deleted $rowsDeleted row(s): row $id');
    _query();
  }
}
