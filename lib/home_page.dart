import 'package:flutter/material.dart';
import 'package:project_pertama/detail_page.dart';
import 'package:project_pertama/widgets/custom_top_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAF8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              const CustomTopBar(),
              const SizedBox(height: 24),
              
              // Welcome Text
              const Text(
                'Selamat datang\nkembali, Kurator',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF75553C),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Atelier digital Anda telah dikurasi dan siap\nuntuk pilihan hari ini.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9E958D),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              
              // Stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard('INVENTARIS', 'TOTAL PARFUM', '128', Icons.auto_awesome),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard('ARSIP', 'ENTRI DIARY', '156', Icons.menu_book),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Recommendation
              const Text(
                'Rekomendasi Hari Ini',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2E2B2A),
                ),
              ),
              const SizedBox(height: 16),
              Container(
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Container(
                        height: 160,
                        color: const Color(0xFFEBE6DF),
                        child: const Center(
                          child: Icon(Icons.image, size: 50, color: Colors.black12),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Baccarat Rouge 540',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2E2B2A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Alkimia puitis di mana aroma melati yang ringan dan kemilau saffron membawa fasset ambergris dan aroma kayu.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9E958D),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildTag('SAFFRON'),
                              _buildTag('JASMINE'),
                              _buildTag('AMBERWOOD'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Recent Diary
              const Text(
                'Buku Harian Terbaru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2E2B2A),
                ),
              ),
              const SizedBox(height: 16),
              _buildDiaryCard('Santal 33', 'KANTOR • CERAH', 'Aroma kayu cendana yang ikonik memberikan kesan profesional namun tetap ramah. Sangat cocok untuk rapat pembukaan galeri hari ini.', '12/10/2025', Icons.wb_sunny_outlined),
              const SizedBox(height: 16),
              _buildDiaryCard('Baccarat', 'RESTO • SEJUK', 'Perpaduan mawar dan oud yang sangat megah. Memberikan rasa percaya diri ekstra saat berjalan di karpet merah malam ini.', '10/01/2025', Icons.nights_stay_outlined),
              const SizedBox(height: 16),
              _buildDiaryCard('Lacoco', 'PANTAI • CERAH', 'Kesegaran sitrus yang sempurna untuk udara siang yang cerah. Sangat ringan dan tidak mengganggu saat menikmati kopi di teras.', '08/11/2024', Icons.wb_sunny_outlined),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String badge, String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 16, color: const Color(0xFFCE9F72)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F3EF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF9E958D)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9E958D)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF75553C)),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFBEBE4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: Color(0xFFCE9F72),
        ),
      ),
    );
  }

  Widget _buildDiaryCard(String title, String subtitle, String desc, String date, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF6F3EF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F3EF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF9E958D)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2E2B2A)),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: Color(0xFF9E958D), letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF63564B), height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            date,
            style: const TextStyle(fontSize: 9, color: Color(0xFFB5ADAA)),
          ),
        ],
      ),
    );
  }
}
