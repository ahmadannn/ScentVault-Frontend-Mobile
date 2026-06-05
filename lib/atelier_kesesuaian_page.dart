import 'package:flutter/material.dart';
import 'package:project_pertama/services/api_service.dart';
import 'package:project_pertama/detail_page.dart';
import 'package:shimmer/shimmer.dart';

class AtelierKesesuaianPage extends StatefulWidget {
  const AtelierKesesuaianPage({super.key});

  @override
  State<AtelierKesesuaianPage> createState() => _AtelierKesesuaianPageState();
}

class _AtelierKesesuaianPageState extends State<AtelierKesesuaianPage> {
  String _selectedWeather = 'cerah';
  String? _selectedOccasionId;
  
  List<dynamic> _occasions = [];
  bool _isLoadingData = true;
  bool _isFetchingRecommendation = false;
  
  List<dynamic> _recommendations = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoadingData = true);
    try {
      _occasions = await ApiService.getOccasions();
      if (_occasions.isNotEmpty) {
        _selectedOccasionId = _occasions.first['id'].toString();
      }
    } catch (e) {
      // handle err
    } finally {
      if (mounted) {
        setState(() => _isLoadingData = false);
      }
    }
  }

  Future<void> _fetchRecommendations() async {
    if (_selectedOccasionId == null) return;
    
    setState(() => _isFetchingRecommendation = true);
    
    final body = {
      "weather": _selectedWeather,
      "occasion_id": int.parse(_selectedOccasionId!),
      "limit": 3
    };
    
    final res = await ApiService.getRecommendations(body);
    
    if (mounted) {
      setState(() {
        _isFetchingRecommendation = false;
        if (res['success'] == true && res['data'] != null) {
          _recommendations = res['data'];
        } else {
          _recommendations = [];
        }
      });
    }
  }

  Widget _buildShimmerSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 36, height: 36, decoration: const BoxDecoration(color: Color(0xFF75553C), shape: BoxShape.circle), child: const Center(child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16))),
          const SizedBox(height: 24),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 32, width: 250, color: Colors.white),
                const SizedBox(height: 16),
                Container(height: 14, width: double.infinity, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 14, width: double.infinity, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 14, width: 200, color: Colors.white),
                const SizedBox(height: 32),
                Container(height: 14, width: 150, color: Colors.white),
                const SizedBox(height: 16),
                Container(height: 60, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
                const SizedBox(height: 12),
                Container(height: 60, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
                const SizedBox(height: 12),
                Container(height: 60, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
                const SizedBox(height: 32),
                Container(height: 14, width: 150, color: Colors.white),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(4, (index) => Container(height: 40, width: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)))),
                ),
                const SizedBox(height: 32),
                Container(height: 48, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAF8),
      body: SafeArea(
        child: _isLoadingData 
        ? _buildShimmerSkeleton()
        : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFF75553C),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Title
                const Text(
                  'Atelier Kesesuaian',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF4A3728),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Desc
                const Text(
                  'Temukan aroma yang sempurna untuk setiap momen berharga Anda. Melalui kurasi algoritma penciuman kami, selaraskan suasana hati dan lingkungan dengan karakter parfum yang tepat.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF63564B),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Suhu / Weather
                const Text('PILIH CUACA (WEATHER)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9E958D), letterSpacing: 1.0)),
                const SizedBox(height: 16),
                _buildTempOption('dingin', 'Dingin / Sejuk', Icons.ac_unit),
                const SizedBox(height: 12),
                _buildTempOption('cerah', 'Cerah / Normal', Icons.wb_sunny_outlined),
                const SizedBox(height: 12),
                _buildTempOption('hujan', 'Hujan / Mendung', Icons.cloud),
                
                const SizedBox(height: 32),
                // Occasion
                const Text('KESEMPATAN (OCCASION)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9E958D), letterSpacing: 1.0)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _occasions.map((occ) {
                    return _buildEnvOption(occ['name'], occ['id'].toString(), Icons.event);
                  }).toList(),
                ),
                
                const SizedBox(height: 32),
                
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isFetchingRecommendation ? null : _fetchRecommendations,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCE9F72),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: _isFetchingRecommendation
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text(
                          'CARI REKOMENDASI',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.0),
                        ),
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Recommendation Cards
                if (_recommendations.isNotEmpty) ...[
                  const Text('HASIL REKOMENDASI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9E958D), letterSpacing: 1.0)),
                  const SizedBox(height: 16),
                  ..._recommendations.map((rec) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: _buildRecommendationCard(rec),
                    );
                  }).toList(),
                ] else if (_recommendations.isEmpty && !_isFetchingRecommendation && _selectedOccasionId != null) ...[
                  const Center(
                    child: Text('Belum ada rekomendasi. Tekan "CARI REKOMENDASI".', style: TextStyle(color: Color(0xFF9E958D))),
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
      ),
    );
  }

  Widget _buildTempOption(String value, String title, IconData icon) {
    bool isSelected = _selectedWeather == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedWeather = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF6F3EF),
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: const Color(0xFF75553C), width: 1.5) : Border.all(color: Colors.transparent, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: const Color(0xFF75553C)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2E2B2A))),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: Color(0xFF75553C), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvOption(String title, String id, IconData icon) {
    bool isSelected = _selectedOccasionId == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedOccasionId = id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF6F3EF),
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: const Color(0xFF75553C), width: 1.5) : Border.all(color: Colors.transparent, width: 1.5),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isSelected ? const Color(0xFF4A3728) : const Color(0xFF9E958D)),
            const SizedBox(width: 6),
            Text(title, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, color: isSelected ? const Color(0xFF4A3728) : const Color(0xFF9E958D))),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(dynamic recommendation) {
    final perfume = recommendation['perfume'] ?? {};
    final reason = recommendation['reason'] ?? '';
    final name = perfume['name'] ?? 'Unknown';
    final imageUrl = perfume['image_url'];
    final notes = (perfume['notes'] as List<dynamic>?) ?? [];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            child: Container(
              height: 250,
              color: const Color(0xFFEBE6DF),
              child: imageUrl != null
                  ? Image.network(imageUrl, fit: BoxFit.cover)
                  : const Icon(Icons.image, size: 80, color: Colors.black12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('SKOR KECOCOKAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9E958D), letterSpacing: 0.5)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBEBE4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('${recommendation['score'] ?? 100}%', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFFB58455))),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF4A3728),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '"$reason"',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF63564B),
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                if (notes.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: notes.take(3).map((n) => _buildTag(n['name'].toString().toUpperCase())).toList(),
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailPage(perfumeId: perfume['id'])),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A3728),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Lihat Detail', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFBEBE4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Color(0xFFB58455),
        ),
      ),
    );
  }
}
