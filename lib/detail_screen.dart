import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'checkout_screen.dart';

class DetailScreen extends StatelessWidget {
  final String name;
  final String price;
  final String imagePath;

  // Harusnya deskripsi ini dikirim dari Home biar dinamis,
  // tapi untuk sekarang kita pakai default dulu sesuai kode kamu.
  final String description =
      "Wuling Air EV merupakan mobil listrik kompak berdimensi panjang sekitar 2,9 meter yang dirancang khusus untuk mobilitas perkotaan dengan kapasitas empat penumpang. Mobil ini ditenagai oleh motor listrik berdaya 30 kW (40 hp) dan torsi 110 Nm dengan penggerak roda belakang. \n\nSerta menggunakan baterai Lithium Ferro-Phosphate (LFP) bersertifikasi IP67 yang tahan air. Terdapat dua pilihan varian utama berdasarkan jarak tempuh, yaitu Standard Range dengan kapasitas baterai 17,3 kWh yang mampu melaju hingga 200 km.";

  const DetailScreen({
    super.key,
    required this.name,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 1. APP BAR TRANSPARAN
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: Colors.black,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 20,
                color: Colors.black,
              ),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
        ],
      ),

      // 2. BODY SCROLLABLE
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- GAMBAR MOBIL ---
            Center(
              child: Hero(
                // Efek animasi zoom saat pindah halaman
                tag: name,
                child: Image.asset(imagePath, height: 220, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 20),

            // --- PANEL INFORMASI ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Mobil
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Harga
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C63FF), // Warna Ungu kayak di gambar
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Deskripsi
                  Text(
                    description,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.grey,
                      height: 1.5,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- TOMBOL TEST DRIVE & CHAT ---
                  Row(
                    children: [
                      // Tombol Test Drive (Kuning)
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFF4C542,
                            ), // Kuning Emas
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Test Drive",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),

                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF3F4F6),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                          ),
                          onPressed: () {
                            // Navigasi ke Halaman Chat
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // Kirim nama mobil ke halaman chat
                                builder: (context) => ChatScreen(carName: name),
                              ),
                            );
                          },
                          child: const Text(
                            "Chat",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // --- RELATED ADS ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Related Adds",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "See All",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildRelatedCard(
                          "Kijang Innova Reborn",
                          "\$148.00",
                          "assets/images/Innova_Reborn.png",
                        ),
                        _buildRelatedCard(
                          "Pajero Sport Dakar",
                          "\$55.00",
                          "assets/images/Pajero_Dakar.png",
                        ),
                        _buildRelatedCard(
                          "Corolla Altis",
                          "\$66.90",
                          "assets/images/Altis_New.png",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), //
                ],
              ),
            ),
          ],
        ),
      ),

      // 3. TOMBOL BOOKING NOW (Sticky di Bawah)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF3F43), // Merah Melaju
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            onPressed: () {
              // Arahkan ke Halaman Checkout
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutScreen(
                    carName: name, // Kirim nama mobil
                    price: price, // Kirim harga mobil
                  ),
                ),
              );
            },
            child: const Text(
              "Booking Now",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  // Widget Helper untuk Kartu Iklan Terkait
  Widget _buildRelatedCard(String name, String price, String imagePath) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(imagePath, height: 80, fit: BoxFit.contain),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
