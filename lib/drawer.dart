import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proje2/bildirim.dart';
import 'package:proje2/pages/anasayfa.dart';
import 'package:proje2/pages/basvurular.dart';
import 'package:proje2/pages/login_or_register.dart';
import 'package:proje2/pages/profil.dart';
import 'package:proje2/pages/sign_in.dart';

class drawer extends StatelessWidget {
  const drawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/tedteam.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(),
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.home_filled),
                SizedBox(width: 16),
                Text('Anasayfa'),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnaSayfa(),
                ),
              );
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.notifications),
                SizedBox(width: 16),
                Text('Bildirimler'),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Bildirim(),
                ),
              );
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 16),
                Text('Profilim'),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const profil(),
                ),
              );
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.shopping_cart),
                SizedBox(width: 16),
                Text('Tedariklerim'),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Basvurular(), //* Basvurular()
                ),
              );
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.exit_to_app),
                SizedBox(width: 16),
                Text('Çıkış Yap'),
              ],
            ),
            onTap: () {
              _signOut(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginOrRegisterPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      debugPrint("Çıkış Yapıldı"); // Drawer'ı kapat
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
    } catch (e) {
      print('Çıkış yaparken bir hata oluştu: $e');
    }
  }
}
