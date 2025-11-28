// lib/src/ui/screens/settings_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 0;
  File? _profileImage;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Row(
        children: [
          Container(
            width: 70,
            decoration: const BoxDecoration(
              color: AppColors.oliveGreen,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(45),
                bottomRight: Radius.circular(45),
              ),
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  top: 170 + (_selectedIndex * 100),
                  right: -15,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(6, 0))
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 12,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(color: AppColors.lightPink, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.black, size: 22),
                    ),
                  ),
                ),
                _sidebarIcon(Icons.person_outline, 0, top: 170),
                _sidebarIcon(Icons.logout, 1, top: 270),
                _sidebarIcon(Icons.help_outline, 2, top: 370),
                _sidebarIcon(Icons.info_outline, 3, top: 470),
              ],
            ),
          ),

          Expanded(
            child: Stack(
              children: [
                Positioned(
  top: 0,
  bottom: 0,
  right: 0,
  width: 320, 
  child: Opacity(
    opacity: 0.6, 
    child: Image.asset(
      'assets/images/bg_pattern.png',
      fit: BoxFit.cover,     
      alignment: Alignment.centerRight,
    ),
  ),
),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                  child: Padding(
                    key: ValueKey(_selectedIndex),
                    padding: const EdgeInsets.fromLTRB(32, 60, 32, 32),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarIcon(IconData icon, int index, {required double top}) {
    final isSelected = _selectedIndex == index;
    return Positioned(
      top: top,
      left: 4,
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 30,
            color: isSelected ? AppColors.sage : AppColors.lightyellow,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0: return _profileContent();
      case 1: return _logoutContent();
      case 2: return _helpContent();
      case 3: return _aboutContent();
      default: return const SizedBox();
    }
  }

  Widget _profileContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Profile", style: GoogleFonts.poppins(fontSize: 34, fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      Text("Personalize your SoulSpace", style: GoogleFonts.poppins(fontSize: 16, color: AppColors.gray)),
      const Spacer(),
      Center(
        child: Stack(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 76,
                backgroundColor: AppColors.softCoral,
                backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? const Icon(Icons.person, size: 86, color: Colors.white70)
                    : null,
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: AppColors.forest,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      const Spacer(),
      Text("Username", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
      const SizedBox(height: 10),
      Text("Change your display name", style: GoogleFonts.poppins(fontSize: 14, color: AppColors.gray)),
      const SizedBox(height: 12),
      TextField(
        decoration: InputDecoration(
          hintText: "Enter your name",
          filled: true,
          fillColor: AppColors.sage.withValues(alpha: 0.15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
      const SizedBox(height: 35),
      SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile updated!"), backgroundColor: AppColors.forest),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.forest,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: 8,
          ),
          child: Text("Save Changes", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
        ),
      ),
    ],
  );

  Widget _logoutContent() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: 90, color: AppColors.warmPink),
            const SizedBox(height: 30),
            Text("Log Out", style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text("Are you sure you want to leave?", style: GoogleFonts.poppins(fontSize: 17, color: AppColors.gray)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/auth'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.warmPink, padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: Text("Yes, Log Out", style: GoogleFonts.poppins(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(height: 20),
            TextButton(onPressed: () => setState(() => _selectedIndex = 0), child: Text("Stay Here", style: GoogleFonts.poppins(color: AppColors.gray))),
          ],
        ),
      );

  Widget _helpContent() => ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const SizedBox(height: 20),
          Text("Help & Support", style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          _helpItem("How do I journal?", "Tap the book icon in the bottom navbar to start writing your thoughts."),
          _helpItem("Can I set reminders?", "Yes! Go to Settings → Notifications to enable daily prompts."),
          _helpItem("Is my data private?", "100%. Your journal is encrypted and never shared."),
          _helpItem("How to contact support?", "Email us at support@soulspace.app — we reply within 24h"),
          const SizedBox(height: 40),
          Center(child: Text("Version 1.0.0", style: GoogleFonts.poppins(color: AppColors.gray))),
        ],
      );

  Widget _helpItem(String title, String desc) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(desc, style: GoogleFonts.poppins(fontSize: 15, color: AppColors.gray, height: 1.5)),
          ],
        ),
      );

  Widget _aboutContent() => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(child: Icon(Icons.favorite, size: 80, color: AppColors.warmPink)),
          const SizedBox(height: 30),
          Text("About SoulSpace", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Text(
            "SoulSpace is your personal sanctuary for emotional wellness.\n\n"
            "Journal freely, reflect deeply, and grow peacefully.\n\n"
            "We believe everyone deserves a safe space to feel, heal, and become their best self.\n\n"
            "Made with love in 2025 by a team that cares about mental peace.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 16, color: AppColors.gray, height: 1.7),
          ),
          const SizedBox(height: 40),
          Center(child: Text("Version 1.0.0", style: GoogleFonts.poppins(fontSize: 15, color: AppColors.gray))),
          const SizedBox(height: 20),
          Center(child: Text("© 2025 SoulSpace. All rights reserved.", style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]))),
        ],
      );
}