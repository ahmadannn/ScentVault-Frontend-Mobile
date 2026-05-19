import 'package:flutter/material.dart';
import 'package:project_pertama/login_page.dart';
import 'package:project_pertama/widgets/custom_top_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAF8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'SCENTVAULT',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF75553C),
                        letterSpacing: 2.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage(title: 'ScentVault Login')),
                          (route) => false,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBEBE4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.logout, color: Color(0xFFD6604D), size: 14),
                            SizedBox(width: 4),
                            Text(
                              'LOGOUT',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFD6604D),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 50, left: 24, right: 24),
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFD6A87D), Color(0xFF8B5E3C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            color: const Color(0xFF0F3B43),
                          ),
                          child: const Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF8B5E3C),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, size: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Elena Vance',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF75553C),
                ),
              ),
              const SizedBox(height: 24),
              // Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          children: const [
                            Text('128', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF75553C))),
                            SizedBox(height: 4),
                            Text('KOLEKSI', style: TextStyle(fontSize: 10, color: Color(0xFF9E958D), fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          children: const [
                            Text('42', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF75553C))),
                            SizedBox(height: 4),
                            Text('FAVORIT', style: TextStyle(fontSize: 10, color: Color(0xFF9E958D), fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pengaturan Akun', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF2E2B2A))),
                    const SizedBox(height: 16),
                    _buildTextField('NAMA LENGKAP', 'Elena Vance', true),
                    const SizedBox(height: 12),
                    _buildTextField('ALAMAT EMAIL', 'elena.vance@atelier.com', false),
                    const SizedBox(height: 12),
                    _buildTextField('KATA SANDI', '********', false),
                    const SizedBox(height: 12),
                    _buildTextField('KONFIRMASI KATA SANDI', '********', false),
                    const SizedBox(height: 12),
                    _buildTextField('PROVINSI', 'Pilih Provinsi', true),
                    const SizedBox(height: 12),
                    _buildTextField('KABUPATEN/KOTA', 'Pilih Kabupaten/Kota', true),
                    const SizedBox(height: 12),
                    _buildTextField('KECAMATAN', 'Pilih Kecamatan', true),
                    const SizedBox(height: 12),
                    _buildTextField('KELURAHAN/DESA', 'Pilih Kelurahan/Desa', true),
                    
                    const SizedBox(height: 32),
                    // SIMPAN PERUBAHAN BUTTON
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
                        child: const Text('SIMPAN PERUBAHAN', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // BATAL BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFEBE6DF)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        child: const Text('BATAL', style: TextStyle(color: Color(0xFF9E958D), fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, bool hasDropdown) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9E958D), letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFEBE6DF).withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF63564B)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (hasDropdown) const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9E958D), size: 20),
            ],
          ),
        ),
      ],
    );
  }
}
