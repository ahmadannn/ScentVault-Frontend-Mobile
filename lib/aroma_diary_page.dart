import 'package:flutter/material.dart';
import 'package:project_pertama/widgets/custom_top_bar.dart';
import 'package:project_pertama/services/api_service.dart';
import 'package:shimmer/shimmer.dart';

class AromaDiaryPage extends StatefulWidget {
  const AromaDiaryPage({super.key});

  @override
  State<AromaDiaryPage> createState() => _AromaDiaryPageState();
}

class _AromaDiaryPageState extends State<AromaDiaryPage> {
  bool _isLoadingData = true;
  bool _isSubmitting = false;

  List<dynamic> _perfumes = [];
  List<dynamic> _occasions = [];
  List<dynamic> _scentLogs = [];

  String? _selectedPerfumeId;
  String? _selectedOccasionId;
  String _selectedWeather = 'cerah';
  
  final _notesController = TextEditingController();

  final List<String> _weathers = ['cerah', 'mendung', 'hujan', 'panas', 'dingin'];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoadingData = true);
    try {
      // Fetch perfumes from collection data
      final collectionRes = await ApiService.getCollectionPageData();
      if (collectionRes['success'] == true && collectionRes['data'] != null) {
        _perfumes = collectionRes['data']['perfumes']['data'] ?? [];
      }

      // Fetch occasions
      _occasions = await ApiService.getOccasions();

      // Fetch logs
      _scentLogs = await ApiService.getScentLogs();

      // Set defaults
      if (_perfumes.isNotEmpty) {
        _selectedPerfumeId = _perfumes.first['id'].toString();
      }
      if (_occasions.isNotEmpty) {
        _selectedOccasionId = _occasions.first['id'].toString();
      }
    } catch (e) {
      // handle error
    } finally {
      if (mounted) {
        setState(() => _isLoadingData = false);
      }
    }
  }

  Future<void> _submitLog() async {
    if (_selectedPerfumeId == null || _selectedOccasionId == null || _notesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harap lengkapi semua isian')));
      return;
    }

    setState(() => _isSubmitting = true);

    final body = {
      "perfume_id": int.parse(_selectedPerfumeId!),
      "occasion_id": int.parse(_selectedOccasionId!),
      "weather": _selectedWeather,
      "notes": _notesController.text,
    };

    final res = await ApiService.addScentLog(body);

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Catatan aroma berhasil disimpan')));
        _notesController.clear();
        _fetchData(); // refresh list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Gagal menyimpan')));
      }
    }
  }

  Future<void> _deleteLog(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: const Text('Yakin ingin menghapus catatan aroma ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      )
    );
    
    if (confirm == true) {
      await ApiService.deleteScentLog(id);
      _fetchData();
    }
  }

  Widget _buildShimmerSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomTopBar(title: 'BUKU HARIAN AROMA'),
          const SizedBox(height: 32),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: 120, color: Colors.white),
                const SizedBox(height: 16),
                Container(height: 60, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: Container(height: 60, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)))),
                    const SizedBox(width: 16),
                    Expanded(child: Container(height: 60, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)))),
                  ],
                ),
                const SizedBox(height: 16),
                Container(height: 120, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
                const SizedBox(height: 24),
                Container(height: 48, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24))),
                const SizedBox(height: 32),
                Container(height: 14, width: 120, color: Colors.white),
                const SizedBox(height: 16),
                Container(height: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
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
                const CustomTopBar(title: 'BUKU HARIAN AROMA'),
                const SizedBox(height: 32),
                
                _buildSectionTitle('CATATAN BARU'),
                const SizedBox(height: 16),
                _buildNewEntryForm(),
                
                const SizedBox(height: 32),
                _buildSectionTitle('LIST CATATAN'),
                const SizedBox(height: 16),
                _buildNotesList(),
                const SizedBox(height: 32),
              ],
            ),
          ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Color(0xFF75553C),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xFFEBE6DF),
          ),
        ),
      ],
    );
  }

  Widget _buildNewEntryForm() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('PILIH PARFUM'),
          const SizedBox(height: 8),
          _buildPerfumeDropdown(),
          
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('CUACA'),
                    const SizedBox(height: 8),
                    _buildWeatherDropdown(),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('TEMPAT/OCCASION'),
                    const SizedBox(height: 8),
                    _buildOccasionDropdown(),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          _buildLabel('CATATAN AROMA'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F3EF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Tulis catatan aroma Anda di sini...',
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFB5ADAA),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF63564B),
                height: 1.5,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
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
              onPressed: _isSubmitting ? null : _submitLog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: _isSubmitting 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text(
                    'SIMPAN ENTRI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: Color(0xFF9E958D),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildPerfumeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3EF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPerfumeId,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9E958D), size: 20),
          items: _perfumes.map((item) {
            return DropdownMenuItem<String>(
              value: item['id'].toString(),
              child: Text(
                item['name'],
                style: const TextStyle(fontSize: 13, color: Color(0xFF2E2B2A)),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedPerfumeId = val),
        ),
      ),
    );
  }

  Widget _buildOccasionDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3EF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedOccasionId,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9E958D), size: 20),
          items: _occasions.map((item) {
            return DropdownMenuItem<String>(
              value: item['id'].toString(),
              child: Text(
                item['name'],
                style: const TextStyle(fontSize: 13, color: Color(0xFF2E2B2A)),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedOccasionId = val),
        ),
      ),
    );
  }

  Widget _buildWeatherDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3EF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedWeather,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9E958D), size: 20),
          items: _weathers.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item.toUpperCase(),
                style: const TextStyle(fontSize: 11, color: Color(0xFF2E2B2A)),
              ),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedWeather = val!),
        ),
      ),
    );
  }

  Widget _buildNotesList() {
    if (_scentLogs.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('Belum ada catatan aroma.', style: TextStyle(color: Color(0xFF9E958D))),
        ),
      );
    }
    
    return Column(
      children: _scentLogs.map((log) {
        final perfumeName = log['perfume']?['name'] ?? 'Unknown';
        final occasionName = log['occasion']?['name'] ?? 'Unknown';
        final weather = log['weather'] ?? 'Unknown';
        final date = log['log_date'] ?? '';
        final notes = log['notes'] ?? '';
        final id = log['id'];
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildNoteCard(perfumeName, date, [occasionName.toString().toUpperCase(), weather.toString().toUpperCase()], notes, id),
        );
      }).toList(),
    );
  }

  Widget _buildNoteCard(String title, String date, List<String> tags, String desc, int id) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2E2B2A),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFB5ADAA),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _deleteLog(id),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Color(0xFFD6604D),
                      size: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFBEBE4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFB58455),
                  letterSpacing: 0.5,
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF63564B),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
