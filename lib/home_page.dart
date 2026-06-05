import 'package:flutter/material.dart';
import 'package:project_pertama/detail_page.dart';
import 'package:project_pertama/widgets/custom_top_bar.dart';
import 'package:project_pertama/services/api_service.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> _homeData;

  @override
  void initState() {
    super.initState();
    _homeData = Future.wait([
      ApiService.getHomePageData(),
      ApiService.getProfile(),
      ApiService.getCollectionPageData(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAF8),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _homeData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoading();
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Terjadi kesalahan saat memuat data.'));
            }

            final homeRes = snapshot.data?[0] ?? {};
            final profileRes = snapshot.data?[1] ?? {};

            final data = homeRes['data'] ?? {};
            
            // Extract user info from profileRes
            final userData = profileRes['data'] ?? {};
            final String rawName = userData['name'] ?? 'Kurator';
            final String firstName = rawName.split(' ').first;
            final String? userPhotoUrl = userData['image_url'];

            final stats = data['summary'] ?? {};
            final recommendationData = data['today_recommendation']?['perfume'];
            final recentLogs = data['scent_logs'] as List<dynamic>? ?? [];

            final collectionRes = snapshot.data?[2] ?? {};
            final perfumesList = collectionRes['data']?['perfumes']?['data'] as List<dynamic>? ?? [];

            final recommendation = recommendationData;
            String? recImageUrl;
            if (recommendation != null) {
              recImageUrl = recommendation['image_url'] ?? recommendation['image'];
              if (recImageUrl == null && perfumesList.isNotEmpty) {
                try {
                  final pId = recommendation['perfume_id'];
                  final match = perfumesList.firstWhere((p) => p['id'].toString() == pId.toString());
                  recImageUrl = match['image_url'];
                } catch (_) {}
              }
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Bar
                  CustomTopBar(photoUrl: userPhotoUrl != null ? ApiService.fixImageUrl(userPhotoUrl) : null),
                  const SizedBox(height: 24),
                  
                  // Welcome Text
                  Text(
                    'Selamat datang\nkembali, $firstName',
                    style: const TextStyle(
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
                        child: _buildStatCard('INVENTARIS', 'TOTAL PARFUM', '${stats['total_perfumes'] ?? 0}', Icons.auto_awesome),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard('ARSIP', 'ENTRI DIARY', '${stats['total_scent_logs'] ?? 0}', Icons.menu_book),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Recommendation
                  if (recommendation != null) ...[
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
                              child: recImageUrl != null && ApiService.fixImageUrl(recImageUrl).isNotEmpty
                                  ? Image.network(
                                      ApiService.fixImageUrl(recImageUrl), 
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/upload_parfum.png', fit: BoxFit.cover),
                                    )
                                  : Image.asset('assets/images/upload_parfum.png', fit: BoxFit.cover),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recommendation['name'] ?? 'Parfum',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF2E2B2A),
                                  ),
                                ),

                                const SizedBox(height: 16),
                                if (recommendation['notes'] != null)
                                  Wrap(
                                    children: (recommendation['notes'] is List
                                            ? recommendation['notes'] as List<dynamic>
                                            : recommendation['notes'].toString().replaceAll('{', '').replaceAll('}', '').split(','))
                                        .map((note) {
                                          final text = note is Map ? note['name'] : note.toString().trim();
                                          return text.isNotEmpty ? _buildTag(text) : const SizedBox.shrink();
                                        })
                                        .toList(),
                                  ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final pId = recommendation['perfume_id'];
                                      if (pId != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => DetailPage(perfumeId: pId is int ? pId : int.parse(pId.toString()))),
                                        );
                                      }
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
                  ],
                  
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
                  if (recentLogs.isEmpty)
                    const Text('Belum ada entri diary terbaru.', style: TextStyle(color: Color(0xFF9E958D))),
                  ...recentLogs.map((log) {
                    final logDate = log['input_date'] != null ? log['input_date'].toString().split('T')[0] : '';
                    final occasion = log['occasion']?['name'] ?? '';
                    final weather = log['weather'] ?? '';
                    final perfume = log['title'] ?? '';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildDiaryCard(perfume, '$occasion • $weather', log['notes_review'] ?? '', logDate, Icons.wb_sunny_outlined),
                    );
                  }).toList(),
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomTopBar(),
          const SizedBox(height: 24),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 30, width: 250, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 30, width: 200, color: Colors.white),
                const SizedBox(height: 16),
                Container(height: 14, width: 300, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 14, width: 250, color: Colors.white),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(child: Container(height: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)))),
                    const SizedBox(width: 16),
                    Expanded(child: Container(height: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)))),
                  ],
                ),
                const SizedBox(height: 32),
                Container(height: 20, width: 150, color: Colors.white),
                const SizedBox(height: 16),
                Container(height: 250, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))),
              ],
            ),
          ),
        ],
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
      margin: const EdgeInsets.only(right: 6, bottom: 6),
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
            decoration: const BoxDecoration(
              color: Color(0xFFF6F3EF),
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
                  subtitle.toUpperCase(),
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
