import 'package:finney/assets/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:finney/assets/widgets/square_tile.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  String amount = '0.00';
  String entryType = 'expense'; // Note: Typo kept consistent with your original
  String category = '';
  String date = ''; // Will be initialized in initState
  String description = '';
  String budget = 'Budget 1';
  bool showCategoryModal = false;
  bool showBudgetModal = false;
  bool showDateModal = false;

  final Map<String, List<Map<String, String>>> categories = {
    'income': [
      {'name': 'Salary', 'icon': 'attach_money'},
      {'name': 'Awards', 'icon': 'emoji_events'},
      {'name': 'Bonus', 'icon': 'card_giftcard'},
      {'name': 'Freelance', 'icon': 'work'},
      {'name': 'Investments', 'icon': 'trending_up'},
    ],
    'expense': [
      {'name': 'Food', 'icon': 'fastfood'},
      {'name': 'Transport', 'icon': 'directions_car'},
      {'name': 'Entertainment', 'icon': 'movie'},
      {'name': 'Utilities', 'icon': 'house'},
      {'name': 'Shopping', 'icon': 'shopping_bag'},
      {'name': 'Healthcare', 'icon': 'local_hospital'},
      {'name': 'Shipping', 'icon': 'local_shipping'},
    ],
  };

  final List<String> budgets = [
    'Budget 1',
    'Budget 2',
    'Personal',
    'Business',
    'Vacation',
  ];

  @override
  void initState() {
    super.initState();
    date = _formatDate(DateTime.now());
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _handleAmountChange(String text) {
    final cleanedText = text.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleanedText.isEmpty) {
      setState(() => amount = '0.00');
    } else if (!cleanedText.contains('.')) {
      setState(() => amount = '$cleanedText.00');
    } else {
      final parts = cleanedText.split('.');
      if (parts[1].length == 1) {
        setState(() => amount = '${parts[0]}.${parts[1]}0');
      } else if (parts[1].length > 2) {
        setState(() => amount = '${parts[0]}.${parts[1].substring(0, 2)}');
      } else {
        setState(() => amount = cleanedText);
      }
    }
  }

  void _handleSave() {
    // Save logic would go here
    debugPrint(
      {
        'amount': amount,
        'type': entryType,
        'category': category,
        'date': date,
        'description': description,
        'budget': budget,
      }.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Budget Selector
                _buildBudgetSelector(),
                const SizedBox(height: 20),

                // Amount Input
                _buildAmountInput(),
                const SizedBox(height: 10),

                // Add Button
                _buildAddButton(),
                const SizedBox(height: 20),

                // Type Selector
                _buildTypeSelector(),
                const SizedBox(height: 20),

                // Category Selection
                _buildCategoryField(),
                const SizedBox(height: 15),

                // Date Selection
                _buildDateField(),
                const SizedBox(height: 15),

                // Description Input
                _buildDescriptionField(),
                const SizedBox(height: 15),

                // Photo Option
                _buildPhotoOption(),
                const SizedBox(height: 25),

                // Save Button
                _buildSaveButton(),
              ],
            ),
          ),

          // Category Modal
          if (showCategoryModal) _buildCategoryModal(),

          // Budget Modal
          if (showBudgetModal) _buildBudgetModal(),

          // Date Modal
          if (showDateModal) _buildDateModal(),
        ],
      ),
    );
  }

  Widget _buildBudgetSelector() {
    return GestureDetector(
      onTap: () => setState(() => showBudgetModal = true),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              budget,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return Column(
      children: [
        const Text(
          '\$',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          width: 200,
          child: TextField(
            controller: TextEditingController(text: amount),
            onChanged: _handleAmountChange,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '0.00',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      ),
      child: Text(
        'Add. $amount',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTypeButton('income', 'Income', Icons.arrow_downward),
          ),
          Expanded(
            child: _buildTypeButton('expense', 'Expense', Icons.arrow_upward),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton(String type, String label, IconData icon) {
    final isActive = entryType == type;
    return ElevatedButton(
      onPressed: () => setState(() => entryType = type),
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.blue : Colors.transparent,
        foregroundColor: isActive ? Colors.white : Colors.blue,
        shape: const RoundedRectangleBorder(),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryField() {
    return _buildInputField(
      icon: Icons.category,
      label: 'Category',
      value: category,
      onTap: () => setState(() => showCategoryModal = true),
    );
  }

  Widget _buildDateField() {
    return _buildInputField(
      icon: Icons.calendar_today,
      label: 'Date & time',
      value: date,
      onTap: () => setState(() => showDateModal = true),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.description, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: TextEditingController(text: description),
              onChanged: (value) => setState(() => description = value),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Description',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                value.isNotEmpty ? value : label,
                style: TextStyle(
                  color: value.isNotEmpty ? Colors.black87 : Colors.grey,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoOption() {
    return GestureDetector(
      onTap: () {
        // Implement photo capture/upload
      },
      child: Row(
        children: [
          Icon(Icons.add_a_photo, color: Colors.grey[600]),
          const SizedBox(width: 10),
          Text(
            'Take a photo or upload',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _handleSave,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text(
        'Save Transaction',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCategoryModal() {
    return _buildModal(
      title: 'Select Category',
      children:
          categories[entryType]!.map((cat) {
            return ListTile(
              leading: Icon(_getIconData(cat['icon']!), color: Colors.black54),
              title: Text(cat['name']!),
              onTap: () {
                setState(() {
                  category = cat['name']!;
                  showCategoryModal = false;
                });
              },
            );
          }).toList(),
    );
  }

  Widget _buildBudgetModal() {
    return _buildModal(
      title: 'Select Budget',
      children:
          budgets.map((budg) {
            return ListTile(
              title: Text(budg),
              onTap: () {
                setState(() {
                  budget = budg;
                  showBudgetModal = false;
                });
              },
            );
          }).toList(),
    );
  }

  Widget _buildDateModal() {
    return _buildModal(
      title: 'Select Date',
      children: [
        // Placeholder for date picker - replace with actual date picker
        SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_month, size: 50, color: Colors.grey),
                const SizedBox(height: 20),
                const Text('Date picker would appear here'),
              ],
            ),
          ),
        ),
        const Divider(),
        ListTile(
          title: const Center(
            child: Text(
              'Confirm Date',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () {
            // Here you would get the selected date from the picker
            setState(() => showDateModal = false);
          },
        ),
      ],
    );
  }

  Widget _buildModal({required String title, required List<Widget> children}) {
    return Stack(
      children: [
        GestureDetector(
          onTap:
              () => setState(() {
                if (title.contains('Category')) showCategoryModal = false;
                if (title.contains('Budget')) showBudgetModal = false;
                if (title.contains('Date')) showDateModal = false;
              }),
          child: Container(color: Colors.black54),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 1),
                Flexible(child: ListView(shrinkWrap: true, children: children)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'attach_money':
        return Icons.attach_money;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'card_giftcard':
        return Icons.card_giftcard;
      case 'work':
        return Icons.work;
      case 'trending_up':
        return Icons.trending_up;
      case 'fastfood':
        return Icons.fastfood;
      case 'directions_car':
        return Icons.directions_car;
      case 'movie':
        return Icons.movie;
      case 'house':
        return Icons.house;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'local_shipping':
        return Icons.local_shipping;
      default:
        return Icons.category;
    }
  }
}
