import 'package:flutter/material.dart';

class NotificationPreference {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final bool isEnabled;
  final Function(bool)? onChanged;

  NotificationPreference({
    required this.title,
    required this.description,
    required this.icon,
    this.iconColor = const Color(0xFF4CD964),
    required this.isEnabled,
    this.onChanged,
  });
}

class NotificationPreferencesList extends StatefulWidget {
  final List<NotificationPreference> preferences;
  final Function(List<NotificationPreference>)? onPreferencesChanged;

  const NotificationPreferencesList({
    Key? key,
    required this.preferences,
    this.onPreferencesChanged,
  }) : super(key: key);

  @override
  _NotificationPreferencesListState createState() => _NotificationPreferencesListState();
}

class _NotificationPreferencesListState extends State<NotificationPreferencesList> {
  late List<NotificationPreference> _preferences;

  @override
  void initState() {
    super.initState();
    // Create a copy of the preferences to manage state locally
    _preferences = List.from(widget.preferences);
  }

  @override
  Widget build(BuildContext context) {
    if (_preferences.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "No notification preferences available.",
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            "Choose which notifications you want to receive:",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
        ..._preferences.map((pref) => _buildPreferenceItem(pref)).toList(),
      ],
    );
  }

  Widget _buildPreferenceItem(NotificationPreference preference) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xFF2c2c2e),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: preference.iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              preference.icon,
              color: preference.iconColor,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          // Title and description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  preference.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  preference.description,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Toggle switch
          Switch(
            value: preference.isEnabled,
            onChanged: (value) {
              setState(() {
                final index = _preferences.indexOf(preference);
                if (index != -1) {
                  // Create a new preference with updated isEnabled value
                  final updatedPreference = NotificationPreference(
                    title: preference.title,
                    description: preference.description,
                    icon: preference.icon,
                    iconColor: preference.iconColor,
                    isEnabled: value,
                    onChanged: preference.onChanged,
                  );
                  
                  // Replace the old preference with the updated one
                  _preferences[index] = updatedPreference;
                  
                  // Call the callback if provided
                  if (widget.onPreferencesChanged != null) {
                    widget.onPreferencesChanged!(_preferences);
                  }
                  
                  // Call the individual preference callback if provided
                  if (preference.onChanged != null) {
                    preference.onChanged!(value);
                  }
                }
              });
            },
            activeColor: Color(0xFF4CD964),
            activeTrackColor: Color(0xFF4CD964).withOpacity(0.5),
          ),
        ],
      ),
    );
  }
} 