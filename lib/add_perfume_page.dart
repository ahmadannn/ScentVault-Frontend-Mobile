import 'package:flutter/material.dart';
import 'package:project_pertama/services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class AddPerfumePage extends StatefulWidget {
  final int? perfumeId;
  final Map<String, dynamic>? initialData;
  const AddPerfumePage({super.key, this.perfumeId, this.initialData});

  @override
  State<AddPerfumePage> createState() => _AddPerfumePageState();
}

class _AddPerfumePageState extends State<AddPerfumePage> {
  bool _isLoading = false;
  List<dynamic> _categories = [];
  
  Uint8List? _imageBytes;
  String? _imageFileName;
  final ImagePicker _picker = ImagePicker();
  
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _descController = TextEditingController();
  
  String? _selectedCategory;
  String _selectedConcentration = 'eau de parfum'; // default
  int _starRating = 4;
  
  // Lists for notes
  final List<String> _topNotes = [];
  final List<String> _middleNotes = [];
  final List<String> _baseNotes = [];

  final _topNoteController = TextEditingController();
  final _middleNoteController = TextEditingController();
  final _baseNoteController = TextEditingController();

  final List<String> _concentrations = [
    'extrait de parfum',
    'eau de parfum',
    'eau de toilette',
    'eau de cologne'
  ];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _populateInitialData();
  }

  void _populateInitialData() {
    if (widget.initialData != null) {
      final data = widget.initialData!;
      _nameController.text = data['name'] ?? '';
      _brandController.text = data['brand_name'] ?? '';
      _descController.text = data['description'] ?? '';
      
      // Handle category - we will set it after fetching categories to ensure it's in the list
      
      _selectedConcentration = data['concentration'] ?? 'eau de parfum';
      _starRating = data['star_rating'] is int ? data['star_rating'] : int.tryParse(data['star_rating'].toString()) ?? 4;
      
      // Parse notes
      final notes = data['notes'] as List<dynamic>? ?? [];
      for (var note in notes) {
        if (note['type'] == 'top') _topNotes.add(note['name']);
        else if (note['type'] == 'middle') _middleNotes.add(note['name']);
        else if (note['type'] == 'base') _baseNotes.add(note['name']);
      }
    }
  }

  Future<void> _fetchCategories() async {
    final res = await ApiService.getCollectionPageData();
    if (res['success'] == true && res['data'] != null) {
      if (mounted) {
        setState(() {
          _categories = res['data']['categories'] ?? [];
          
          if (widget.initialData != null && widget.initialData!['category_id'] != null) {
            final catId = widget.initialData!['category_id'].toString();
            // ensure catId exists in _categories
            if (_categories.any((c) => c['id'].toString() == catId)) {
              _selectedCategory = catId;
            }
          }
        });
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageFileName = image.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal memilih gambar')));
      }
    }
  }

  void _submitPerfume() async {
    if (_nameController.text.isEmpty || _brandController.text.isEmpty || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama, Brand, dan Kategori wajib diisi')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final List<Map<String, String>> notes = [];
    for (var n in _topNotes) { notes.add({"name": n, "type": "top"}); }
    for (var n in _middleNotes) { notes.add({"name": n, "type": "middle"}); }
    for (var n in _baseNotes) { notes.add({"name": n, "type": "base"}); }

    final body = {
      "name": _nameController.text,
      "brand": _brandController.text,
      "description": _descController.text,
      "category_id": int.parse(_selectedCategory!),
      "concentration": _selectedConcentration,
      "star_rating": _starRating,
      "notes": notes,
    };

    final isUpdate = widget.perfumeId != null;
    final res = isUpdate 
        ? await ApiService.updatePerfume(widget.perfumeId!, body, imageBytes: _imageBytes, imageFileName: _imageFileName)
        : await ApiService.addPerfume(body, imageBytes: _imageBytes, imageFileName: _imageFileName);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isUpdate ? 'Parfum berhasil diperbarui!' : 'Parfum berhasil ditambahkan!')));
        Navigator.pop(context, true); // Return true so CollectionPage/DetailPage knows to refresh
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Terjadi kesalahan')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAF8),
      body: SafeArea(
        child: _categories.isEmpty 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Color(0xFF75553C), size: 20),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    widget.perfumeId != null ? 'Ubah Parfum' : 'Tambah Parfum',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF75553C),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Image Placeholder
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 180,
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC7C5C3),
                      borderRadius: BorderRadius.circular(20),
                      image: _imageBytes != null 
                          ? DecorationImage(image: MemoryImage(_imageBytes!), fit: BoxFit.cover)
                          : null,
                    ),
                    child: _imageBytes == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.camera_alt, color: Color(0xFF8B5E3C), size: 32),
                              SizedBox(height: 8),
                              Text('UNGGAH FOTO BOTOL', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF63564B))),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              _buildTextField('NAMA FRAGRANCE', 'Contoh: Oud Wood', _nameController),
              const SizedBox(height: 16),
              _buildTextField('BRAND / RUMAH PARFUM', 'Contoh: Tom Ford', _brandController),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildCategoryDropdown('KATEGORI AROMA', _categories),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildConcentrationDropdown('KONSENTRASI', _concentrations),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              _buildMultilineTextField('DESKRIPSI & NARASI AROMA', 'Ceritakan pengalaman aromatikmu...', _descController),
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
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () => setState(() => _starRating = index + 1),
                          child: Icon(
                            index < _starRating ? Icons.star : Icons.star_border,
                            color: const Color(0xFF8B5E3C),
                            size: 18,
                          ),
                        );
                      })
                      ..addAll([
                        const SizedBox(width: 8),
                        Text('$_starRating.0', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF75553C))),
                        const Text('/5', style: TextStyle(fontSize: 10, color: Color(0xFF9E958D))),
                      ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
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
              
              _buildNotesSection('TOP NOTES', _topNotes, _topNoteController, () {
                if (_topNoteController.text.isNotEmpty) {
                  setState(() {
                    _topNotes.add(_topNoteController.text);
                    _topNoteController.clear();
                  });
                }
              }, (item) => setState(() => _topNotes.remove(item))),
              
              const SizedBox(height: 24),
              
              _buildNotesSection('HEART NOTES', _middleNotes, _middleNoteController, () {
                if (_middleNoteController.text.isNotEmpty) {
                  setState(() {
                    _middleNotes.add(_middleNoteController.text);
                    _middleNoteController.clear();
                  });
                }
              }, (item) => setState(() => _middleNotes.remove(item))),
              
              const SizedBox(height: 24),
              
              _buildNotesSection('BASE NOTES', _baseNotes, _baseNoteController, () {
                if (_baseNoteController.text.isNotEmpty) {
                  setState(() {
                    _baseNotes.add(_baseNoteController.text);
                    _baseNoteController.clear();
                  });
                }
              }, (item) => setState(() => _baseNotes.remove(item))),
              
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
                  onPressed: _isLoading ? null : _submitPerfume,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(widget.perfumeId != null ? 'SIMPAN PERUBAHAN' : 'TAMBAH PARFUM', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
                ),
              ),
              const SizedBox(height: 16),
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

  Widget _buildTextField(String label, String hint, TextEditingController controller) {
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
            controller: controller,
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

  Widget _buildCategoryDropdown(String label, List<dynamic> options) {
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
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedCategory,
              hint: const Text('Pilih Kategori Aroma', style: TextStyle(fontSize: 13, color: Color(0xFF9E958D))),
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9E958D), size: 20),
              onChanged: (String? newValue) {
                setState(() => _selectedCategory = newValue);
              },
              items: options.map<DropdownMenuItem<String>>((dynamic value) {
                return DropdownMenuItem<String>(
                  value: value['id'].toString(),
                  child: Text(value['name'], style: const TextStyle(fontSize: 13, color: Color(0xFF2E2B2A))),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConcentrationDropdown(String label, List<String> options) {
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
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedConcentration,
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9E958D), size: 20),
              onChanged: (String? newValue) {
                if (newValue != null) setState(() => _selectedConcentration = newValue);
              },
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.toUpperCase(), style: const TextStyle(fontSize: 11, color: Color(0xFF2E2B2A))),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMultilineTextField(String label, String hint, TextEditingController controller) {
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
            controller: controller,
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

  Widget _buildNotesSection(String label, List<String> tags, TextEditingController controller, VoidCallback onAdd, Function(String) onRemove) {
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
          children: tags.map((tag) => GestureDetector(
            onTap: () => onRemove(tag),
            child: Container(
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
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => onAdd(),
                  decoration: const InputDecoration(
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
              child: GestureDetector(
                onTap: onAdd,
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
            ),
          ],
        ),
      ],
    );
  }
}
