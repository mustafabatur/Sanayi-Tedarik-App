import 'package:flutter/material.dart';
import 'package:proje2/drawer.dart';
import 'package:proje2/models/FirestoreService.dart';
import 'package:proje2/models/urun_model.dart';
import 'package:proje2/pages/urundetay.dart';

class AnaSayfa extends StatefulWidget {
  final FirestoreService _firestoreService = FirestoreService();

  AnaSayfa({Key? key}) : super(key: key);

  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  List<UrunModel> urunListesi = [];
  List<UrunModel> filteredUrunListesi = [];
  TextEditingController kategoriController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final Stream<List<UrunModel>> dataStream =
        widget._firestoreService.getUrunlerStream();

    dataStream.listen((data) {
      setState(() {
        urunListesi = data;
        filteredUrunListesi = List.from(urunListesi);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      appBar: AppBar(
        title: const Text(
          "Anasayfa",
          style: TextStyle(
            color: Colors.lightGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme:
            IconThemeData(color: Colors.white), // Drawer simgesinin rengi
      ),
      drawer: drawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: kategoriController,
              style: TextStyle(color: Colors.lightGreen),
              decoration: InputDecoration(
                labelText: 'Kategori Giriniz..',
                labelStyle:
                    TextStyle(color: const Color.fromARGB(255, 85, 85, 85)),
                hintStyle: TextStyle(color: Colors.lightGreen),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: const Color.fromARGB(255, 36, 36, 36)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                suffixIcon: kategoriController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.lightGreen),
                        onPressed: () {
                          setState(() {
                            kategoriController.clear();
                            filterUrunler('');
                          });
                        },
                      )
                    : Icon(Icons.search, color: Colors.grey),
              ),
              onChanged: (value) {
                filterUrunler(value);
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : buildUrunListesi(),
          ),
        ],
      ),
    );
  }

  Widget buildUrunListesi() {
    return ListView.builder(
      itemCount: filteredUrunListesi.length,
      itemBuilder: (context, index) {
        final urun = filteredUrunListesi[index];

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Urundetay(urun: urun),
                ),
              );
            },
            child: ListTile(
              // tileColor: Color.fromARGB(74, 255, 4, 4),
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${urun.adi}', // Bold stil
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Metnin görünürlüğünü sağlar
                      ),
                    ),
                  ],
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Fiyat: ${urun.fiyat} TL"),
                  Text("Açıklama: ${urun.aciklama}"),
                  Text(
                      "Kategori: ${urun.kategori.isEmpty ? 'Yok' : urun.kategori}"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Ürünleri filtreleme işlevi
  void filterUrunler(String query) {
    query = query.toLowerCase();

    if (kategoriController.text.isEmpty) {
      setState(() {
        filteredUrunListesi = urunListesi;
      });
    } else {
      setState(() {
        filteredUrunListesi = urunListesi.where((urun) {
          final kategori = urun.kategori.toLowerCase();
          return kategori.contains(query);
        }).toList();
      });
    }
  }
}
