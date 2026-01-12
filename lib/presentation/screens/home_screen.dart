import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/database.dart'; // For Medicine, MedicineLog
import '../viewmodels/medicine_provider.dart';
import '../theme/app_theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicinesAsync = ref.watch(medicinesProvider);
    final nowRaw = DateTime.now();
    final today = DateTime(nowRaw.year, nowRaw.month, nowRaw.day);
    final logsForTodayAsync = ref.watch(logsForDateProvider(today));

    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Light background
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Mind over '),
            Text('Meds', style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text('OFFLINE', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      body: medicinesAsync.when(
        data: (medicines) {
          return logsForTodayAsync.when(
            data: (logs) {
              if (medicines.isEmpty) {
                return _buildEmptyState(context);
              }
              // Calculate Taken Count
              // A medicine is "Taken" if all its scheduled slots are logged as taken?
              // Or just count total taken slots vs total scheduled slots?
              // User said "0 / X Taken". Let's count *medicines* fully taken for simplicity or slots?
              // Simplest: Count number of "Green Checks" vs Total Checks.
              int totalSlots = 0;
              int takenSlots = logs.length; // Assuming logs only storing "taken=true"
              for (var m in medicines) {
                if (m.takeMorning) totalSlots++;
                if (m.takeAfternoon) totalSlots++;
                if (m.takeEvening) totalSlots++;
              }
              
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Date Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Today', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                          Text(
                            // Simple Date Format: SAT, JAN 10
                            "${_getWeekday(today.weekday)}, ${_getMonth(today.month)} ${today.day}",
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                          ),
                        ],
                      ),
                      Text(
                         "$takenSlots / $totalSlots TAKEN",
                         style: Theme.of(context).textTheme.titleMedium?.copyWith(
                           color: Colors.grey.shade400,
                           fontWeight: FontWeight.bold
                         ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  ...medicines.map((medicine) => _buildMedicineCard(context, medicine, logs, ref, today)),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text("Error loading logs: $e")),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Container(
             padding: const EdgeInsets.all(24),
             decoration: BoxDecoration(
               color: AppTheme.primaryBlue.withValues(alpha: 0.1),
               shape: BoxShape.circle,
             ),
             child: Icon(Icons.add, size: 48, color: AppTheme.primaryBlue),
           ),
           const SizedBox(height: 24),
           Text(
             'No medications added',
             style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: const Color(0xFF1E293B), fontWeight: FontWeight.bold),
           ),
           const SizedBox(height: 8),
           Text(
             'Tap "Add Med" to start your schedule.',
             style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
           ),
        ],
      ),
    );
  }

  Widget _buildMedicineCard(BuildContext context, Medicine medicine, List<MedicineLog> logs, WidgetRef ref, DateTime date) {
    // Compact: Reduce padding from 20 to 12. Reduce margin.
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Reduced vertical padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Slightly smaller radius
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                medicine.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              // Option to delete
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                onPressed: () {
                   ref.read(medicineRepositoryProvider).deleteMedicine(medicine);
                },
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 16), // Reduced space
          // Fixed 3-column layout for alignment
          Row(
            children: [
              Expanded(
                child: medicine.takeMorning 
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: _buildInteractiveIndicator(context, medicine, "morning", logs, ref, date, Icons.wb_sunny_outlined, Colors.orange),
                      )
                    : const SizedBox(),
              ),
              Expanded(
                child: medicine.takeAfternoon
                    ? Align(
                        alignment: Alignment.center,
                        child: _buildInteractiveIndicator(context, medicine, "afternoon", logs, ref, date, Icons.wb_cloudy_outlined, Colors.blue),
                      )
                    : const SizedBox(),
              ),
              Expanded(
                child: medicine.takeEvening
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: _buildInteractiveIndicator(context, medicine, "evening", logs, ref, date, Icons.nightlight_round_outlined, Colors.indigo),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveIndicator(BuildContext context, Medicine medicine, String slot, List<MedicineLog> logs, WidgetRef ref, DateTime date, IconData defaultIcon, Color defaultColor) {
    final isTaken = logs.any((l) => l.medicineId == medicine.id && l.slot == slot && l.isTaken);
    final displayTime = slot == "morning" ? (medicine.morningTime ?? "8:00")
                      : slot == "afternoon" ? (medicine.afternoonTime ?? "14:00")
                      : (medicine.eveningTime ?? "21:00");
    
    return InkWell(
      onTap: () {
        // Toggle Log
        ref.read(medicineRepositoryProvider).logIntake(medicine.id, date, slot, !isTaken);
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           if (isTaken)
              Icon(Icons.check_circle, size: 40, color: AppTheme.successGreen)
           else
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                   color: defaultColor.withValues(alpha: 0.1),
                   shape: BoxShape.circle,
                   border: Border.all(color: defaultColor.withValues(alpha: 0.3))
                ),
                child: Icon(defaultIcon, size: 20, color: defaultColor),
              ),
           const SizedBox(height: 4),
           Text(
             displayTime.split(" ")[0],
             style: TextStyle(fontWeight: FontWeight.bold, color: isTaken ? AppTheme.successGreen : Colors.grey, fontSize: 13),
           ),
        ],
      ),
    );
  }

  String _getWeekday(int day) {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return days[day - 1];
  }

  String _getMonth(int month) {
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return months[month - 1];
  }
}
