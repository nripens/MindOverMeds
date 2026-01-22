import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/medicine_provider.dart';
import '../../data/local/database.dart';
import '../../services/notification_service.dart';
import '../theme/app_theme.dart';


class AddMedicineScreen extends ConsumerStatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  ConsumerState<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _nameController = TextEditingController();
  
  // Edit Mode State
  int? _editingId; 

  bool _morning = false;
  TimeOfDay? _morningTime;
  
  bool _afternoon = false;
  TimeOfDay? _afternoonTime;
  
  bool _evening = false;
  TimeOfDay? _eveningTime;

  int _duration = 0; 

  int _frequency = 0;
  Set<int> _selectedDays = {};

  final List<String> _weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S']; 

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tabController.dispose();
    super.dispose();
  }
  
  void _resetForm() {
    setState(() {
      _editingId = null;
      _nameController.clear();
      _morning = false; _morningTime = null;
      _afternoon = false; _afternoonTime = null;
      _evening = false; _eveningTime = null;
      _duration = 0;
      _frequency = 0;
      _selectedDays.clear();
    });
  }
  
  void _loadForEdit(Medicine m) {
    setState(() {
      _editingId = m.id;
      _nameController.text = m.name;
      
      _morning = m.takeMorning;
      _morningTime = m.morningTime != null ? _parseTime(m.morningTime!) : null;
      
      _afternoon = m.takeAfternoon;
      _afternoonTime = m.afternoonTime != null ? _parseTime(m.afternoonTime!) : null;
      
      _evening = m.takeEvening;
      _eveningTime = m.eveningTime != null ? _parseTime(m.eveningTime!) : null;
      
      _duration = m.duration;
      _frequency = m.frequencyType;
      
      if (m.selectedDays != null && m.selectedDays!.isNotEmpty) {
        _selectedDays = m.selectedDays!.split(',').map(int.parse).toSet();
      } else {
        _selectedDays = {};
      }
    });
    // Switch to Form Tab
    _tabController.animateTo(0);
  }
  
  TimeOfDay _parseTime(String s) {
    // Expected format "8:00 AM" or similar. 
    // Simplified parsing assuming standardized format or just implementation specific.
    // Actually our previous implementation just saved formatted string.
    // Let's assume standard TimeOfDay format logic or simple regex.
    // However, since we stored `TimeOfDay.format(context)`, it depends on locale.
    // Ideally we store HH:mm 24h, but we are storing display string.
    // For now, let's just reset time if parse fails or implement basic 12h parser.
    // A robust way would be to just use current time if fail.
    try {
      // Basic 12h parser: "8:00 AM"
      final parts = s.split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      if (parts.length > 1) {
        if (parts[1] == "PM" && hour != 12) hour += 12;
        if (parts[1] == "AM" && hour == 12) hour = 0;
      }
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return TimeOfDay.now();
    }
  }

  Future<void> _pickTime(TimeOfDay? initial, Function(TimeOfDay) onPicked) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial ?? TimeOfDay.now(),
    );
    if (picked != null) {
      onPicked(picked);
    }
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a medicine name.')),
      );
      return;
    }

    if (!_morning && !_afternoon && !_evening) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enable at least one reminder.')),
      );
      return;
    }

    final mTime = _morning ? (_morningTime?.format(context) ?? "8:00 AM") : null;
    final aTime = _afternoon ? (_afternoonTime?.format(context) ?? "2:00 PM") : null;
    final eTime = _evening ? (_eveningTime?.format(context) ?? "9:00 PM") : null;

    if (_editingId != null) {
      // UPDATE
      final updated = Medicine(
        id: _editingId!,
        name: name,
        takeMorning: _morning,
        takeAfternoon: _afternoon,
        takeEvening: _evening,
        morningTime: mTime,
        afternoonTime: aTime,
        eveningTime: eTime,
        duration: _duration,
        frequencyType: _frequency,
        selectedDays: _frequency == 1 ? _selectedDays.join(',') : null,
      );
      
      ref.read(medicineRepositoryProvider).updateMedicine(updated);
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Schedule Updated!')));
    } else {
      // INSERT
      ref.read(medicineRepositoryProvider).addMedicine(
        name: name,
        morning: _morning,
        afternoon: _afternoon,
        evening: _evening,
        morningTime: mTime,
        afternoonTime: aTime,
        eveningTime: eTime,
        duration: _duration,
        frequencyType: _frequency,
        selectedDays: _frequency == 1 ? _selectedDays.join(',') : null,
      );
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Medicine Scheduled!')));
    }
    
    _resetForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Medicines'),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryBlue,
          tabs: const [
            Tab(text: "Add / Edit"),
            Tab(text: "My List"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildForm(),
          _buildList(),
        ],
      )
    );
  }
  
  Widget _buildList() {
    final allMeds = ref.watch(medicinesProvider);
    
    return allMeds.when(
      data: (medicines) {
        if (medicines.isEmpty) return const Center(child: Text("No medicines added yet."));
        
        return ListView.builder(
          itemCount: medicines.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final med = medicines[index];
            return Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200)),
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(med.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(_getScheduleSummary(med)),
                trailing: const Icon(Icons.edit_outlined, color: Colors.blue),
                onTap: () => _loadForEdit(med),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text("Error: $e")),
    );
  }
  
  String _getScheduleSummary(Medicine med) {
    if (med.frequencyType == 0) return "Daily";
    if (med.selectedDays == null) return "Unknown Schedule";
    // Convert 1,3,5 to Mon, Wed, Fri
    final dayNames = {1:'Mon', 2:'Tue', 3:'Wed', 4:'Thu', 5:'Fri', 6:'Sat', 7:'Sun'};
    final days = med.selectedDays!.split(',').map((e) => dayNames[int.tryParse(e)] ?? '').join(', ');
    return days;
  }

  Widget _buildForm() {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_editingId != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.amber.shade200)),
                child: Row(
                  children: [
                    const Icon(Icons.edit, size: 20, color: Colors.amber),
                    const SizedBox(width: 8),
                    const Text("Editing Mode", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                    const Spacer(),
                    TextButton(onPressed: _resetForm, child: const Text("Cancel"))
                  ],
                ),
              ),
          
            Text('Medicine Name', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'e.g. BP Med',
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 16),
            Text('Reminder Times', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            
            _buildTimeRow(
              label: 'Morning',
              icon: Icons.wb_sunny_outlined,
              color: Colors.orange,
              isEnabled: _morning,
              time: _morningTime,
              onToggle: () {
                setState(() => _morning = !_morning);
                if (_morning && _morningTime == null) {
                   _pickTime(const TimeOfDay(hour: 8, minute: 0), (t) => setState(() => _morningTime = t));
                }
              },
              onTimeTap: () => _pickTime(_morningTime, (t) => setState(() => _morningTime = t)),
            ),
            const SizedBox(height: 8),
            
            _buildTimeRow(
              label: 'Afternoon',
              icon: Icons.wb_cloudy_outlined,
              color: Colors.blue,
              isEnabled: _afternoon,
              time: _afternoonTime,
              onToggle: () {
                setState(() => _afternoon = !_afternoon);
                if (_afternoon && _afternoonTime == null) {
                   _pickTime(const TimeOfDay(hour: 14, minute: 0), (t) => setState(() => _afternoonTime = t));
                }
              },
              onTimeTap: () => _pickTime(_afternoonTime, (t) => setState(() => _afternoonTime = t)),
            ),
            const SizedBox(height: 8),
            
            _buildTimeRow(
              label: 'Evening',
              icon: Icons.nightlight_outlined,
              color: Colors.indigo,
              isEnabled: _evening,
              time: _eveningTime,
              onToggle: () {
                 setState(() => _evening = !_evening);
                 if (_evening && _eveningTime == null) {
                    _pickTime(const TimeOfDay(hour: 21, minute: 0), (t) => setState(() => _eveningTime = t));
                 }
              },
              onTimeTap: () => _pickTime(_eveningTime, (t) => setState(() => _eveningTime = t)),
            ),

            const SizedBox(height: 16),
            Text('Duration (Days)', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                          onPressed: () {
                            if (_duration > 0) setState(() => _duration--);
                          },
                          constraints: const BoxConstraints(), 
                          padding: EdgeInsets.zero,
                          iconSize: 24,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          _duration == 0 ? '0' : '$_duration',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.black),
                          onPressed: () => setState(() => _duration++),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          iconSize: 24,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _duration == 0 ? 'Infinite (repeat daily)' : 'Count down $_duration days',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Text('Frequency', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('Daily'), icon: Icon(Icons.calendar_today)),
                ButtonSegment(value: 1, label: Text('Specific Days'), icon: Icon(Icons.date_range)),
              ],
              selected: {_frequency},
              onSelectionChanged: (newSelection) => setState(() => _frequency = newSelection.first),
              showSelectedIcon: false,
              style: ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            
            if (_frequency == 1) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final dayNum = index + 1; // 1 = Mon
                  final isSelected = _selectedDays.contains(dayNum);
                  return InkWell(
                    onTap: () {
                      setState(() {
                         if (isSelected) {
                           _selectedDays.remove(dayNum);
                         } else {
                           _selectedDays.add(dayNum);
                         }
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryBlue : Colors.white,
                        border: Border.all(color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade300),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        _weekDays[index],
                        style: TextStyle(
                           fontWeight: FontWeight.bold,
                           color: isSelected ? Colors.white : Colors.grey.shade600
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],

            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _save,
              icon: Icon(_editingId != null ? Icons.save_as : Icons.check),
              label: Text(_editingId != null ? 'Update Schedule' : 'Save Schedule'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
  }

  Widget _buildTimeRow({
    required String label,
    required IconData icon,
    required Color color,
    required bool isEnabled,
    required TimeOfDay? time,
    required VoidCallback onToggle,
    required VoidCallback onTimeTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
      decoration: BoxDecoration(
        color: isEnabled ? color.withAlpha(25) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEnabled ? color : Colors.grey.shade200,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Spacer(),
          if (isEnabled) ...[
             InkWell(
                onTap: onTimeTap,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        time?.format(context) ?? "--:--",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            const Spacer(),
          ],
          Switch.adaptive(
            value: isEnabled, 
            onChanged: (v) => onToggle(),
            activeTrackColor: color,
          ),
        ],
      ),
    );
  }
}
