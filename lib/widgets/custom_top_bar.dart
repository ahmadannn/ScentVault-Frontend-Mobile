import 'package:flutter/material.dart';
import 'package:project_pertama/profile_page.dart';
import 'package:project_pertama/services/api_service.dart';
import 'package:shimmer/shimmer.dart';

class CustomTopBar extends StatefulWidget {
  final String title;
  final String? photoUrl; // Optional override

  const CustomTopBar({super.key, this.title = 'SCENTVAULT', this.photoUrl});

  @override
  State<CustomTopBar> createState() => _CustomTopBarState();
}

class _CustomTopBarState extends State<CustomTopBar> {
  String? _fetchedPhotoUrl;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.photoUrl == null) {
      _fetchProfile();
    }
  }

  Future<void> _fetchProfile() async {
    setState(() => _isLoading = true);
    final res = await ApiService.getProfile();
    if (res['success'] == true && res['data'] != null) {
      if (mounted) {
        setState(() {
          _fetchedPhotoUrl = ApiService.fixImageUrl(res['data']['image_url']);
        });
      }
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? finalPhotoUrl = widget.photoUrl ?? _fetchedPhotoUrl;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF75553C),
            letterSpacing: 2.0,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.transparent, width: 1.5),
              color: const Color(0xFF0F3B43),
              gradient: finalPhotoUrl == null || finalPhotoUrl.isEmpty ? const LinearGradient(
                colors: [Color(0xFF0F3B43), Color(0xFF071D22)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ) : null,
            ),
            child: _isLoading 
              ? Shimmer.fromColors(
                  baseColor: const Color(0xFFEBE6DF),
                  highlightColor: Colors.white,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                )
              : ClipOval(
                  child: finalPhotoUrl != null && finalPhotoUrl.isNotEmpty
                      ? Image.network(finalPhotoUrl, fit: BoxFit.cover)
                      : Image.asset('assets/images/perfume_bottle.png', fit: BoxFit.cover),
                ),
          ),
        ),
      ],
    );
  }
}
