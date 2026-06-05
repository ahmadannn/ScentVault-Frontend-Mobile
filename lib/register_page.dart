import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:project_pertama/services/api_service.dart';
import 'package:project_pertama/main_navigation.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = false;
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // ─── Dropdown values ───
  String? _selectedProvinsiCode;
  String? _selectedKabupatenKotaCode;
  String? _selectedKecamatanCode;
  String? _selectedKelurahanCode;

  List<dynamic> _provinsiList = [];
  List<dynamic> _kabupatenKotaList = [];
  List<dynamic> _kecamatanList = [];
  List<dynamic> _kelurahanList = [];

  @override
  void initState() {
    super.initState();
    _fetchProvinces();
  }

  Future<void> _fetchProvinces() async {
    final data = await ApiService.getProvinces();
    setState(() {
      _provinsiList = data;
    });
  }

  Future<void> _fetchRegencies(String provinceCode) async {
    final data = await ApiService.getRegencies(provinceCode);
    setState(() {
      _kabupatenKotaList = data;
      _selectedKabupatenKotaCode = null;
      _kecamatanList = [];
      _selectedKecamatanCode = null;
      _kelurahanList = [];
      _selectedKelurahanCode = null;
    });
  }

  Future<void> _fetchDistricts(String regencyCode) async {
    final data = await ApiService.getDistricts(regencyCode);
    setState(() {
      _kecamatanList = data;
      _selectedKecamatanCode = null;
      _kelurahanList = [];
      _selectedKelurahanCode = null;
    });
  }

  Future<void> _fetchVillages(String districtCode) async {
    final data = await ApiService.getVillages(districtCode);
    setState(() {
      _kelurahanList = data;
      _selectedKelurahanCode = null;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || _selectedKelurahanCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field dan wilayah (hingga kelurahan) harus diisi')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata sandi dan konfirmasi tidak cocok')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await ApiService.register(name, email, password, confirmPassword, _selectedKelurahanCode!);

    setState(() {
      _isLoading = false;
    });

    if (response['token'] != null) {
      await ApiService.setToken(response['token']);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi berhasil!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Registrasi gagal. Silakan coba lagi.')),
      );
    }
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
                    value: _selectedProvinsiCode,
                    hint: 'Pilih Provinsi',
                    items: _provinsiList,
                    onChanged: (val) {
                      setState(() => _selectedProvinsiCode = val);
                      if (val != null) _fetchRegencies(val);
                    },
                  ),
                  const SizedBox(height: 18),

                  // ─── Kabupaten/Kota ───
                  _buildLabel('KABUPATEN/KOTA'),
                  const SizedBox(height: 8),
                  _buildDropdownField(
                    value: _selectedKabupatenKotaCode,
                    hint: 'Pilih Kabupaten/Kota',
                    items: _kabupatenKotaList,
                    onChanged: (val) {
                      setState(() => _selectedKabupatenKotaCode = val);
                      if (val != null) _fetchDistricts(val);
                    },
                  ),
                  const SizedBox(height: 18),

                  // ─── Kecamatan ───
                  _buildLabel('KECAMATAN'),
                  const SizedBox(height: 8),
                  _buildDropdownField(
                    value: _selectedKecamatanCode,
                    hint: 'Pilih Kecamatan',
                    items: _kecamatanList,
                    onChanged: (val) {
                      setState(() => _selectedKecamatanCode = val);
                      if (val != null) _fetchVillages(val);
                    },
                  ),
                  const SizedBox(height: 18),

                  // ─── Kelurahan/Desa ───
                  _buildLabel('KELURAHAN/DESA'),
                  const SizedBox(height: 8),
                  _buildDropdownField(
                    value: _selectedKelurahanCode,
                    hint: 'Pilih Kelurahan/Desa',
                    items: _kelurahanList,
                    onChanged: (val) {
                      setState(() => _selectedKelurahanCode = val);
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
    required List<dynamic> items,
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
            return DropdownMenuItem<String>(
              value: item['code'].toString(), 
              child: Text(item['name'].toString())
            );
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
    final bool isEnabled = _agreeTerms && !_isLoading;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isEnabled ? null : const Color(0xFFD3CFCB),
          gradient: isEnabled
              ? const LinearGradient(
                  colors: [Color(0xFF8B6914), Color(0xFFC8943E), Color(0xFFD4A956)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: const Color(0xFFC8943E).withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          onPressed: (_agreeTerms && !_isLoading) ? _handleRegister : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: _isLoading 
              ? const SizedBox(
                  width: 24, 
                  height: 24, 
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                )
              : const Text(
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
