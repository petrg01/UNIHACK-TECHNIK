import 'package:flutter/material.dart';

class DynamicWidget extends StatelessWidget {
  final Widget child;
  final double? height; // Optional fixed height
  final double cornerRadius;
  final double width;
  final Color color; // Background color
  final VoidCallback? onTap; // New: Makes the widget act as a button if provided

  const DynamicWidget({
    Key? key,
    required this.child,
    this.width = 365,
    this.cornerRadius = 49, // Default corner radius
    this.height, // Adapts to content if null, fixed height if specified
    this.color = const Color(0xFF3e3d3d), // Default background color
    this.onTap, // Optional: Turns widget into a button
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Makes it clickable if onTap is provided
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color, // Apply customizable background color
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
        child: height == null 
            ? IntrinsicHeight(child: child) // Adjust height dynamically
            : child, // Use fixed height if provided
      ),
    );
  }
}
