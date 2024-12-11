import 'package:produk/ui/produk_detail.dart';
import 'package:produk/ui/produk_form.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // Untuk decode JSON
import 'package:http/http.dart' as http; // Untuk HTTP request
import 'package:produk/models/api.dart'; // Pastikan ini diimpor untuk URL API
import 'package:produk/models/mproduk.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  late Future<List<ProdukModel>> produkList;

  @override
  void initState() {
    super.initState();
    produkList = getProdukList();
  }

  Future<List<ProdukModel>> getProdukList() async {
    final response = await http.get(Uri.parse(BaseUrl.data));
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<ProdukModel> produkList = items.map<ProdukModel>((json) {
      return ProdukModel.fromJson(json);
    }).toList();
    return produkList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Produk"),
        centerTitle: true,
        backgroundColor: Colors.indigo, // Warna yang lebih segar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.blue[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<ProdukModel>>(
          future: produkList,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.indigo,
                ),
              );
            }
            if (snapshot.data.isEmpty) {
              return Center(
                child: Text(
                  "Tidak ada data produk.",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var data = snapshot.data[index];
                return Card(
                  elevation: 6, // Penambahan bayangan
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: Icon(Icons.shopping_cart, color: Colors.white),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    title: Text(
                      "${data.kode_produk} - ${data.nama_produk}",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Harga: Rp ${data.harga}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Details(sw: data),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 28),
        backgroundColor: Colors.indigo,
        hoverColor: Colors.greenAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return ProdukForm();
            }),
          );
        },
      ),
    );
  }
}