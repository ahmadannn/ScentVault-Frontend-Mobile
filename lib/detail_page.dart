import 'package:flutter/material.dart';
import 'package:project_pertama/atelier_kesesuaian_page.dart';
import 'package:project_pertama/widgets/custom_top_bar.dart';
import 'package:project_pertama/services/api_service.dart';
import 'package:project_pertama/add_perfume_page.dart';
import 'package:shimmer/shimmer.dart';

class DetailPage extends StatefulWidget {
  final int perfumeId;
  const DetailPage({super.key, required this.perfumeId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _perfumeData;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await ApiService.getPerfumeDetail(widget.perfumeId);
      if (res['success'] == true && res['data'] != null) {
        setState(() {
          _perfumeData = res['data'];
        });
      } else {
        setState(() {
          _errorMessage = res['message'] ?? 'Gagal memuat detail parfum';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan koneksi';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildShimmerSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomTopBar(title: 'DETAIL PARFUM'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 32, height: 32, decoration: const BoxDecoration(color: Color(0xFF75553C), shape: BoxShape.circle), child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 14)),
              Row(
                children: [
                  Container(width: 60, height: 20, color: Colors.white),
                  const SizedBox(width: 16),
                  Container(width: 60, height: 20, color: Colors.white),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Container(width: 140, height: 180, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)))),
                const SizedBox(height: 32),
                Container(height: 14, width: 100, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 24, width: 200, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 14, width: 50, color: Colors.white),
                const SizedBox(height: 32),
                Container(height: 14, width: double.infinity, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 14, width: double.infinity, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 14, width: 200, color: Colors.white),
                const SizedBox(height: 32),
                Container(height: 200, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
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
        child: _isLoading
        ? _buildShimmerSkeleton()
        : _errorMessage != null
          ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
          : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    final data = _perfumeData!;
    final brand = data['brand_name'] ?? 'UNKNOWN BRAND';
    final name = data['name'] ?? 'Unknown';
    final description = data['description'] ?? 'Tidak ada deskripsi.';
    final rating = data['star_rating']?.toString() ?? '0.0';
    final imageUrl = data['image_url'];
    final createdAt = data['created_at'] != null ? data['created_at'].toString().substring(0, 10) : 'N/A';

    final notes = (data['notes'] as List<dynamic>?) ?? [];
    final topNotes = notes.where((n) => n['type'] == 'top').map((n) => n['name']).join(', ');
    final heartNotes = notes.where((n) => n['type'] == 'middle').map((n) => n['name']).join(', ');
    final baseNotes = notes.where((n) => n['type'] == 'base').map((n) => n['name']).join(', ');

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Bar
          const CustomTopBar(title: 'DETAIL PARFUM'),
          const SizedBox(height: 16),
          
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF75553C),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 14),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPerfumePage(
                            perfumeId: widget.perfumeId,
                            initialData: _perfumeData,
                          ),
                        ),
                      );
                      if (updated == true) {
                        _fetchDetail();
                      }
                    },
                    child: _buildActionText(Icons.edit_outlined, 'UBAH', const Color(0xFF75553C)),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Hapus Parfum'),
                          content: const Text('Yakin ingin menghapus parfum ini?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
                            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus', style: TextStyle(color: Colors.red))),
                          ],
                        )
                      );
                      if (confirm == true) {
                        await ApiService.deletePerfume(widget.perfumeId);
                        Navigator.pop(context, true); // return true to refresh list
                      }
                    },
                    child: _buildActionText(Icons.delete_outline, 'HAPUS', const Color(0xFFD6604D)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Image
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                height: 300,
                color: const Color(0xFFEBE6DF),
                child: ApiService.fixImageUrl(imageUrl).isNotEmpty
                    ? Image.network(ApiService.fixImageUrl(imageUrl), fit: BoxFit.cover)
                    : const Icon(Icons.image, size: 80, color: Colors.black12),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Title Info
          Center(
            child: Column(
              children: [
                Text(
                  brand.toString().toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF75553C),
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF75553C),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final doubleRating = double.tryParse(rating) ?? 0;
                    return Icon(
                      index < doubleRating ? Icons.star : Icons.star_border, 
                      color: const Color(0xFFD6A87D), 
                      size: 18
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ditambahkan pada $createdAt',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF9E958D),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF9E958D),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          
          // Piramida Olfaktori
          const Text(
            'Piramida Olfaktori',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2E2B2A),
            ),
          ),
          const SizedBox(height: 16),
          _buildPyramidItem('AROMA PUNCAK', topNotes.isEmpty ? '-' : topNotes, const Color(0xFFFBEBE4)),
          const SizedBox(height: 12),
          _buildPyramidItem('AROMA INTI', heartNotes.isEmpty ? '-' : heartNotes, const Color(0xFF75553C)),
          const SizedBox(height: 12),
          _buildPyramidItem('AROMA DASAR', baseNotes.isEmpty ? '-' : baseNotes, const Color(0xFF4A3728)),
          const SizedBox(height: 32),
          
          // Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AtelierKesesuaianPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCE9F72),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: const Text(
                'CEK KESESUAIAN AROMA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildActionText(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPyramidItem(String title, String notes, Color barColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 30,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF9E958D),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notes,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF63564B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
