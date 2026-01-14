import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'main_layout.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20), // Reduced from 40
                // Header
                Column(
                  children: [
                    // Placeholder for Logo or Icon if needed, or just text
                    const Icon(Icons.verified_user_outlined, size: 60, color: Color(0xFFE0E7FF)), // Reduced from 80
                    const SizedBox(height: 16), // Reduced from 24
                    Text(
                      'Welcome to',
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Mind over Meds',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: AppTheme.primaryBlue,
                            decoration: TextDecoration.underline,
                            decorationColor: AppTheme.primaryBlue,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Reduced from 40

                // Info Cards
                _buildInfoCard(
                  context,
                  icon: Icons.favorite_border,
                  iconColor: AppTheme.errorRed,
                  text: 'This app is a reminder tool only. It does not provide medical advice.',
                ),
                const SizedBox(height: 12), // Reduced from 16
                _buildInfoCard(
                  context,
                  icon: Icons.info_outline,
                  iconColor: AppTheme.primaryBlue,
                  text: 'Always follow your doctor\'s official prescription instructions.',
                ),
                const SizedBox(height: 12), // Reduced from 16
                _buildInfoCard(
                  context,
                  icon: Icons.security,
                  iconColor: AppTheme.successGreen,
                  text: 'Privacy First: All data is stored locally. No internet required.',
                ),

                const SizedBox(height: 40),

                // Accept Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const MainLayout()), // Changed from HomeScreen to MainLayout
                    );
                  },
                  child: const Text('I Understand & Accept'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'PRIVACY VERSION 1.1 • STRICT LOCAL DATA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required IconData icon, required Color iconColor, required String text}) {
    return Container(
      padding: const EdgeInsets.all(12), // Reduced from 16
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC), // Very light grey/blue
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)), // Light border
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 12), // Reduced from 16
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF334155),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

