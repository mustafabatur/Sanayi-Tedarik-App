import 'package:flutter/material.dart';
import 'package:proje2/components/my_button.dart';
import 'package:proje2/pages/sign_in.dart';
import 'package:proje2/pages/sign_up.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 34, 34), // Arka plan rengi
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100), // Üst boşluk
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo kısmı
                  Container(
                    padding: const EdgeInsets.only(bottom: 50),
                    margin: const EdgeInsets.all(40),
                    height: 200,
                    child: Image.asset(
                      "assets/logo_for_project4.png", // Logo görseli
                    ),
                  ),

                  // Giriş yap butonu
                  MyButton(
                    customColor: Colors.white.withOpacity(0.7),
                    text: "Giriş Yap",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20), // Butonlar arasındaki boşluk

                  // Hesap oluştur butonu
                  MyButton(
                    customColor: Colors.lightGreen,
                    text: "Hesap Oluştur",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUp(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const Spacer(), // Sayfanın alt kısmını esnek hale getirir

              // Footer kısmı
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Kullanıcı "Terms of use" metnine tıkladığında yapılacak işlemi buraya ekleyin.
                        print("Terms of use clicked");
                      },
                      child: const Text(
                        "Terms of use",
                        style: TextStyle(
                          color: Colors.white,
                          decoration:
                              TextDecoration.underline, // Altı çizili stil
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        // Kullanıcı "Privacy Policy" metnine tıkladığında yapılacak işlemi buraya ekleyin.
                        print("Privacy Policy clicked");
                      },
                      child: const Text(
                        "Privacy Policy",
                        style: TextStyle(
                          color: Colors.white,
                          decoration:
                              TextDecoration.underline, // Altı çizili stil
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
