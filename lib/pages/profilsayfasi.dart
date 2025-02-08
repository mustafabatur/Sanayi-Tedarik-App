import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilSayfasi extends StatelessWidget {
  final String? kullaniciID;

  const ProfilSayfasi({Key? key, required this.kullaniciID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcı Profili'),
        backgroundColor: Colors.lightGreen,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(kullaniciID)
            .get(),
        builder: (context, snapshot) {
          // Verinin yüklenmesini beklerken gösterilen animasyon
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Hata durumunda kullanıcıya bildirim göster
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu'));
          }
          // Verinin olmadığı veya yanlış olduğunda uyarı mesajı
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Kullanıcı bulunamadı'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          // Null kontrolü ve varsayılan değerler
          String isim = userData['isim'] ?? 'İsim Bilgisi Yok';
          String soyad = userData['soyad'] ?? 'Soyad Bilgisi Yok';
          String kurumAdi = userData['kurumAdi'] ?? 'Kurum Bilgisi Yok';
          String email = userData['email'] ?? 'Email Bilgisi Yok';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.lightGreen,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                _buildInfoTile('İsim', isim),
                _buildInfoTile('Soyisim', soyad),
                _buildInfoTile('Kurum Adı', kurumAdi),
                _buildInfoTile('Email', email),
              ],
            ),
          );
        },
      ),
    );
  }

  // Veriyi göstermek için ortak bir widget
  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
