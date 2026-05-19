import 'package:flutter/material.dart';
import 'package:project_pertama/profile_page.dart';

class CustomTopBar extends StatelessWidget {
  final String title;

  const CustomTopBar({super.key, this.title = 'SCENTVAULT'});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
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
              image: const DecorationImage(
                image: AssetImage('assets/images/perfume_bottle.png'), // Placeholder avatar
                fit: BoxFit.cover,
              ),
              gradient: const LinearGradient(
                colors: [Color(0xFF0F3B43), Color(0xFF071D22)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white70,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
