import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proje2/models/urun_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<UrunModel>> getUrunlerStream() {
    return _firestore.collection('urunler').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UrunModel(
          urunID: doc.id, // Firestore'dan gelen belge ID'si
          adi: data['urunAdi'],
          fiyat: data['urunFiyat'],
          aciklama: data['urunAciklama'],
          kategori: data['urunKatagorisi'],
          resim: data['resimURL'],
          kullaniciID: data['kullaniciID'],
        );
      }).toList();
    });
  }
}

Future<void> addRequestToFirestore(String urunID, int b_adedi) async {
  try {
    final firestore = FirebaseFirestore.instance;
    String kullaniciID = FirebaseAuth.instance.currentUser!
        .uid; // Firebase'den oturum açmış kullanıcının ID'sini alıyoruz

    await firestore.collection('Basvurular').add({
      'urunID': urunID,
      'b_adedi': b_adedi,
      'basvuranID': FirebaseAuth.instance.currentUser!.uid,
      'kullaniciID': FirebaseAuth
          .instance.currentUser!.uid, // Burada kullaniciID'yi ekliyoruz
    });
  } catch (e) {
    print('Başvuru eklenirken bir hata oluştu: $e');
  }
}

Future<List<Map<String, dynamic>>> getBasvuranlar(String urunID) async {
  QuerySnapshot basvuruQuery = await FirebaseFirestore.instance
      .collection('Basvurular')
      .where('urunID', isEqualTo: urunID)
      .get();

  return basvuruQuery.docs.map((doc) {
    return doc.data() as Map<String, dynamic>;
  }).toList();
}
