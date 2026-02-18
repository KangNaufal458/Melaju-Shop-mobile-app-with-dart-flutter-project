import 'package:flutter/material.dart';
import 'categori_screen.dart'; // Pastikan file dan nama class benar
import 'profile_screen.dart';
import 'search_results_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  // 1. Menyiapkan variabel penampung nama
  final String username;

  // 2. Wajibkan pengirim untuk mengisi nama ini di Constructor
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  //  1. FUNGSI INIT STATE (Jalan saat halaman pertama kali dibuka)
  @override
  void initState() {
    super.initState();
    // Pasang Timer 3 Detik buat Pop-up
    Future.delayed(const Duration(seconds: 3), () {
      // Cek apakah halaman masih aktif sebelum memunculkan popup
      if (mounted) {
        _showPromoPopup();
      }
    });
  }

  //  2. FUNGSI UNTUK MEMUNCULKAN POP-UP
  void _showPromoPopup() {
    showDialog(
      context: context,
      barrierDismissible: true, // Bisa ditutup dengan klik di luar
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Latar belakang transparan
          elevation: 0,
          child: Stack(
            clipBehavior: Clip.none, // Biar tombol close bisa keluar dikit
            alignment: Alignment.center,
            children: [
              // GAMBAR PROMO
              Container(
                width: 350,
                height: 400, // Sesuaikan tinggi biar proporsional
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/bannerpromo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // TOMBOL CLOSE (X) DI POJOK KANAN ATAS
              Positioned(
                top: -10,
                right: -10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Tutup Pop-up
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 5),
                      ],
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFEF3F43),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: "Notif",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  // ✅ BUILD BODY - Switch between screens based on selected index
  Widget _buildBody() {
    if (_selectedIndex == 3) {
      // Profile screen
      return const ProfileScreen();
    }

    // Default: Home screen content
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === HEADER BARU (Ada Keranjang Belanja) ===
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // BAGIAN KIRI (Sapaan Dinamis)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Halo, ${widget.username} !",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Cari mobil impianmu?",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  // BAGIAN KANAN (KERANJANG BELANJA)
                  Stack(
                    children: [
                      // Tombol Keranjang
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Masuk ke Keranjang!"),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      // Titik Merah (Badge Notifikasi)
                      Positioned(
                        right: 5,
                        top: 5,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF3F43),
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            "0",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // ============================================
              const SizedBox(height: 20),

              // Search Bar
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const SearchResultsScreen(query: ''),
                    ),
                  );
                },
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    hintText: "Search",
                    hintStyle: const TextStyle(color: Colors.grey),
                    fillColor: const Color(0xFFF3F4F6),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Categories
              _buildSectionTitle("Categories", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoriScreen(),
                  ),
                );
              }),
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryItem(
                      'assets/images/Innova_Reborn.png',
                      "MPV",
                    ),
                    _buildCategoryItem('assets/images/Pajero_Dakar.png', "SUV"),
                    _buildCategoryItem('assets/images/Altis_New.png', "Sedan"),
                    _buildCategoryItem(
                      'assets/images/Yaris_GR.png',
                      "Hatchback",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Top Selling
              _buildSectionTitle("Top Selling", () {}),
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCarCard(
                      "Kijang Innova",
                      "Rp.200jt",
                      'assets/images/Innova_Reborn.png',
                    ),
                    _buildCarCard(
                      "Pajero Sport",
                      "Rp.450jt",
                      'assets/images/Pajero_Dakar.png',
                      originalPrice: "Rp.750jt",
                    ),
                    _buildCarCard(
                      "Corolla Altis",
                      "Rp.300jt",
                      'assets/images/Altis_New.png',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🛠️ CAR ACCESSORIES 🛠️
              _buildSectionTitle("Car Accessories", () {}),
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildAccessoryCard(
                      "Ban Michelin",
                      "Rp 1.2jt",
                      Colors.orange,
                    ),
                    _buildAccessoryCard("Oli Shell", "Rp 300rb", Colors.blue),
                    _buildAccessoryCard(
                      "Velg Racing",
                      "Rp 4.5jt",
                      Colors.purple,
                    ),
                    _buildAccessoryCard("Kaca Film", "Rp 800rb", Colors.green),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Helper ---

  Widget _buildSectionTitle(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            "See All",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String imagePath, String title) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(imagePath, width: 30, height: 30),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildCarCard(
    String name,
    String price,
    String imagePath, {
    String? originalPrice,
  }) {
    // Bungkus dengan GestureDetector untuk mendeteksi Klik
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              name: name,
              price: price,
              imagePath: imagePath, // Mengirim data gambar ke halaman detail
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                  // Tambahkan Hero biar animasinya mulus
                  tag: name,
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (originalPrice != null) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            originalPrice,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessoryCard(String name, String price, Color bgColor) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: bgColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.build_circle_outlined,
                color: bgColor,
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: const TextStyle(
                color: Color(0xFFEF3F43),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
