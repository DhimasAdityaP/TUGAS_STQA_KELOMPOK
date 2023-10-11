import 'package:flutter/material.dart';
import 'package:hahahaha/homepage.dart';

// Fungsi main() merupakan titik awal eksekusi untuk aplikasi Flutter.
void main() {
  // Memanggil runApp() untuk menjalankan aplikasi dengan widget MyApp sebagai root.
  runApp(const MyApp());
}

// Kelas MyApp adalah stateless widget yang merupakan root dari aplikasi.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Metode build() digunakan untuk mendefinisikan tata letak dan UI aplikasi.
  @override
  Widget build(BuildContext context) {
    // MaterialApp adalah widget dasar yang menyediakan tema dan konfigurasi aplikasi.
    return MaterialApp(
      // Judul aplikasi yang akan muncul di task switcher atau app drawer.
      title: 'Flutter Demo',
      // Menghilangkan banner debug pada sudut kanan atas layar.
      debugShowCheckedModeBanner: false,
      // Tema aplikasi, diatur dengan primarySwatch untuk warna tema utama.
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // Widget yang akan dijalankan sebagai halaman pertama ketika aplikasi dimulai.
      home: const HomePage(),
    );
  }
}
