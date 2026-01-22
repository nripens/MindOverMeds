import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import '../../../data/local/database.dart';
import '../theme/app_theme.dart';
import '../viewmodels/medicine_provider.dart';

class BpScreen extends ConsumerStatefulWidget {
  const BpScreen({super.key});

  @override
  ConsumerState<BpScreen> createState() => _BpScreenState();
}

class _BpScreenState extends ConsumerState<BpScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Controllers
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _pulseController = TextEditingController();

  // State
  Set<String> _selectedSlot = {'Morning'}; 
  Set<String> _selectedContext = {'Before Meds'}; 
  late DateTime _selectedWeekStart;
  
  // Edit Mode
  int? _editingId; // If null, adding new. If set, updating.
  BloodPressureLog? _editingLog; // Keep track of original log for date preservation if needed

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final now = DateTime.now();
    _selectedWeekStart = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
  }

  void _changeWeek(int weeks) {
    setState(() {
      _selectedWeekStart = _selectedWeekStart.add(Duration(days: 7 * weeks));
    });
  } 

  @override
  void dispose() {
    _tabController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startEdit(BloodPressureLog log) {
    setState(() {
      _editingId = log.id;
      _editingLog = log;
      _systolicController.text = log.systolic.toString();
      _diastolicController.text = log.diastolic.toString();
      _pulseController.text = log.pulse?.toString() ?? '';
      
      _selectedSlot = {toBeginningOfSentenceCase(log.slot) ?? 'Morning'};
      _selectedContext = {toBeginningOfSentenceCase(log.context) ?? 'Before Meds'};
    });
    // Switch to Entry Tab
    _tabController.animateTo(0);
  }

  void _cancelEdit() {
    setState(() {
      _editingId = null;
      _editingLog = null;
      _systolicController.clear();
      _diastolicController.clear();
      _pulseController.clear();
      // Reset defaults
      _selectedSlot = {'Morning'};
      _selectedContext = {'Before Meds'};
    });
    FocusScope.of(context).unfocus();
  }

  void _deleteLog(BloodPressureLog log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Reading?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
               Navigator.pop(context);
               ref.read(medicineRepositoryProvider).deleteBpLog(log);
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reading deleted")));
            }, 
            child: const Text("Delete", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }

  void _saveBp() {
    final sysText = _systolicController.text.trim();
    final diaText = _diastolicController.text.trim();
    final pulseText = _pulseController.text.trim();

    if (sysText.isEmpty || diaText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Systolic and Diastolic values.')));
      return;
    }

    final sys = int.tryParse(sysText);
    final dia = int.tryParse(diaText);
    final pulse = pulseText.isNotEmpty ? int.tryParse(pulseText) : null;

    if (sys == null || dia == null) return;

    if (sys > 180 || dia > 120) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.warning_amber_rounded, color: AppTheme.errorRed, size: 48),
          title: const Text("High Reading Alert", style: TextStyle(color: AppTheme.errorRed)),
          content: const Text("Systolic > 180 or Diastolic > 120 is dangerously high.\n\nPlease seek medical attention if this is accurate."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _commitSave(sys, dia, pulse);
              },
              child: const Text("Save Anyway", style: TextStyle(color: Colors.red)),
            ),
            FilledButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ],
        ),
      );
    } else {
      _commitSave(sys, dia, pulse);
    }
  }

  void _commitSave(int sys, int dia, int? pulse) {
    final slot = _selectedSlot.first.toLowerCase();
    final contextStr = _selectedContext.first.toLowerCase();

    if (_editingId != null && _editingLog != null) {
      // UPDATE
      final updatedLog = _editingLog!.copyWith(
        systolic: sys,
        diastolic: dia,
        pulse: drift.Value(pulse),
        slot: slot,
        context: contextStr,
        // Keep original date or update? Usually keep original date for corrections.
      );
      ref.read(medicineRepositoryProvider).updateBpLog(updatedLog);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reading updated.')));
      _cancelEdit(); // Reset form
      _tabController.animateTo(1); // Go back to history
    } else {
      // INSERT
      ref.read(medicineRepositoryProvider).addBpLog(
            sys,
            dia,
            pulse,
            DateTime.now(),
            slot,
            contextStr,
          );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved locally.'), behavior: SnackBarBehavior.floating));
      _cancelEdit(); // Clear form
      _tabController.animateTo(1); // Go to history to see it
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BP Tracker'),
        centerTitle: false,
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryBlue,
          tabs: const [
             Tab(text: "New Entry"),
             Tab(text: "History"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEntryTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildEntryTab() {
     return SingleChildScrollView(
       padding: const EdgeInsets.all(16),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
         children: [
           if (_editingId != null)
             Container(
               padding: const EdgeInsets.all(12),
               margin: const EdgeInsets.only(bottom: 16),
               decoration: BoxDecoration(
                 color: Colors.orange.shade50,
                 borderRadius: BorderRadius.circular(8),
                 border: Border.all(color: Colors.orange.shade200),
               ),
               child: Row(
                 children: [
                   const Icon(Icons.edit, size: 20, color: Colors.orange),
                   const SizedBox(width: 8),
                   Expanded(child: Text("Editing reading from ${DateFormat('MMM d, h:mm a').format(_editingLog!.loggedAt)}", style: TextStyle(color: Colors.orange.shade900))),
                   IconButton(onPressed: _cancelEdit, icon: const Icon(Icons.close, color: Colors.orange))
                 ],
               ),
             ),
           
           Row(
            children: [
              Expanded(child: _buildBigNumberInput(_systolicController, 'Systolic', '120')),
              const SizedBox(width: 16),
              Expanded(child: _buildBigNumberInput(_diastolicController, 'Diastolic', '80')),
            ],
          ),
          const SizedBox(height: 16),
          // Pulse (Optional)
          _buildBigNumberInput(_pulseController, 'Pulse (BPM)', '72', isOptional: true),
          
          const SizedBox(height: 24),
          
          const Text("Time of Day", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Morning', label: Text('M'), icon: Icon(Icons.wb_sunny_outlined)),
              ButtonSegment(value: 'Afternoon', label: Text('A'), icon: Icon(Icons.wb_cloudy_outlined)),
              ButtonSegment(value: 'Evening', label: Text('E'), icon: Icon(Icons.nights_stay_outlined)),
            ],
            selected: _selectedSlot,
            onSelectionChanged: (newSelection) => setState(() => _selectedSlot = newSelection),
            showSelectedIcon: false,
          ),
          
          const SizedBox(height: 24),
           const Text("Context", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Before Meds', label: Text('Before Meds')),
              ButtonSegment(value: 'After Meds', label: Text('After Meds')),
            ],
            selected: _selectedContext,
            onSelectionChanged: (newSelection) => setState(() => _selectedContext = newSelection),
            showSelectedIcon: false,
          ),
          
          const SizedBox(height: 32),
          
          FilledButton(
            onPressed: _saveBp,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              backgroundColor: _editingId != null ? Colors.orange : AppTheme.primaryBlue,
            ),
            child: Text(_editingId != null ? "Update Reading" : "Save Reading", style: const TextStyle(fontSize: 18)),
          ),
          if (_editingId != null)
             Padding(
               padding: const EdgeInsets.only(top: 12.0),
               child: TextButton(
                 onPressed: _cancelEdit, 
                 child: const Text("Cancel Edit", style: TextStyle(color: Colors.grey))
               ),
             ),
         ],
       ),
     );
  }

  Widget _buildHistoryTab() {
    final bpLogsAsync = ref.watch(bpLogsProvider);
    return bpLogsAsync.when(
        data: (logs) => _buildLogList(logs),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildLogList(List<BloodPressureLog> logs) {
    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monitor_heart_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text("No readings yet", style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    // Filter by week
    final weekEnd = _selectedWeekStart.add(const Duration(days: 7));
    final weekLogs = logs.where((log) {
      return log.loggedAt.isAfter(_selectedWeekStart.subtract(const Duration(milliseconds: 1))) && 
             log.loggedAt.isBefore(weekEnd);
    }).toList();

    return Column(
      children: [
        _buildWeekSelector(),
        Expanded(
          child: weekLogs.isEmpty 
          ? const Center(child: Text("No readings this week"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: weekLogs.length,
              itemBuilder: (context, index) {
                // Determine if we need a date header
                final log = weekLogs[index];
                // Assuming logs are sorted desc by provider? If not, we should sort.
                // Provider sorts by desc loggedAt.
                
                final bool showHeader = index == 0 || 
                    !DateUtils.isSameDay(weekLogs[index-1].loggedAt, log.loggedAt);
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showHeader)
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: Text(
                          DateFormat('EEEE, MMM d').format(log.loggedAt),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                      ),
                    _buildLogCard(log),
                  ],
                );
              },
            ),
        ),
      ],
    );
  }

  Widget _buildWeekSelector() {
    final startFormat = DateFormat('MMM d');
    final endFormat = DateFormat('MMM d, yyyy');
    final weekEnd = _selectedWeekStart.add(const Duration(days: 6));
    
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _changeWeek(-1),
            tooltip: "Previous Week",
          ),
          Text(
            "${startFormat.format(_selectedWeekStart)} - ${endFormat.format(weekEnd)}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _changeWeek(1),
            tooltip: "Next Week",
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard(BloodPressureLog log) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _startEdit(log),
        onLongPress: () => _deleteLog(log),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    DateFormat('jm').format(log.loggedAt),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade400),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Container(width: 1, height: 40, color: Colors.grey.shade200),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${log.systolic}/${log.diastolic}",
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        if (log.pulse != null) ...[
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(4)),
                            child: Row(
                              children: [
                                Icon(Icons.favorite, size: 14, color: Colors.red.shade400),
                                const SizedBox(width: 4),
                                Text("${log.pulse}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade700)),
                              ],
                            ),
                          )
                        ]
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildTag(log.slot, _getSlotColor(log.slot)),
                        _buildTag(log.context, Colors.blueGrey),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.edit_outlined, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBigNumberInput(TextEditingController controller, String label, String hint, {bool isOptional = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
            if (isOptional) const Text(" (Optional)", style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade200),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2)),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        toBeginningOfSentenceCase(text) ?? text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  Color _getSlotColor(String slot) {
    switch (slot.toLowerCase()) {
      case 'morning': return Colors.orange;
      case 'afternoon': return Colors.blue;
      case 'evening': return Colors.indigo;
      default: return Colors.grey;
    }
  }
}
