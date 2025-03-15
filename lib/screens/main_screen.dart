import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/dynamic_widget.dart';
import '../db/db.dart';
import '../models/transaction.dart';
import 'package:flutter/cupertino.dart';

class MainScreen extends StatelessWidget {
  Future<void> _showAddTransactionDialog(BuildContext context) async {
    TextEditingController descController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    DateTime selectedDateTime = DateTime.now();

    void _showDatePicker() async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (pickedDate != null) {
        selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          selectedDateTime.hour,
          selectedDateTime.minute,
        );
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
                      selectedDateTime = DateTime(
                        selectedDateTime.year,
                        selectedDateTime.month,
                        selectedDateTime.day,
                        newTime.hour,
                        newTime.minute,
                      );
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF3e3d3d),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Add Transaction", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: _showDatePicker,
                    child: _buildPickerField("Date", DateFormat('yyyy-MM-dd').format(selectedDateTime), Icons.calendar_today),
                  ),
                  GestureDetector(
                    onTap: _showTimePicker,
                    child: _buildPickerField("Time", DateFormat('HH:mm').format(selectedDateTime), Icons.access_time),
                  ),
                  _buildTextField(descController, "Description"),
                  _buildTextField(amountController, "Amount", isNumeric: true),
                ],
              ),
            ),
          ),
          actions: [
            _buildDialogButton(context, "Cancel", Colors.white70, () => Navigator.of(context).pop()),
            _buildDialogButton(context, "Save", Color(0xFF4CD964), () async {
              double? amount = double.tryParse(amountController.text);
              if (amount == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Invalid amount!"),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  )
                );
                return;
              }

              final newTx = Transaction(
                date: DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDateTime),
                description: descController.text,
                amount: amount,
              );

              await TransactionDB.insertTransaction(newTx.toMap());
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Transaction Added!"),
                  backgroundColor: Color(0xFF4CD964),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2)
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildPickerField(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: EdgeInsets.only(bottom: 10),
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

  Widget _buildDialogButton(BuildContext context, String text, Color color, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2c2c2e),
      body: Center(
        child: DynamicWidget(
          width: 365,
          cornerRadius: 45,
          height: 100,
          color: Color(0xFF4CD964),
          onTap: () => _showAddTransactionDialog(context),
          child: Center(
            child: Text(
              "Add Transaction",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
