import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(const StudentInfoApp());

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'CSS3344 Lab 02',
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
    home: const StudentProfileScreen(),
  );
}

// The screen owns the values changed by the pickers.
class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});
  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  DateTime? _selectedDate;
  String _selectedRole = 'Student';
  static const _roles = ['Student', 'Developer', 'Designer'];

  String get _dateLabel {
    final date = _selectedDate;
    return date == null
        ? 'Not selected'
        : '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _selectMaterialDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateUtils.dateOnly(DateTime.now()),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    // The user may cancel, or the screen may close while we wait.
    if (!mounted || picked == null) return;
    setState(() => _selectedDate = picked);
  }

  void _showCupertinoDatePicker() {
    _showPickerSheet(
      CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: _selectedDate ?? DateUtils.dateOnly(DateTime.now()),
        minimumDate: DateTime(1950),
        maximumDate: DateTime.now(),
        onDateTimeChanged: (date) => setState(() => _selectedDate = date),
      ),
    );
  }

  Future<void> _showCupertinoRolePicker() async {
    final controller = FixedExtentScrollController(
      initialItem: _roles.indexOf(_selectedRole),
    );
    await _showPickerSheet(
      CupertinoPicker(
        scrollController: controller,
        itemExtent: 36,
        onSelectedItemChanged: (index) =>
            setState(() => _selectedRole = _roles[index]),
        children: _roles.map((role) => Center(child: Text(role))).toList(),
      ),
    );
    controller.dispose();
  }

  // Reuse the same sheet frame for both Cupertino pickers.
  Future<void> _showPickerSheet(Widget picker) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => Container(
        color: CupertinoColors.systemBackground.resolveFrom(sheetContext),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 260,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CupertinoButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    child: const Text('Done'),
                  ),
                ),
                Expanded(child: picker),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('CSS3344 Mobile App Dev - Lab 02'),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    ),
    body: SafeArea(
      child: OrientationBuilder(
        builder: (context, orientation) => orientation == Orientation.portrait
            ? _buildPortraitView()
            : _buildLandscapeView(),
      ),
    ),
  );

  Widget _buildPortraitView() => ListView(
    padding: const EdgeInsets.all(16),
    children: [const StudentDetailsSection(), ..._buildOtherSections()],
  );

  Widget _buildLandscapeView() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [StudentDetailsSection()],
        ),
      ),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: _buildOtherSections(),
        ),
      ),
    ],
  );

  List<Widget> _buildOtherSections() => [
    const Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Text('Location Details'),
          ),
          // Location text and photo are grouped in the same card.
          TitleSection(
            name: 'University of Technology Sarawak',
            location: 'No. 1, Jalan Universiti, Persiaran Brooke, 96000 Sibu, Sarawak, Malaysia',
            starCount: 41,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: ImageSection(imagePath: 'assets/school_photo.jpg'),
          ),
        ],
      ),
    ),
    Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Profile choices',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text('Selected date: $_dateLabel'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _selectMaterialDate,
              child: const Text('Material Date Picker'),
            ),
            OutlinedButton(
              onPressed: _showCupertinoDatePicker,
              child: const Text('Cupertino Date Picker'),
            ),
            const Divider(height: 24),
            Text('Selected role: $_selectedRole'),
            DropdownButton<String>(
              value: _selectedRole,
              isExpanded: true,
              items: _roles
                  .map(
                    (role) => DropdownMenuItem(value: role, child: Text(role)),
                  )
                  .toList(),
              onChanged: (role) {
                if (role != null) setState(() => _selectedRole = role);
              },
            ),
            OutlinedButton(
              onPressed: _showCupertinoRolePicker,
              child: const Text('Cupertino Wheel Picker'),
            ),
          ],
        ),
      ),
    ),
  ];
}

// This section displays fixed Lab 01 information, so it stays stateless.
class StudentDetailsSection extends StatelessWidget {
  const StudentDetailsSection({super.key});
  @override
  Widget build(BuildContext context) => Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: const Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/profile.png'),
          ),
          SizedBox(height: 20),
          Text(
            'VINCENT SIM ZENG KAI',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Student ID: BCS24020008', style: TextStyle(color: Colors.grey)),
          Divider(height: 32),
          Text(
            'Personal Life Goal / Quote:',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            '"Even a bullshit journey is also counted as story."',
            textAlign: TextAlign.center,
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.indigo),
          ),
        ],
      ),
    ),
  );
}

// A reusable landscape photo with rounded corners.
class ImageSection extends StatelessWidget {
  final String imagePath;
  const ImageSection({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        semanticLabel: 'University of Technology Sarawak campus',
      ),
    ),
  );
}

// Exercise 2.1: parameters let one layout display different information.
class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;
  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(location, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
        Icon(Icons.star, color: Colors.red[500]),
        const SizedBox(width: 4),
        Text('$starCount'),
      ],
    ),
  );
}
