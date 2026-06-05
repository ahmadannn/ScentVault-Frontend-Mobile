import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:project_pertama/login_page.dart';
import 'package:project_pertama/services/api_service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  Map<String, dynamic> _profileData = {};

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isSavingPassword = false;

  String? _selectedProvinsiCode;
  String? _selectedKabupatenKotaCode;
  String? _selectedKecamatanCode;
  String? _selectedKelurahanCode;
  List<dynamic> _provinsiList = [];
  List<dynamic> _kabupatenKotaList = [];
  List<dynamic> _kecamatanList = [];
  List<dynamic> _kelurahanList = [];
  bool _isSavingRegion = false;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _fetchProvinces();
  }

  Future<void> _fetchProfile() async {
    setState(() => _isLoading = true);
    try {
      final res = await ApiService.getProfile();
      if (res['success'] == true && res['data'] != null) {
        _profileData = res['data'];
      }
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _fetchProvinces() async {
    final data = await ApiService.getProvinces();
    setState(() => _provinsiList = data);
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

  Future<void> _handleUpdatePassword() async {
    final current = _currentPasswordController.text;
    final newPass = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Semua kolom kata sandi harus diisi')));
      return;
    }
    if (newPass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Konfirmasi kata sandi tidak cocok')));
      return;
    }

    final bool? confirmChange = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Ubah Kata Sandi', style: TextStyle(color: Color(0xFF75553C), fontWeight: FontWeight.bold)),
          content: const Text('Apakah Anda yakin ingin mengubah kata sandi Anda?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal', style: TextStyle(color: Color(0xFF9E958D))),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF75553C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Yakin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );

    if (confirmChange != true) return;

    setState(() => _isSavingPassword = true);
    final res = await ApiService.updatePassword(current, newPass, confirm);
    if (mounted) {
      setState(() => _isSavingPassword = false);
      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kata sandi berhasil diubah')));
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Gagal mengubah kata sandi')));
      }
    }
  }

  Future<void> _handleUpdateRegion() async {
    if (_selectedKelurahanCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih hingga tingkat kelurahan')));
      return;
    }
    setState(() => _isSavingRegion = true);
    final res = await ApiService.updateRegion(_selectedKelurahanCode!);
    if (mounted) {
      setState(() => _isSavingRegion = false);
      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wilayah berhasil diubah')));
        _fetchProfile();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Gagal mengubah wilayah')));
      }
    }
  }

  Future<void> _pickAndUploadAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      setState(() => _isLoading = true);
      final bytes = await pickedFile.readAsBytes();
      final res = await ApiService.updateAvatar(bytes, pickedFile.name);
      if (mounted) {
        if (res['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Foto profil berhasil diubah')));
          _fetchProfile(); // reload
        } else {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Gagal mengubah foto profil')));
        }
      }
    }
  }

  Future<void> _handleLogout() async {
    setState(() => _isLoading = true);

    await ApiService.logout();
    
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage(title: 'ScentVault Login')),
        (route) => false,
      );
    }
  }

  Widget _buildShimmerSkeleton() {
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
                    const Text('SCENTVAULT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF75553C), letterSpacing: 2.0)),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: const Color(0xFFFBEBE4), borderRadius: BorderRadius.circular(20)), width: 80, height: 30),
                  ],
                ),
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(margin: const EdgeInsets.only(bottom: 50, left: 24, right: 24), height: 120, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))),
                        Container(width: 100, height: 100, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(height: 24, width: 150, color: Colors.white),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          Expanded(child: Container(height: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)))),
                          const SizedBox(width: 16),
                          Expanded(child: Container(height: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: List.generate(4, (index) => Container(height: 60, margin: const EdgeInsets.only(bottom: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)))),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildShimmerSkeleton();
    }

    final user = _profileData;
    final name = user['name'] ?? 'Kurator';
    final email = user['email'] ?? '';
    final totalPerfumes = user['perfumes_count'] ?? 0;
    final totalLogs = user['scent_logs_count'] ?? 0;

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
                      onTap: _handleLogout,
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
                          child: ClipOval(
                            child: user['image_url'] != null && ApiService.fixImageUrl(user['image_url']).isNotEmpty
                                ? Image.network(ApiService.fixImageUrl(user['image_url']), fit: BoxFit.cover)
                                : const Icon(Icons.person, size: 50, color: Colors.white),
                          ),
                        ),
                        GestureDetector(
                          onTap: _pickAndUploadAvatar,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF8B5E3C),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
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
                          children: [
                            Text('$totalPerfumes', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF75553C))),
                            const SizedBox(height: 4),
                            const Text('KOLEKSI', style: TextStyle(fontSize: 10, color: Color(0xFF9E958D), fontWeight: FontWeight.w600)),
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
                          children: [
                            Text('$totalLogs', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF75553C))),
                            const SizedBox(height: 4),
                            const Text('CATATAN', style: TextStyle(fontSize: 10, color: Color(0xFF9E958D), fontWeight: FontWeight.w600)),
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
                    _buildTextField('NAMA LENGKAP', name, false),
                    const SizedBox(height: 12),
                    _buildTextField('ALAMAT EMAIL', email, false),
                    
                    const SizedBox(height: 32),
                    const Text('Ubah Kata Sandi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF2E2B2A))),
                    const SizedBox(height: 16),
                    _buildPasswordField('KATA SANDI SAAT INI', _currentPasswordController, _obscureCurrent, (val) => setState(() => _obscureCurrent = val)),
                    const SizedBox(height: 12),
                    _buildPasswordField('KATA SANDI BARU', _newPasswordController, _obscureNew, (val) => setState(() => _obscureNew = val)),
                    const SizedBox(height: 12),
                    _buildPasswordField('KONFIRMASI KATA SANDI', _confirmPasswordController, _obscureConfirm, (val) => setState(() => _obscureConfirm = val)),
                    const SizedBox(height: 16),
                    _buildSaveButton('SIMPAN SANDI', _isSavingPassword, _handleUpdatePassword),
                    
                    const SizedBox(height: 32),
                    const Text('Lokasi Tempat Tinggal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF2E2B2A))),
                    const SizedBox(height: 16),
                    _buildDropdownField('PROVINSI', _provinsiList, _selectedProvinsiCode, (val) {
                      setState(() => _selectedProvinsiCode = val);
                      _fetchRegencies(val!);
                    }),
                    const SizedBox(height: 12),
                    _buildDropdownField('KABUPATEN/KOTA', _kabupatenKotaList, _selectedKabupatenKotaCode, (val) {
                      setState(() => _selectedKabupatenKotaCode = val);
                      _fetchDistricts(val!);
                    }),
                    const SizedBox(height: 12),
                    _buildDropdownField('KECAMATAN', _kecamatanList, _selectedKecamatanCode, (val) {
                      setState(() => _selectedKecamatanCode = val);
                      _fetchVillages(val!);
                    }),
                    const SizedBox(height: 12),
                    _buildDropdownField('KELURAHAN/DESA', _kelurahanList, _selectedKelurahanCode, (val) {
                      setState(() => _selectedKelurahanCode = val);
                    }),
                    const SizedBox(height: 16),
                    _buildSaveButton('SIMPAN LOKASI', _isSavingRegion, _handleUpdateRegion),
                    const SizedBox(height: 48),
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
                  readOnly: true, // Only display for now
                  controller: TextEditingController(text: hint),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 13, color: Color(0xFF63564B)),
                ),
              ),
              if (hasDropdown) const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9E958D), size: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool obscure, Function(bool) onToggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9E958D), letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEBE6DF)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure,
                  decoration: const InputDecoration(border: InputBorder.none),
                  style: const TextStyle(fontSize: 13, color: Color(0xFF63564B)),
                ),
              ),
              GestureDetector(
                onTap: () => onToggle(!obscure),
                child: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF9E958D), size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<dynamic> items, String? value, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF9E958D), letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEBE6DF)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              hint: const Text('Pilih', style: TextStyle(fontSize: 13, color: Color(0xFF9E958D))),
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9E958D), size: 20),
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((dynamic item) {
                return DropdownMenuItem<String>(
                  value: item['code'].toString(),
                  child: Text(item['name'], style: const TextStyle(fontSize: 13, color: Color(0xFF2E2B2A))),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(String text, bool isLoading, VoidCallback onPressed) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF75553C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 0,
        ),
        child: isLoading 
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white)),
      ),
    );
  }
}
