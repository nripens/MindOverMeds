import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../viewmodels/medicine_provider.dart';
import '../theme/app_theme.dart';
import '../../data/local/database.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    // Normalize date for Database Query (Local Midnight)
    final queryDate = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);

    // Watch medicines (schedule)
    final medicinesAsync = ref.watch(medicinesProvider);
    // Watch logs for the SELECTED Day (using queryDate)
    final logsAsync = ref.watch(logsForDateProvider(queryDate));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('History', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          _buildCalendar(medicinesAsync.asData?.value, logsAsync.asData?.value),
          const SizedBox(height: 16),
          _buildLegend(),
          const SizedBox(height: 16),
          Expanded(
            child: medicinesAsync.when(
              data: (medicines) {
                return logsAsync.when(
                  data: (logs) => _buildDayList(medicines, logs, queryDate),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Center(child: Text('Error: $e')),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => const Center(child: Text('Error loading medicines')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(List<Medicine>? medicines, List<MedicineLog>? logs) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2025, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        currentDay: DateTime.now(),
        calendarFormat: CalendarFormat.month,
        rowHeight: 42,
        daysOfWeekHeight: 40, // Increase space for Sun/Mon row
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        calendarStyle: CalendarStyle(
          selectedDecoration: const BoxDecoration(
            color: Colors.transparent, 
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, fontSize: 18),
          todayDecoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(color: AppTheme.primaryBlue),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
           decoration: BoxDecoration(color: Colors.transparent),
           weekdayStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
           weekendStyle: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black, size: 24),
          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black, size: 24),
          headerMargin: EdgeInsets.only(bottom: 20), // More space between Header and Days
        ),
         calendarBuilders: CalendarBuilders(
           selectedBuilder: (context, date, focusedDay) {
              // Determine status color for THE SELECTED DAY
              Color indicatorColor = Colors.orange; // Default/Pending
              
              if (medicines != null && logs != null && medicines.isNotEmpty) {
                 bool allTaken = true;
                 // Ideally we check if "all ENABLED slots for TODAY" are taken.
                 for (var m in medicines) {
                   if (m.takeMorning) {
                      if (!logs.any((l) => l.medicineId == m.id && l.slot == 'morning' && l.isTaken)) allTaken = false;
                   }
                   if (m.takeAfternoon) {
                      if (!logs.any((l) => l.medicineId == m.id && l.slot == 'afternoon' && l.isTaken)) allTaken = false;
                   }
                   if (m.takeEvening) {
                      if (!logs.any((l) => l.medicineId == m.id && l.slot == 'evening' && l.isTaken)) allTaken = false;
                   }
                 }
                 
                 if (allTaken) {
                   indicatorColor = AppTheme.successGreen;
                 } else {
                   // If not all taken, is it Missed (Red) or Pending (Orange)?
                   // User said "red only when any medicine is missed".
                   // If date is Today, untaken is Pending. If Past, untaken is Missed.
                   // But user simplified requirement: "taken all ... green ... red only when missed".
                   // Let's assume strict Red for not-all-taken to incentivize completion?
                   // Or respect time.
                   final now = DateTime.now();
                   final todayMidnight = DateTime(now.year, now.month, now.day);
                   if (date.isBefore(todayMidnight)) {
                      indicatorColor = AppTheme.errorRed; // Past & Incomplete = Missed
                   } else {
                      // Today or Future. 
                      // If Today, it is likely Pending (Orange) unless user insists on Red.
                      // Screenshots show Green Checks for taken.
                      // Assuming Orange for Pending is safer/nicer UX than Red for "Not yet taken today".
                      indicatorColor = Colors.orange; 
                   }
                 }
              }

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${date.day}',
                      style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Container(height: 3, width: 14, color: indicatorColor) 
                  ],
                ),
              );
           }
         ),
      ),
    );
  }
  
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(children: [const Icon(Icons.circle, size: 12, color: Colors.green), const SizedBox(width: 8), Text("All Taken", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600))]),
        const SizedBox(width: 24),
        Row(children: [const Icon(Icons.circle, size: 12, color: Colors.red), const SizedBox(width: 8), Text("Missed Some", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600))]),
      ],
    );
  }

  Widget _buildDayList(List<Medicine> medicines, List<MedicineLog> logs, DateTime date) {
     if (medicines.isEmpty) {
       return const Center(child: Text("No medicines scheduled"));
     }
     
     return ListView.builder(
       padding: const EdgeInsets.all(16),
       itemCount: medicines.length,
       itemBuilder: (context, index) {
         final medicine = medicines[index];
         return _buildMedicineHistoryCard(medicine, logs, date);
       },
     );
  }

  Widget _buildMedicineHistoryCard(Medicine medicine, List<MedicineLog> logs, DateTime date) {
    final medLogs = logs.where((l) => l.medicineId == medicine.id).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(medicine.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          Expanded(
            flex: 3,
            child: Row(
             children: [
               Expanded(
                 child: medicine.takeMorning 
                     ? Align(
                         alignment: Alignment.centerLeft,
                         child: _buildSlotIndicator(medLogs, "morning", medicine.morningTime ?? "8:00", date)
                       )
                     : const SizedBox(),
               ),
               Expanded(
                 child: medicine.takeAfternoon 
                     ? Align(
                         alignment: Alignment.center,
                         child: _buildSlotIndicator(medLogs, "afternoon", medicine.afternoonTime ?? "14:00", date)
                       )
                     : const SizedBox(),
               ),
               Expanded(
                 child: medicine.takeEvening 
                     ? Align(
                         alignment: Alignment.centerRight,
                         child: _buildSlotIndicator(medLogs, "evening", medicine.eveningTime ?? "21:00", date)
                       )
                     : const SizedBox(),
               ),
             ],
           ),
          )
        ],
      ),
    );
  }
  
  Widget _buildSlotIndicator(List<MedicineLog> logs, String slot, String label, DateTime date) {
    final isTaken = logs.any((l) => l.slot == slot && l.isTaken);
    // Logic: check date relation to NOW.
    // date here is "Midnight of selected day"
    // now is current time.
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    
    // Future: Selected Date > Today Midnight
    final bool isFuture = date.isAfter(todayMidnight);
    
    // Past: Selected Date < Today Midnight
    final bool isPast = date.isBefore(todayMidnight); // Yesterday or before
    
    // Today: Selected Date == Today Midnight.
    // But within today, is the SLOT future? e.g. Evening slot while it's Morning.
    // We don't parse slot time yet. So for Today, we treat untaken as "Pending" (Grey).
    
    IconData icon;
    Color color;
    
    if (isTaken) {
      icon = Icons.check_circle;
      color = AppTheme.successGreen;
    } else {
      if (isFuture) {
        icon = Icons.circle;
        color = Colors.grey.shade200;
      } else if (isPast) {
         // Past and not taken -> Missed
         icon = Icons.cancel;
         color = AppTheme.errorRed;
      } else {
         // Today and not taken -> Pending
         icon = Icons.circle;
         color = Colors.grey.shade200;
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 4),
        Text(label.split(" ")[0], style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
