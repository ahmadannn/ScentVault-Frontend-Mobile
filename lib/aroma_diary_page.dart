import 'package:flutter/material.dart';
import 'package:project_pertama/widgets/custom_top_bar.dart';

class AromaDiaryPage extends StatefulWidget {
  const AromaDiaryPage({super.key});

  @override
  State<AromaDiaryPage> createState() => _AromaDiaryPageState();
}

class _AromaDiaryPageState extends State<AromaDiaryPage> {
  String _selectedPerfume = 'Santal 33';
  String _selectedWeather = 'Cerah';
  String _selectedPlace = 'Kantor';

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
          _buildDropdown(
            _selectedPerfume,
            ['Santal 33', 'Baccarat', 'Lacoco'],
            (val) => setState(() => _selectedPerfume = val!),
          ),
          
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('CUACA'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      _selectedWeather,
                      ['Cerah', 'Sejuk', 'Hujan'],
                      (val) => setState(() => _selectedWeather = val!),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('TEMPAT'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      _selectedPlace,
                      ['Kantor', 'Resto', 'Pantai'],
                      (val) => setState(() => _selectedPlace = val!),
                    ),
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
            child: const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Tulis catatan aroma Anda di sini...',
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFB5ADAA),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
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

  Widget _buildDropdown(String value, List<String> items, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3EF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9E958D), size: 20),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF2E2B2A),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildNotesList() {
    return Column(
      children: [
        _buildNoteCard(
          'Baccarat',
          '10/01/2025',
          ['RESTO', 'SEJUK'],
          '"Perpaduan mawar dan oud yang sangat megah. Memberikan rasa percaya diri ekstra saat berjalan di karpet merah malam ini."',
        ),
        const SizedBox(height: 16),
        _buildNoteCard(
          'Lacoco',
          '08/11/2024',
          ['PANTAI', 'CERAH'],
          '"Kesegaran sitrus yang sempurna untuk udara siang yang cerah. Sangat ringan dan tidak mengganggu saat menikmati kopi di teras."',
        ),
      ],
    );
  }

  Widget _buildNoteCard(String title, String date, List<String> tags, String desc) {
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2E2B2A),
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
                  const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFB5ADAA),
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: tags.map((tag) => Container(
              margin: const EdgeInsets.only(right: 8),
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
