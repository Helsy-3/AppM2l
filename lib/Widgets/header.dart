import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final bool isMenuOpen;
  final VoidCallback onMenuToggle;

  const Header({
    super.key,
    required this.isMenuOpen,
    required this.onMenuToggle,
  });

  @override
  Widget build(BuildContext context) {
    final Color redColor = const Color(0xFFDC320F);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/M2L.jpg',
                height: 70,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: Icon(
                isMenuOpen ? Icons.close : Icons.menu,
                color: redColor,
                size: 28,
              ),
              onPressed: onMenuToggle,
            ),
          ],
        ),
      ),
    );
  }
}
