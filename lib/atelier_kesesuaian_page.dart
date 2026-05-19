import 'package:flutter/material.dart';

class AtelierKesesuaianPage extends StatefulWidget {
  const AtelierKesesuaianPage({super.key});

  @override
  State<AtelierKesesuaianPage> createState() => _AtelierKesesuaianPageState();
}

class _AtelierKesesuaianPageState extends State<AtelierKesesuaianPage> {
  String _selectedTemp = 'Normal';
  String _selectedTime = 'Pagi';
  String _selectedEnvironment = 'All Around';

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
              
              // Suhu
              const Text('PILIH SUHU (TEMPERATURE)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9E958D), letterSpacing: 1.0)),
              const SizedBox(height: 16),
              _buildTempOption('Dingin', 'Untuk cuaca sejuk', Icons.ac_unit),
              const SizedBox(height: 12),
              _buildTempOption('Normal', '', Icons.wb_sunny_outlined),
              const SizedBox(height: 12),
              _buildTempOption('Panas', 'Aroma segar & ringan', Icons.wb_twilight),
              
              const SizedBox(height: 32),
              // Waktu
              const Text('WAKTU (TIME OF DAY)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9E958D), letterSpacing: 1.0)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTimeOption('Pagi', Icons.wb_twilight)),
                  Expanded(child: _buildTimeOption('Siang', Icons.wb_sunny_outlined)),
                  Expanded(child: _buildTimeOption('Malam', Icons.nights_stay_outlined)),
                ],
              ),
              
              const SizedBox(height: 32),
              // Lingkungan
              const Text('LINGKUNGAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9E958D), letterSpacing: 1.0)),
              const SizedBox(height: 16),
              Container(
                height: 56,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F3EF),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildEnvOption('Indoor', Icons.home_outlined)),
                    Expanded(child: _buildEnvOption('Outdoor', Icons.nature_outlined)),
                    Expanded(child: _buildEnvOption('All Around', Icons.all_inclusive)),
                  ],
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Recommendation Card
              Container(
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
                        color: Colors.black, // Placeholder for image
                        child: const Icon(Icons.image, size: 80, color: Colors.white24),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('REKOMENDASI UTAMA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9E958D), letterSpacing: 0.5)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFBEBE4),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text('ATELIER PICK', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFFB58455))),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'The Ethereal\nChypre',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF4A3728),
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '"Sebuah perpaduan puitis antara kesegaran embun pagi dan kehangatan lumut hutan yang tenang. Sempurna untuk memulai hari dengan penuh percaya diri."',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF63564B),
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildTag('KAYU'),
                              _buildTag('AROMATIK'),
                              _buildTag('SEGAR'),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {},
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
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTempOption(String title, String subtitle, IconData icon) {
    bool isSelected = _selectedTemp == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedTemp = title),
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
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2E2B2A))),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF9E958D))),
                  ]
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: Color(0xFF75553C), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeOption(String title, IconData icon) {
    bool isSelected = _selectedTime == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedTime = title),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))] : [],
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

  Widget _buildEnvOption(String title, IconData icon) {
    bool isSelected = _selectedEnvironment == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedEnvironment = title),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))] : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 14, color: const Color(0xFF4A3728)),
                  const SizedBox(width: 4),
                  Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF4A3728))),
                ],
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 14, color: const Color(0xFF9E958D)),
                  const SizedBox(width: 4),
                  Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF9E958D))),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
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
