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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0), // Vertical reduced
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2), // Use Spacer to center vertically
              // Header
              Column(
                children: [
                  const Icon(Icons.verified_user_outlined, size: 48, color: Color(0xFFE0E7FF)), // Reduced from 60
                  const SizedBox(height: 12), // Reduced from 16
                  Text(
                    'Welcome to',
                    style: Theme.of(context).textTheme.headlineSmall, // Reduced from displayMedium
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Mind over Meds',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith( // Reduced from displayLarge
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.bold,
                          decorationColor: AppTheme.primaryBlue,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 32), // Reduced from 40 but significant break

              // Info Cards
              _buildInfoCard(
                context,
                icon: Icons.favorite_border,
                iconColor: AppTheme.errorRed,
                text: 'This app is a reminder tool only. It does not provide medical advice.',
              ),
              const SizedBox(height: 8), // Reduced from 12
              _buildInfoCard(
                context,
                icon: Icons.info_outline,
                iconColor: AppTheme.primaryBlue,
                text: 'Always follow your doctor\'s official prescription instructions.',
              ),
              const SizedBox(height: 8), // Reduced from 12
              _buildInfoCard(
                context,
                icon: Icons.security,
                iconColor: AppTheme.successGreen,
                text: 'Privacy First: All data is stored locally. No internet required.',
              ),

              const Spacer(flex: 3), // Push bottom content

              // Accept Button
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const MainLayout()),
                  );
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('I Understand & Accept'),
              ),
              const SizedBox(height: 16),
              const Text(
                'PRIVACY VERSION 1.1 • STRICT LOCAL DATA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10, // Reduced from 12
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required IconData icon, required Color iconColor, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Reduced vertical
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12), // Smaller radius
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20), // Reduced from 28
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith( // Reduced from bodyLarge
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF334155),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}


