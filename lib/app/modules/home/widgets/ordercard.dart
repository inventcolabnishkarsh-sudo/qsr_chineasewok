import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;
  final String subtitle;

  const OrderCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        elevation: 12,
        shadowColor: Colors.black38,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
          side: BorderSide(color: Colors.black.withOpacity(0.35), width: 0.6),
        ),
        child: SizedBox(
          width: 350,
          height: 450,
          child: Column(
            children: [
              // Top Red Brand Line
              Container(
                width: double.infinity,
                height: 12,
                color: const Color(0xffc7834e),
              ),

              // 🖼 Image perfectly centered in remaining space
              Expanded(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      imagePath,
                      width: 170,
                      height: 170,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // 🔽 Bottom Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Divider(thickness: 1, color: Colors.grey.shade400),
              ),

              const SizedBox(height: 14),

              Text(
                title.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.pacifico(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.pacifico(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.0,
                    color: Colors.grey.shade700,
                    height: 1.6,
                  ),
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
