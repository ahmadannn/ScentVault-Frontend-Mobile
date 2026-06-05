import 'package:flutter/material.dart';
import 'package:project_pertama/detail_page.dart';
import 'package:project_pertama/widgets/custom_top_bar.dart';
import 'package:project_pertama/add_perfume_page.dart';
import 'package:project_pertama/services/api_service.dart';
import 'package:shimmer/shimmer.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  bool _isLoading = true;
  String? _errorMessage;
  
  List<dynamic> _categories = [];
  List<dynamic> _perfumes = [];
  
  // Future filters
  String? _selectedCategoryId;
  String _searchQuery = '';
  String _sort = 'newest';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Pass filters if backend supports it via URL, but for now we just fetch base data
      final response = await ApiService.getCollectionPageData();
      
      if (response['success'] == true && response['data'] != null) {
        setState(() {
          _categories = response['data']['categories'] ?? [];
          _perfumes = response['data']['perfumes']['data'] ?? [];
        });
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Gagal memuat data koleksi';
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
              child: _isLoading 
                ? _buildShimmerSkeleton()
                : _errorMessage != null
                  ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
                  : SingleChildScrollView(
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
                              onChanged: (value) {
                                // Implement local search or trigger API search
                              },
                              decoration: const InputDecoration(
                                hintText: 'Cari parfum anda...',
                                hintStyle: TextStyle(
                                  color: Color(0xFFB5ADAA),
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Color(0xFF9E958D),
                                  size: 20,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Chips (Categories)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildChip('SEMUA', _selectedCategoryId == null, null),
                                ..._categories.map((cat) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: _buildChip(
                                      cat['name'].toString().toUpperCase(), 
                                      _selectedCategoryId == cat['id'].toString(),
                                      cat['id'].toString()
                                    ),
                                  );
                                }).toList(),
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
                                    ' Baru Ditambahkan',
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
                                  ).then((_) => _fetchData()); // Refresh data after adding
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
                          if (_perfumes.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 40.0),
                              child: Center(
                                child: Text(
                                  'Belum ada parfum di koleksi Anda.',
                                  style: TextStyle(color: Color(0xFF9E958D)),
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _perfumes.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                return _buildPerfumeCard(_perfumes[index]);
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

  Widget _buildChip(String label, bool isActive, String? categoryId) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryId = categoryId;
          // You might want to filter _perfumes locally or refetch
        });
      },
      child: Container(
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
      ),
    );
  }

  Widget _buildShimmerSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 40, width: 200, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 16, width: 250, color: Colors.white),
                const SizedBox(height: 24),
                Container(height: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(height: 30, width: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
                    const SizedBox(width: 10),
                    Container(height: 30, width: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
                    const SizedBox(width: 10),
                    Container(height: 30, width: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
                  ],
                ),
                const SizedBox(height: 24),
                // Mock 2 perfume cards
                Container(height: 180, margin: const EdgeInsets.only(bottom: 16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
                Container(height: 180, margin: const EdgeInsets.only(bottom: 16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerfumeCard(Map<String, dynamic> perfume) {
    final imageUrl = perfume['image_url'];
    final brand = perfume['brand_name'] ?? 'UNKNOWN BRAND';
    final name = perfume['name'] ?? 'Unknown';
    final rating = perfume['star_rating']?.toString() ?? '0.0';
    final notes = (perfume['notes'] as List<dynamic>?) ?? [];

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
                  color: const Color(0xFFEBE6DF),
                  width: 100,
                  height: 100,
                  child: imageUrl != null
                      ? Image.network(imageUrl, fit: BoxFit.cover)
                      : const Center(child: Icon(Icons.image, color: Colors.black12)),
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
                          brand.toString().toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFFA59E98),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            // Impelement Delete if needed
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
                              await ApiService.deletePerfume(perfume['id']);
                              _fetchData();
                            }
                          },
                          child: const Icon(
                            Icons.delete_outline,
                            color: Color(0xFFD6604D),
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
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
                          rating,
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
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: notes.take(3).map((note) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFECE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            note['name'].toString().toUpperCase(),
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
                // Navigate to DetailPage and pass the ID
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailPage(perfumeId: perfume['id'])),
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
