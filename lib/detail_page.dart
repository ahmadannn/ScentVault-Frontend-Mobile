import 'package:flutter/material.dart';
import 'package:project_pertama/atelier_kesesuaian_page.dart';
import 'package:project_pertama/widgets/custom_top_bar.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

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
                      _buildActionText(Icons.edit_outlined, 'UBAH', const Color(0xFF75553C)),
                      const SizedBox(width: 16),
                      _buildActionText(Icons.delete_outline, 'HAPUS', const Color(0xFFD6604D)),
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
                    color: Colors.black, // Placeholder background for image
                    child: const Icon(Icons.image, size: 80, color: Colors.white24),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Title Info
              Center(
                child: Column(
                  children: [
                    const Text(
                      'MAISON DE L\'ARÔME',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF75553C),
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Oud Immortel',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF75553C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return const Icon(Icons.star, color: Color(0xFFD6A87D), size: 18);
                      }),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ditambahkan pada 14/10/2023',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF9E958D),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Description
              const Text(
                'Wewangian kayu yang kompleks yang menangkap esensi kayu oud kuno yang seimbang dengan kecerahan ceria dari kapulaga dan limoncello. Ia berkembang menjadi jejak asap yang canggih yang bertahan selama berjam-jam, menggema kemewahan perpustakaan pribadi.',
                textAlign: TextAlign.center,
                style: TextStyle(
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
              _buildPyramidItem('AROMA PUNCAK', 'Limoncello, Kapulaga, Kemenyan', const Color(0xFFFBEBE4)),
              const SizedBox(height: 12),
              _buildPyramidItem('AROMA INTI', 'Papirus, Patchouli, Rosewood', const Color(0xFF75553C)),
              const SizedBox(height: 12),
              _buildPyramidItem('AROMA DASAR', 'Oud, Oakmoss, Tembakau', const Color(0xFF4A3728)),
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
        ),
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
