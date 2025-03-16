import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import '../db/db.dart';
import '../models/transaction.dart';

/// Call this function to display the Add Transaction dialog.
Future<void> showAddTransactionDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AddTransactionDialog(),
  );
}

class AddTransactionDialog extends StatefulWidget {
  @override
  _AddTransactionDialogState createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final TextEditingController descController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController customCategoryController = TextEditingController();
  DateTime selectedDateTime = DateTime.now();

  // New state variables for the dropdown fields.
  String? selectedOperation = "Withdrawal"; // Default value.
  String? selectedCategory;

  // Dynamic Category Lists
  final List<String> withdrawalCategories = [
    "Food", "Transport", "Entertainment", "Bills", "Personal Care", 
    "Healthcare", "Education", "Debt Payments", "Shopping", "Travel", 
    "Gifts & Holidays", "Charity & Donations", "Other"
  ];

  final List<String> depositCategories = [
    "Salary", "Investment", "Gift", "Other"
  ];

  final List<String> operationOptions = ["Withdrawal", "Deposit"];

  Future<void> _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          selectedDateTime.hour,
          selectedDateTime.minute,
        );
      });
    }
  }

  void _showTimePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext builder) {
        return Container(
          height: 250,
          decoration: BoxDecoration(
            color: Color(0xFF2c2c2e),
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: selectedDateTime,
                  use24hFormat: true,
                  onDateTimeChanged: (DateTime newTime) {
                    setState(() {
                      selectedDateTime = DateTime(
                        selectedDateTime.year,
                        selectedDateTime.month,
                        selectedDateTime.day,
                        newTime.hour,
                        newTime.minute,
                      );
                    });
                  },
                ),
              ),
              CupertinoButton(
                child: Text("Done", style: TextStyle(color: Colors.blue)),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        );
      },
    );
  }

  // Build picker field without internal margin.
  Widget _buildPickerField(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Color(0xFF2c2c2e),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label: $value", style: TextStyle(color: Colors.white, fontSize: 16)),
          Icon(icon, color: Colors.white54, size: 18),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumeric = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Color(0xFF2c2c2e),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Build a full-width dropdown.
  Widget _buildDropdownField(String label, String? selectedValue, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Color(0xFF2c2c2e),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedValue,
          hint: Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
          icon: Icon(Icons.arrow_drop_down, color: Colors.white54),
          dropdownColor: Color(0xFF2c2c2e),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: Colors.white, fontSize: 16)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDialogButton(String text, Color color, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  @override
  void dispose() {
    descController.dispose();
    amountController.dispose();
    customCategoryController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return AlertDialog(
    backgroundColor: Color(0xFF3e3d3d),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    title: Text(
      "Add Transaction",
      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    content: SingleChildScrollView(
      child: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _showDatePicker,
              child: _buildPickerField("Date", DateFormat('yyyy-MM-dd').format(selectedDateTime), Icons.calendar_today),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: _showTimePicker,
              child: _buildPickerField("Time", DateFormat('HH:mm').format(selectedDateTime), Icons.access_time),
            ),
            SizedBox(height: 10),
            _buildDropdownField("Operation Type", selectedOperation, operationOptions, (newValue) {
              setState(() {
                selectedOperation = newValue;
                selectedCategory = null; // Reset category when operation changes
              });
            }),
            SizedBox(height: 10),
            _buildDropdownField(
              "Category",
              selectedCategory,
              selectedOperation == "Withdrawal" ? withdrawalCategories : depositCategories,
              (newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
            ),
            if (selectedCategory == "Other") ...[
              SizedBox(height: 10),
              _buildTextField(customCategoryController, "Custom Category"),
            ],
            SizedBox(height: 10),
            _buildTextField(descController, "Description"),
            SizedBox(height: 10),
            _buildTextField(amountController, "Amount", isNumeric: true),
          ],
        ),
      ),
    ),
    actions: [
      _buildDialogButton("Cancel", Colors.white70, () => Navigator.of(context).pop()),
      _buildDialogButton("Save", Color(0xFF4caf50), () async {
        final double enteredAmount = double.tryParse(amountController.text) ?? 0.0;
        final double amount = selectedOperation == "Withdrawal" ? -enteredAmount.abs() : enteredAmount.abs();

        final newTransaction = Transaction(
          date: DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDateTime),
          description: descController.text,
          amount: amount,
          category: selectedCategory == "Other"
              ? customCategoryController.text
              : selectedCategory ?? (selectedOperation == "Withdrawal" ? withdrawalCategories[0] : depositCategories[0]),
        );

        await TransactionDB.insertTransaction(newTransaction.toMap());

        Navigator.of(context).pop();
      }),
    ],
  );
}

}
