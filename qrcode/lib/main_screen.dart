import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:qrqrcode/screens/home/qr_scanner.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();

}

class _MainScreenState extends State<MainScreen>{
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const QrScanner(),
    const Placeholder(),
    const Placeholder(),
    const Placeholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color.fromRGBO(255, 255, 255, 0.2),
              width: 1,
            ),
          ),
          color: Colors.black,
        ),
        child: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),

      ),
    );
  }

}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Iconsax.scan, 'Scanner'),
          _buildNavItem(1, Iconsax.add_circle, 'Create'),
          _buildNavItem(2, Iconsax.clock, 'Salvos'),
          _buildNavItem(3, Iconsax.setting, 'Config'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = index == currentIndex;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTap(index),
            splashColor: const Color(0xFFBBFB4C).withOpacity(0.2),
            highlightColor: Colors.transparent,
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: isSelected 
                  ? const Color(0xFFBBFB4C) 
                  : const Color(0xBCBDBC).withOpacity(0.5),
                size: 26,
              ),
            ),
          ),
        ),
        if (isSelected) ...[
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}