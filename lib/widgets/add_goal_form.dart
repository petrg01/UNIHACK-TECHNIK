import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:technik/widgets/goals_list.dart';

class AddGoalForm extends StatefulWidget {
  final Function(Goal) onGoalAdded;

  const AddGoalForm({
    Key? key,
    required this.onGoalAdded,
  }) : super(key: key);

  @override
  _AddGoalFormState createState() => _AddGoalFormState();
}

class _AddGoalFormState extends State<AddGoalForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _currentAmountController = TextEditingController();
  DateTime _targetDate = DateTime.now().add(Duration(days: 365)); // Default to 1 year
  String _selectedCategory = 'Savings';
  Color _selectedColor = Color(0xFF4CD964); // Default green
  
  // Predefined categories with colors
  final Map<String, Color> _categories = {
    'Savings': Color(0xFF4CD964), // Green
    'Emergency Fund': Color(0xFFFF9500), // Orange
    'Retirement': Color(0xFF007AFF), // Blue
    'Car': Color(0xFF5856D6), // Purple
    'Home': Color(0xFFFF2D55), // Red
    'Education': Color(0xFF5AC8FA), // Light Blue
    'Travel': Color(0xFFAF52DE), // Purple
    'Other': Color(0xFF8E8E93), // Gray
  };

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    _currentAmountController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, create a new goal
      final newGoal = Goal(
        title: _titleController.text,
        description: _descriptionController.text,
        targetAmount: double.parse(_targetAmountController.text),
        currentAmount: double.parse(_currentAmountController.text),
        targetDate: _targetDate,
        category: _selectedCategory,
        categoryColor: _selectedColor,
      );
      
      // Call the callback
      widget.onGoalAdded(newGoal);
    }
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xFF4CD964),
              onPrimary: Colors.white,
              surface: Color(0xFF3c3c3e),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Color(0xFF2c2c2e),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _targetDate) {
      setState(() {
        _targetDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add New Goal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // Title field
                _buildTextField(
                  controller: _titleController,
                  label: 'Goal Title',
                  hint: 'e.g., New Car, Emergency Fund',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Description field
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Brief description of your goal',
                  maxLines: 2,
                ),
                SizedBox(height: 16),
                // Target amount field
                _buildTextField(
                  controller: _targetAmountController,
                  label: 'Target Amount (\$)',
                  hint: 'e.g., 10000',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a target amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Current amount field
                _buildTextField(
                  controller: _currentAmountController,
                  label: 'Current Amount (\$)',
                  hint: 'e.g., 1000',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a current amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    if (double.parse(value) > double.parse(_targetAmountController.text)) {
                      return 'Current amount cannot exceed target';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Target date field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Target Date',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFF2c2c2e),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('MMM dd, yyyy').format(_targetDate),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Icon(
                              Icons.calendar_today,
                              color: Colors.white70,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Category dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFF2c2c2e),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: Color(0xFF2c2c2e),
                          isExpanded: true,
                          value: _selectedCategory,
                          items: _categories.keys.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: _categories[category],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    category,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedCategory = newValue;
                                _selectedColor = _categories[newValue]!;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4CD964),
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _submitForm,
                    child: Text(
                      'Add Goal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white38),
            filled: true,
            fillColor: Color(0xFF2c2c2e),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          style: TextStyle(color: Colors.white),
          validator: validator,
        ),
      ],
    );
  }
} 