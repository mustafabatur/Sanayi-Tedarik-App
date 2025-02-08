import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proje2/models/urun_model.dart';
import 'package:proje2/pages/urunduzenle.dart';
import 'package:proje2/pages/urunekle.dart';
// UpdateUrunModelScreen importu

// UrunModel modeli için gerekli import

class Basvurular extends StatelessWidget {
  const Basvurular({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      appBar: AppBar(
        title: const Text(
          "Tedariklerim",
          style: TextStyle(
            color: Colors.lightGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const Drawer(),
      body: FutureBuilder(
        future: getKullaniciUrunleri(user?.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          List<DocumentSnapshot> urunBelgeleri =
              snapshot.data as List<DocumentSnapshot>;

          return ListView.builder(
            itemCount: urunBelgeleri.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> urunData =
                  urunBelgeleri[index].data() as Map<String, dynamic>;

              UrunModel urunmodel = UrunModel(
                urunID: urunBelgeleri[index].id,
                adi: urunData['urunAdi'],
                kullaniciID: urunData['kullaniciID'] ?? '',
                aciklama: urunData['urunAciklama'] ?? '',
                fiyat: urunData['urunFiyat'].toDouble(),
                kategori: urunData['urunKategori'] ?? '',
                resim: urunData['resimURL'] ?? '',
              );

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8.0),
                  title: Text('Ürün Adı: ${urunData['urunAdi']}'),
                  subtitle: Text('Fiyat: ${urunData['urunFiyat']} TL'),
                  onTap: () {
                    // Ürün kartına tıklanınca UpdateUrunModelScreen'e geçiş
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BasvuruDetay(
                          urunmodel: urunmodel,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UrunEklePage(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<List<DocumentSnapshot>> getKullaniciUrunleri(
      String? kullaniciID) async {
    QuerySnapshot urunlerQuery = await FirebaseFirestore.instance
        .collection('urunler')
        .where('kullaniciID', isEqualTo: kullaniciID)
        .get();

    return urunlerQuery.docs;
  }
}
