import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proje2/components/my_button.dart';
import 'package:proje2/components/my_text_field.dart';
import 'package:proje2/pages/anasayfa.dart';
import 'package:proje2/pages/sign_up.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController sifreController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  bool showPass = false;

  @override
  void initState() {
    super.initState();
    // Kullanıcı durumunu dinleme
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint('Kullanıcı oturumu kapalı');
      } else {
        debugPrint(
            'Kullanıcı oturumu açık: ${user.email}, Email doğrulama durumu: ${user.emailVerified}');
      }
    });
  }

  void togglePasswordVisibility() {
    setState(() {
      showPass = !showPass;
    });
  }

  bool checkTheBox = false;
  void toggleCheckBox() {
    setState(() {
      checkTheBox = !checkTheBox;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 1),
              Image.asset(
                "assets/logo_for_project2.jpg",
                width: 250,
              ),
              const SizedBox(height: 40),
              MyTextField(
                hintText: "E-mail",
                controller: emailController,
              ),
              const SizedBox(height: 20),
              MyTextField(
                hintText: "Şifre",
                controller: sifreController,
                onPressed: togglePasswordVisibility,
                icon: showPass ? Icons.visibility_off : Icons.visibility,
                obscureText: !showPass,
              ),
              const SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Theme(
                          data: ThemeData(
                            unselectedWidgetColor: Colors.grey[500],
                          ),
                          child: Checkbox(
                            checkColor: Colors.white,
                            value: checkTheBox,
                            onChanged: (value) => toggleCheckBox(),
                          ),
                        ),
                        const Text(
                          "Beni Hatırla",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    const Text(
                      "Şifremi Unuttum?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              MyButton(
                customColor: Colors.lightGreen,
                text: "Giriş Yap",
                onTap: () {
                  String email = emailController.text;
                  String sifre = sifreController.text;
                  loginUserEmailAndPassword(email, sifre);
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Henüz Bir Hesabınız Yok Mu?",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                    child: const Text(
                      "Kayıt Ol",
                      style: TextStyle(
                        color: Colors.lightGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Kullanıcı giriş fonksiyonu
  void loginUserEmailAndPassword(String email, String sifre) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: sifre);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kullanıcı Girişi Başarılı'),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AnaSayfa(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Giriş yapılamadı: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Google ile giriş fonksiyonu
  void googleIleGiris() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google ile giriş başarılı'),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AnaSayfa(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google ile giriş yapılamadı: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
