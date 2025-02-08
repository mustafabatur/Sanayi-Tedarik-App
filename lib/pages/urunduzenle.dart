import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proje2/models/urun_model.dart';
import 'package:proje2/pages/profilsayfasi.dart';

class BasvuruDetay extends StatefulWidget {
  final UrunModel urunmodel;

  const BasvuruDetay({Key? key, required this.urunmodel}) : super(key: key);

  @override
  State<BasvuruDetay> createState() => _BasvuruDetayState();
}

class _BasvuruDetayState extends State<BasvuruDetay> {
  List<Map<String, dynamic>> basvuranlar = [];
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _urunAdiController;
  late TextEditingController _urunFiyatController;

  @override
  void initState() {
    super.initState();
    _urunAdiController = TextEditingController(text: widget.urunmodel.adi);
    _urunFiyatController =
        TextEditingController(text: widget.urunmodel.fiyat.toString());
    _getBasvuranlar();
  }

  @override
  void dispose() {
    _urunAdiController.dispose();
    _urunFiyatController.dispose();
    super.dispose();
  }

  // Başvuranları Firestore'dan çek ve her birinin UID'sini al
  Future<void> _getBasvuranlar() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Basvurular')
        .where('urunID', isEqualTo: widget.urunmodel.urunID)
        .get();

    List<Map<String, dynamic>> tempBasvuranlar = [];
    for (var doc in snapshot.docs) {
      var basvuru = doc.data();
      var kullaniciID = basvuru['kullaniciID'];

      // Firebase Authentication'dan UID'yi alıyoruz
      String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

      if (currentUserUid != null && currentUserUid == kullaniciID) {
        // Kullanıcının başvurduğu ürün için verileri al
        var userDoc = await FirebaseFirestore.instance
            .collection('users') // Kullanıcı bilgilerini saklayan koleksiyon
            .doc(kullaniciID)
            .get();

        if (userDoc.exists) {
          var userData = userDoc.data();
          if (userData != null && userData.containsKey('email')) {
            tempBasvuranlar.add({
              'kullaniciID': kullaniciID,
              'b_adedi': basvuru['b_adedi'],
              'email': userData['email'], // Kullanıcı e-posta adresi
              'isim': userData['isim'], // Kullanıcı e-posta adresi
              'soyad': userData['soyad'], // Kullanıcı e-posta adresi
            });
          } else {
            print('Email bulunamadı: $kullaniciID');
          }
        }
      }
    }

    setState(() {
      basvuranlar = tempBasvuranlar;
    });
  }

  // Ürünü Güncelle
  void _updateUrun() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection('urunler')
          .doc(widget.urunmodel.urunID)
          .update({
        'urunAdi': _urunAdiController.text,
        'urunFiyat': double.parse(_urunFiyatController.text),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ürün güncellendi')),
      );
    }
  }

  // Ürünü Sil
  void _deleteUrun() async {
    await FirebaseFirestore.instance
        .collection('urunler')
        .doc(widget.urunmodel.urunID)
        .delete();

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ürün silindi')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.urunmodel.adi),
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _urunAdiController,
                    decoration: const InputDecoration(
                      labelText: 'Ürün Adı',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ürün adı boş olamaz';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _urunFiyatController,
                    decoration: const InputDecoration(
                      labelText: 'Ürün Fiyatı',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ürün fiyatı boş olamaz';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Geçerli bir sayı girin';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 40),
            const Text(
              'Başvuranlar',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: basvuranlar.isEmpty
                  ? const Center(
                      child: Text(
                        'Başvuran yok',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: basvuranlar.length,
                      itemBuilder: (context, index) {
                        var basvuru = basvuranlar[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilSayfasi(
                                  kullaniciID: basvuru['kullaniciID'],
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(
                                'Başvuran: ${basvuranlar[index]['isim']} ${basvuranlar[index]['soyad']}'), // E-posta adresini göster
                            subtitle: Text('Adet: ${basvuru['b_adedi']}'),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: _updateUrun,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.lightGreen),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.update, color: Colors.lightGreen),
                  label: const Text(
                    'Güncelle',
                    style: TextStyle(color: Colors.lightGreen),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _deleteUrun,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    'Sil',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
