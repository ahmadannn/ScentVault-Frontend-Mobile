import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // ─── Dropdown values ───
  String? _selectedProvinsi;
  String? _selectedKabupatenKota;
  String? _selectedKabupatenKota2;
  String? _selectedKecamatan;
  String? _selectedKelurahan;

  // ─── Sample data for dropdowns ───
  final List<String> _provinsiList = [
    'DKI Jakarta',
    'Jawa Barat',
    'Jawa Tengah',
    'Jawa Timur',
    'Banten',
    'Yogyakarta',
    'Bali',
    'Sumatera Utara',
    'Sumatera Barat',
    'Sulawesi Selatan',
  ];

  final List<String> _kabupatenKotaList = [
    'Jakarta Selatan',
    'Jakarta Pusat',
    'Jakarta Barat',
    'Jakarta Timur',
    'Jakarta Utara',
    'Bandung',
    'Surabaya',
    'Semarang',
    'Yogyakarta',
    'Denpasar',
  ];

  final List<String> _kecamatanList = [
    'Kebayoran Baru',
    'Menteng',
    'Tanah Abang',
    'Setiabudi',
    'Tebet',
    'Pancoran',
    'Mampang Prapatan',
    'Pasar Minggu',
  ];

  final List<String> _kelurahanList = [
    'Senayan',
    'Selong',
    'Gunung',
    'Pulo',
    'Melawai',
    'Kramat Pela',
    'Cipete Utara',
    'Gandaria Utara',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      body: Column(
        children: [
          // ─── Scrollable Content ───
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 28),

                  // ─── Heading ───
                  const Text(
                    'Buat Akun Baru',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF5C3D2E),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Mulailah perjalanan Anda ke dunia\nwewangian mewah',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8C7B6B),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ─── Nama Lengkap ───
                  _buildLabel('NAMA LENGKAP'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _nameController,
                    hintText: 'Janice Atelier',
                  ),
                  const SizedBox(height: 18),

                  // ─── Alamat Email ───
                  _buildLabel('ALAMAT EMAIL'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _emailController,
                    hintText: 'janice@scentvault.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 18),

                  // ─── Kata Sandi ───
                  _buildLabel('KATA SANDI'),
                  const SizedBox(height: 8),
                  _buildPasswordField(
                    controller: _passwordController,
                    obscure: _obscurePassword,
                    onToggle: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  const SizedBox(height: 18),

                  // ─── Konfirmasi Kata Sandi ───
                  _buildLabel('KONFIRMASI KATA SANDI'),
                  const SizedBox(height: 8),
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    obscure: _obscureConfirmPassword,
                    onToggle: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  const SizedBox(height: 18),

                  // ─── Provinsi ───
                  _buildLabel('PROVINSI'),
                  const SizedBox(height: 8),
                  _buildDropdownField(
                    value: _selectedProvinsi,
                    hint: 'Pilih Provinsi',
                    items: _provinsiList,
                    onChanged: (val) {
                      setState(() => _selectedProvinsi = val);
                    },
                  ),
                  const SizedBox(height: 18),

                  // ─── Kabupaten/Kota ───
                  _buildLabel('KABUPATEN/KOTA'),
                  const SizedBox(height: 8),
                  _buildDropdownField(
                    value: _selectedKabupatenKota,
                    hint: 'Pilih Kabupaten/Kota',
                    items: _kabupatenKotaList,
                    onChanged: (val) {
                      setState(() => _selectedKabupatenKota = val);
                    },
                  ),
                  const SizedBox(height: 18),

                  // ─── Kabupaten/Kota 2 ───
                  _buildLabel('KABUPATEN/KOTA'),
                  const SizedBox(height: 8),
                  _buildDropdownField(
                    value: _selectedKabupatenKota2,
                    hint: 'Pilih Kabupaten/Kota',
                    items: _kabupatenKotaList,
                    onChanged: (val) {
                      setState(() => _selectedKabupatenKota2 = val);
                    },
                  ),
                  const SizedBox(height: 18),

                  // ─── Kecamatan ───
                  _buildLabel('KECAMATAN'),
                  const SizedBox(height: 8),
                  _buildDropdownField(
                    value: _selectedKecamatan,
                    hint: 'Pilih Kecamatan',
                    items: _kecamatanList,
                    onChanged: (val) {
                      setState(() => _selectedKecamatan = val);
                    },
                  ),
                  const SizedBox(height: 18),

                  // ─── Kelurahan/Desa ───
                  _buildLabel('KELURAHAN/DESA'),
                  const SizedBox(height: 8),
                  _buildDropdownField(
                    value: _selectedKelurahan,
                    hint: 'Pilih Kelurahan/Desa',
                    items: _kelurahanList,
                    onChanged: (val) {
                      setState(() => _selectedKelurahan = val);
                    },
                  ),
                  const SizedBox(height: 22),

                  // ─── Terms Checkbox ───
                  _buildTermsCheckbox(),
                  const SizedBox(height: 24),

                  // ─── Register Button ───
                  _buildRegisterButton(),
                  const SizedBox(height: 24),

                  // ─── Login Link ───
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Sudah punya akun?  ',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF8C7B6B),
                        ),
                        children: [
                          TextSpan(
                            text: 'Masuk',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF5C3D2E),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(context);
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  WIDGETS
  // ═══════════════════════════════════════════════════════════════════════

  // ─── Field Label ──────────────────────────────────────────────────────
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color(0xFF5C3D2E),
        letterSpacing: 1.2,
      ),
    );
  }

  // ─── Generic Text Field ───────────────────────────────────────────────
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0EBE5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 15, color: Color(0xFF3A2A1D)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15,
            color: const Color(0xFF5C3D2E).withValues(alpha: 0.4),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // ─── Password Field ───────────────────────────────────────────────────
  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0EBE5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF3A2A1D),
          letterSpacing: 2,
        ),
        decoration: InputDecoration(
          hintText: '••••••••',
          hintStyle: TextStyle(
            fontSize: 20,
            color: const Color(0xFF5C3D2E).withValues(alpha: 0.35),
            letterSpacing: 3,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          border: InputBorder.none,
          suffixIcon: IconButton(
            onPressed: onToggle,
            icon: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFFB09A85),
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  // ─── Dropdown Field ───────────────────────────────────────────────────
  Widget _buildDropdownField({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0EBE5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: TextStyle(
              fontSize: 15,
              color: const Color(0xFF5C3D2E).withValues(alpha: 0.4),
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: const Color(0xFF5C3D2E).withValues(alpha: 0.5),
            size: 26,
          ),
          style: const TextStyle(fontSize: 15, color: Color(0xFF3A2A1D)),
          dropdownColor: const Color(0xFFF5F0EB),
          borderRadius: BorderRadius.circular(12),
          items: items.map((item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ─── Terms & Conditions Checkbox ──────────────────────────────────────
  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _agreeTerms,
            onChanged: (val) {
              setState(() => _agreeTerms = val ?? false);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: const BorderSide(color: Color(0xFFB09A85), width: 1.5),
            activeColor: const Color(0xFF5C3D2E),
            checkColor: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: const TextSpan(
              text: 'Saya setuju dengan ',
              style: TextStyle(fontSize: 13, color: Color(0xFF8C7B6B)),
              children: [
                TextSpan(
                  text: 'Syarat & Ketentuan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5C3D2E),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Register Button ──────────────────────────────────────────────────
  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF8B6914), Color(0xFFC8943E), Color(0xFFD4A956)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC8943E).withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _agreeTerms
              ? () {
                  // Handle registration
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'BERGABUNG DENGAN ATELIER',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}
