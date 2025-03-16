import 'package:flutter/material.dart';
import 'package:technik/widgets/friends_list.dart';

class AddFriendForm extends StatefulWidget {
  final Function(Friend) onFriendAdded;

  const AddFriendForm({
    Key? key,
    required this.onFriendAdded,
  }) : super(key: key);

  @override
  _AddFriendFormState createState() => _AddFriendFormState();
}

class _AddFriendFormState extends State<AddFriendForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create a new friend from the form data
      final newFriend = Friend(
        name: _usernameController.text.trim(),
      );

      // Call the callback to add the friend
      widget.onFriendAdded(newFriend);

      // Clear the form
      _usernameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add a Friend',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          // Username field
          TextFormField(
            controller: _usernameController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Username',
              labelStyle: TextStyle(color: Colors.white70),
              hintText: 'Enter your friend\'s username',
              hintStyle: TextStyle(color: Colors.white38),
              prefixIcon: Icon(Icons.alternate_email, color: Colors.white54),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF4CD964)),
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(8),
              ),
              errorStyle: TextStyle(color: Colors.red[300]),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a username';
              }
              // Additional username validation could be added here
              return null;
            },
          ),
          SizedBox(height: 24),
          // Submit button
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4CD964),
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Add Friend',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 