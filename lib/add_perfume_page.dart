import 'package:flutter/material.dart';

class AddPerfumePage extends StatefulWidget {
  const AddPerfumePage({super.key});

  @override
  State<AddPerfumePage> createState() => _AddPerfumePageState();
}

class _AddPerfumePageState extends State<AddPerfumePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAF8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Custom Back Appbar
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Color(0xFF75553C), size: 20),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Tambah Parfum',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF75553C),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Upload image placeholder
              Center(
                child: Container(
                  width: 180,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC7C5C3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.camera_alt, color: Color(0xFF8B5E3C), size: 32),
                      SizedBox(height: 8),
                      Text('UNGGAH FOTO BOTOL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF63564B))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              _buildTextField('NAMA FRAGRANCE', 'Contoh: Oud Wood'),
              const SizedBox(height: 16),
              _buildTextField('BRAND / RUMAH PARFUM', 'Contoh: Tom Ford'),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(child: _buildDropdown('KATEGORI AROMA', 'Woody')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDropdown('KONSENTRASI', 'EDP')),
                ],
              ),
              const SizedBox(height: 16),
              
              _buildMultilineTextField('DESKRIPSI & NARASI AROMA', 'Ceritakan pengalaman aromatikmu...'),
              const SizedBox(height: 16),
              
              // Rating
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F3EF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Peringkat Keseluruhan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2E2B2A))),
                          SizedBox(height: 4),
                          Text('Seberapa berkesan aroma ini?', style: TextStyle(fontSize: 10, color: Color(0xFF9E958D))),
                        ],
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.star, color: Color(0xFF8B5E3C), size: 18),
                        Icon(Icons.star, color: Color(0xFF8B5E3C), size: 18),
                        Icon(Icons.star, color: Color(0xFF8B5E3C), size: 18),
                        Icon(Icons.star, color: Color(0xFF8B5E3C), size: 18),
                        Icon(Icons.star_border, color: Color(0xFF8B5E3C), size: 18),
                        SizedBox(width: 8),
                        Text('4.0', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF75553C))),
                        Text('/5', style: TextStyle(fontSize: 10, color: Color(0xFF9E958D))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Piramida Olfaktori
              Row(
                children: [
                  Expanded(child: Container(height: 1, color: const Color(0xFFEBE6DF))),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('PIRAMIDA OLFAKTORI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8B5E3C), letterSpacing: 0.5)),
                  ),
                  Expanded(child: Container(height: 1, color: const Color(0xFFEBE6DF))),
                ],
              ),
              const SizedBox(height: 24),
              
              _buildNotesSection('TOP NOTES', ['Bergamot', 'Grapefruit']),
              const SizedBox(height: 24),
              _buildNotesSection('HEART NOTES', ['Sandalwood']),
              const SizedBox(height: 24),
              _buildNotesSection('BASE NOTES', ['Oud', 'Leather']),
              const SizedBox(height: 32),
              
              // Button Tambah
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5E3C), Color(0xFFD6A87D)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('TAMBAH PARFUM', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
                ),
              ),
              const SizedBox(height: 16),
              // Button Batal
              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('BATAL', style: TextStyle(color: Color(0xFF8B5E3C), fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8B5E3C), letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9E958D)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8B5E3C), letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: const TextStyle(fontSize: 13, color: Color(0xFF2E2B2A))),
              const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9E958D), size: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMultilineTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8B5E3C), letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            maxLines: null,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9E958D)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(String label, List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.spa_outlined, color: Color(0xFF8B5E3C), size: 14),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8B5E3C), letterSpacing: 0.5)),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFBEBE4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(tag, style: const TextStyle(fontSize: 11, color: Color(0xFF63564B))),
                const SizedBox(width: 4),
                const Icon(Icons.close, size: 12, color: Color(0xFF63564B)),
              ],
            ),
          )).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBE6DF).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Tambah bahan...',
                    hintStyle: TextStyle(fontSize: 12, color: Color(0xFF9E958D)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBE6DF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('+ TAMBAH', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8B5E3C))),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
