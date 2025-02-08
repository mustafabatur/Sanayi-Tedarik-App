import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proje2/components/my_button.dart';
import 'package:proje2/components/my_text_field.dart';
import 'package:proje2/drawer.dart';
import 'package:proje2/models/urun_model.dart';
import 'package:proje2/pages/basvurular.dart';
import 'package:proje2/pages/controller/image_picker_controller.dart';

TextEditingController urunadicontroller = TextEditingController();
TextEditingController urunfiyaticontroller = TextEditingController();
TextEditingController urunaciklamasicontroller = TextEditingController();
TextEditingController urunkatagoresicontroller = TextEditingController();
ImagePickerControlLer imagePickerController = ImagePickerControlLer();

class UrunEklePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final controller = Get.put(ImagePickerControlLer());

  UrunEklePage({Key? key}) : super(key: key);

  Future<String?> getCurrentUserId() async {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      appBar: AppBar(
        title: const Text(
          "Ürün Ekle",
          style: TextStyle(
            color: Colors.lightGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: const drawer(),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(2.0),
                child: Divider(
                  color: Colors.lightGreen,
                  height: 1,
                  thickness: 2,
                  indent: 16,
                  endIndent: 16,
                ),
              ),
              const SizedBox(height: 20),
              MyTextField(
                hintText: "Ürün Adı",
                controller: urunadicontroller,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: "Ürün Fiyatı",
                controller: urunfiyaticontroller,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: "Ürün Açıklaması",
                controller: urunaciklamasicontroller,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: "Ürün Kategorisi",
                controller: urunkatagoresicontroller,
              ),
              const SizedBox(height: 20),
              MyButton(
                customColor: Colors.lightGreen,
                text: "Ürün Ekle",
                onTap: () async {
                  if (_auth.currentUser != null) {
                    String? userId = await getCurrentUserId();
                    String kullaniciID = userId ?? "";

                    String urunAdi = urunadicontroller.text;
                    String urunFiyat = urunfiyaticontroller.text;
                    String urunAciklama = urunaciklamasicontroller.text;
                    String urunKategori = urunkatagoresicontroller.text;

                    UrunModel urunModel = UrunModel(
                      adi: urunAdi,
                      fiyat: double.parse(urunFiyat),
                      aciklama: urunAciklama,
                      kategori: urunKategori,
                      kullaniciID: kullaniciID,
                      resim: '',
                      urunID: '',
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.lightGreen,
                        content: Text(
                          'Ürün Eklendi',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        duration: Duration(seconds: 1),
                      ),
                    );

                    String downloadURL =
                        await controller.uploadImageToFirebase();
                    controller.addProductToFirestore(downloadURL, urunModel);

                    clearTextControllers();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Basvurular(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.lightGreen,
                        content: Text(
                          'UPSSS Bir hata oluştu.',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void clearTextControllers() {
  urunadicontroller.clear();
  urunfiyaticontroller.clear();
  urunaciklamasicontroller.clear();
  urunkatagoresicontroller.clear();
}
