import 'package:flutter/material.dart';
import 'package:proje2/models/urun_model.dart';
import 'package:proje2/pages/kurumProfil.dart';
import 'package:proje2/pages/urunekle.dart';

class Urundetay extends StatefulWidget {
  final UrunModel urun;

  const Urundetay({Key? key, required this.urun}) : super(key: key);

  @override
  _UrundetayState createState() => _UrundetayState();
}

class _UrundetayState extends State<Urundetay> {
  int adet = 0;
  double toplamFiyat = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ürün Detayları",
          style: TextStyle(color: Colors.lightGreen),
        ),
        backgroundColor: const Color.fromARGB(255, 34, 34, 34),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.lightGreen),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: const Drawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Center(
              child: SizedBox(
                height: 100,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                "Ürün Adı: ${widget.urun.adi}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                "Fiyat: ${widget.urun.fiyat} TL",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                "Ürün Detayları:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              widget.urun.aciklama,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text("Adet: "),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      adet = adet > 1 ? adet - 1 : 1;
                      toplamFiyat = adet * widget.urun.fiyat;
                    });
                  },
                ),
                Text(
                  ' $adet ',
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      adet++;
                      toplamFiyat = adet * widget.urun.fiyat;
                    });
                  },
                ),
                // Tedarikçiye Git butonu
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KurumDetay(
                          kullaniciID: widget.urun
                              .kullaniciID, // Ürünün kullanıcı ID'sini parametre olarak gönder
                        ),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 34, 34, 34),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    child: const Text(
                      "Tedarikçi",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.lightGreen,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                color: Colors.lightGreen,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            "Fiyat: $toplamFiyat TL",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 7, right: 13),
                            child: TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.lightGreen,
                                    content: Text(
                                      'Başvuru Yapıldı',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                                imagePickerController.addRequestToFirestore(
                                    widget.urun.urunID, adet);
                              },
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 34, 34, 34),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: const Text(
                                  "Başvur",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.lightGreen,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
