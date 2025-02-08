import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proje2/firebase_options.dart';
import 'package:proje2/pages/login_or_register.dart'; // Eğer login page'inden veri alıyorsanız burada kontrol gerekebilir

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlatıyoruz
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Eğer Firebase başlatılmada hata varsa burada loglama yapabiliriz
    print("Firebase Başlatma Hatası: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginOrRegisterPage(),
    );
  }
}
