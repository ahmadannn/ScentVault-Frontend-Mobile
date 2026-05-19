import 'package:flutter/material.dart';
import 'package:project_pertama/detail_page.dart';
import 'package:project_pertama/widgets/custom_top_bar.dart';
import 'package:project_pertama/add_perfume_page.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  final List<Map<String, dynamic>> perfumes = [
    {
      'brand': 'MAISON DE LUXE',
      'name': 'Ambre Nuit',
      'rating': '4.8',
      'tags': ['AMBER', 'ROSE'],
      'image': 'assets/images/perfume_bottle.png',
    },
    {
      'brand': 'BOTANICAL ESSENCE',
      'name': 'Rose Vellum',
      'rating': '4.5',
      'tags': ['FLORAL', 'SWEET'],
      'image': 'assets/images/perfume_bottle.png',
    },
    {
      'brand': 'SWEET ATELIER',
      'name': 'Oud immortel',
      'rating': '4.3',
      'tags': ['VANILLA', 'PRALINE'],
      'image': 'assets/images/perfume_bottle.png',
    },
    {
      'brand': 'SWEET ATELIER',
      'name': 'Velvet Vanilla',
      'rating': '4.3',
      'tags': ['VANILLA', 'PRALINE'],
      'image': 'assets/images/perfume_bottle.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAF8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Bar
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: CustomTopBar(),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Header Text
                    const Text(
                      'Koleksi Saya',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF75553C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Mengkurasi esensi dari atelier digital Anda.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9E958D),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Search Bar
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFECE7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari parfum anda...',
                          hintStyle: TextStyle(
                            color: const Color(0xFFB5ADAA),
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF9E958D),
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildChip('SEMUA', true),
                          const SizedBox(width: 10),
                          _buildChip('BUNGA', false),
                          const SizedBox(width: 10),
                          _buildChip('KAYU', false),
                          const SizedBox(width: 10),
                          _buildChip('SEGAR', false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Sort & Add Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Urutkan:',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF63564B),
                              ),
                            ),
                            const Text(
                              'Baru Ditambahkan',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF75553C),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF75553C),
                              size: 16,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AddPerfumePage()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD6A87D),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'TAMBAH PARFUME',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // List of Cards
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: perfumes.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return _buildPerfumeCard(perfumes[index]);
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF75553C) : const Color(0xFFFBEBE4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : const Color(0xFF75553C),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildPerfumeCard(Map<String, dynamic> act) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.black, // Dark background behind image if it has transparency
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    act['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          act['brand'],
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFFA59E98),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Icon(
                          Icons.delete_outline,
                          color: const Color(0xFFD6604D),
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      act['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2E2B2A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFF75553C),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          act['rating'],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2E2B2A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Tags
                    Row(
                      children: (act['tags'] as List).map((tag) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFECE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF63564B),
                              letterSpacing: 0.5,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Button
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DetailPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCE9F72),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: const Text(
                'LIHAT DETAIL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
