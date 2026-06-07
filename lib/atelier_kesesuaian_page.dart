import 'package:flutter/material.dart';
import 'package:project_pertama/services/api_service.dart';
import 'package:project_pertama/detail_page.dart';
import 'package:shimmer/shimmer.dart';

class AtelierKesesuaianPage extends StatefulWidget {
  final Map<String, dynamic>? initialPerfume;
  const AtelierKesesuaianPage({super.key, this.initialPerfume});

  @override
  State<AtelierKesesuaianPage> createState() => _AtelierKesesuaianPageState();
}

class _AtelierKesesuaianPageState extends State<AtelierKesesuaianPage> {
  String _selectedTemperature = 'normal';
  String _selectedTimeOfDay = 'pagi';
  String _selectedEnvironment = 'all_around';
  
  bool _isLoadingData = false;
  bool _isFetchingRecommendation = false;
  
  List<dynamic> _recommendations = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialPerfume != null) {
      _recommendations = [
        {
          'perfume': widget.initialPerfume,
          'score': 100, // Dummy score
          'reason': 'Kondisi saat ini sangat mendukung karakter parfum Anda.', // Dummy reason
        }
      ];
    } else {
      _fetchRecommendations();
    }
  }

  Future<void> _fetchRecommendations() async {
    setState(() => _isFetchingRecommendation = true);
    
    // Using the parameters based on the new UI
    final body = {
      "temperature": _selectedTemperature,
      "time_of_day": _selectedTimeOfDay,
      "environment": _selectedEnvironment,
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
                
                // Suhu / Temperature
                const Text('PILIH SUHU (TEMPERATURE)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9E958D), letterSpacing: 1.0)),
                const SizedBox(height: 16),
                _buildTempOption('dingin', 'Dingin', 'Untuk cuaca sejuk', Icons.ac_unit),
                const SizedBox(height: 12),
                _buildTempOption('normal', 'Normal', null, Icons.wb_sunny_outlined),
                const SizedBox(height: 12),
                _buildTempOption('panas', 'Panas', 'Aroma segar & ringan', Icons.light_mode_outlined),
                
                const SizedBox(height: 32),
                // Waktu / Time of Day
                const Text('WAKTU (TIME OF DAY)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9E958D), letterSpacing: 1.0)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildEnvOption('Pagi', 'pagi', Icons.wb_twilight, _selectedTimeOfDay == 'pagi', (val) => setState(() => _selectedTimeOfDay = val))),
                    const SizedBox(width: 8),
                    Expanded(child: _buildEnvOption('Siang', 'siang', Icons.wb_sunny_outlined, _selectedTimeOfDay == 'siang', (val) => setState(() => _selectedTimeOfDay = val))),
                    const SizedBox(width: 8),
                    Expanded(child: _buildEnvOption('Malam', 'malam', Icons.nightlight_round_outlined, _selectedTimeOfDay == 'malam', (val) => setState(() => _selectedTimeOfDay = val))),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Lingkungan / Environment
                const Text('LINGKUNGAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9E958D), letterSpacing: 1.0)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F3EF),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _buildEnvironmentPill('Indoor', 'indoor', Icons.home_outlined)),
                      Expanded(child: _buildEnvironmentPill('Outdoor', 'outdoor', Icons.park_outlined)),
                      Expanded(child: _buildEnvironmentPill('All Around', 'all_around', Icons.all_inclusive)),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
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
                ] else if (_recommendations.isEmpty) ...[
                  if (_isFetchingRecommendation)
                    const Center(child: CircularProgressIndicator(color: Color(0xFF75553C)))
                  else
                    const Center(
                      child: Text('Belum ada rekomendasi.', style: TextStyle(color: Color(0xFF9E958D))),
                    ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
      ),
    );
  }

  Widget _buildTempOption(String value, String title, String? subtitle, IconData icon) {
    bool isSelected = _selectedTemperature == value;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedTemperature = value);
        _fetchRecommendations();
      },
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2E2B2A))),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF9E958D))),
                  ],
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: Color(0xFF75553C), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvOption(String title, String value, IconData icon, bool isSelected, Function(String) onTap) {
    return GestureDetector(
      onTap: () {
        onTap(value);
        _fetchRecommendations();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF6F3EF),
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: const Color(0xFF75553C), width: 1.5) : Border.all(color: Colors.transparent, width: 1.5),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: isSelected ? const Color(0xFF4A3728) : const Color(0xFF9E958D)),
            const SizedBox(width: 6),
            Text(title, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, color: isSelected ? const Color(0xFF4A3728) : const Color(0xFF9E958D))),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvironmentPill(String title, String value, IconData icon) {
    bool isSelected = _selectedEnvironment == value;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedEnvironment = value);
        _fetchRecommendations();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isSelected ? const Color(0xFF4A3728) : const Color(0xFF9E958D)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, color: isSelected ? const Color(0xFF4A3728) : const Color(0xFF9E958D))),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(dynamic recommendation) {
    final perfume = recommendation['perfume'] ?? {};
    final reason = recommendation['reason'] ?? '';
    final name = perfume['name'] ?? 'Unknown';
    final imageUrl = ApiService.fixImageUrl(perfume['image_url']);
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
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/upload_parfum.png', fit: BoxFit.cover))
                  : Image.asset('assets/images/upload_parfum.png', fit: BoxFit.cover),
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
