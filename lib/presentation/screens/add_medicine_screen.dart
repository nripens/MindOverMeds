import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/medicine_provider.dart';


class AddMedicineScreen extends ConsumerStatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  ConsumerState<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen> {
  final _nameController = TextEditingController();
  
  bool _morning = false;
  TimeOfDay? _morningTime;
  
  bool _afternoon = false;
  TimeOfDay? _afternoonTime;
  
  bool _evening = false;
  TimeOfDay? _eveningTime;

  // 0 = Infinite / Repeat Daily
  int _duration = 0; 

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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

    // Default times if enabled but not picked? Let's force pick or use defaults.
    // Spec implies "Tap to enable" might open date picker or just toggle.
    // We'll use defaults if null: 08:00, 14:00, 20:00
    final mTime = _morning ? (_morningTime?.format(context) ?? "8:00 AM") : null;
    final aTime = _afternoon ? (_afternoonTime?.format(context) ?? "2:00 PM") : null;
    final eTime = _evening ? (_eveningTime?.format(context) ?? "9:00 PM") : null;

    ref.read(medicineRepositoryProvider).addMedicine(
      name: name,
      morning: _morning,
      afternoon: _afternoon,
      evening: _evening,
      morningTime: mTime,
      afternoonTime: aTime,
      eveningTime: eTime,
      duration: _duration,
    );
    
    // Switch back to home tab (index 0) or Show success toast
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Medicine Scheduled!')),
    );
    // Reset form
    setState(() {
      _nameController.clear();
      _morning = false; _morningTime = null;
      _afternoon = false; _afternoonTime = null;
      _evening = false; _eveningTime = null;
      _duration = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medicine'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Reduced from 24
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Medicine Name', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4), // Reduced from 8
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
                contentPadding: const EdgeInsets.all(16), // Reduced from 20
              ),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 16), // Reduced from 24
            Text('Reminder Times', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8), // Reduced from 12
            
            // Morning
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
            const SizedBox(height: 8), // Reduced from 12
            
            // Afternoon
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
            const SizedBox(height: 8), // Reduced from 12
            
            // Evening
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

            const SizedBox(height: 16), // Reduced from 24
            Text('Duration (Days)', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4), // Reduced from 8
            
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Reduced from 8
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
                          iconSize: 24, // Reduced from 28
                        ),
                        const SizedBox(width: 16),
                        Text(
                          _duration == 0 ? '0' : '$_duration',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Reduced from 24
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.black),
                          onPressed: () => setState(() => _duration++),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          iconSize: 24, // Reduced from 28
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
                      fontSize: 14, // Explicit font size
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24), // Reduced from 48
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check),
              label: const Text('Save Schedule'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50), // Reduced height from 56
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
            ),
            const SizedBox(height: 16), // Reduced from 32
          ],
        ),
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
            activeColor: color,
          ),
        ],
      ),
    );
  }
}
