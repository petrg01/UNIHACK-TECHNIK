import 'package:flutter/material.dart';

class CustomPopup extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final double? width;
  final double? height;
  final Color backgroundColor;
  final BorderRadius borderRadius;

  const CustomPopup({
    Key? key,
    required this.title,
    required this.content,
    this.actions,
    this.width,
    this.height,
    this.backgroundColor = const Color(0xFF3c3c3e),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: width,
        constraints: BoxConstraints(
          maxWidth: width ?? MediaQuery.of(context).size.width * 0.9,
          maxHeight: height ?? MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title bar
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.9),
                borderRadius: BorderRadius.only(
                  topLeft: borderRadius.topLeft,
                  topRight: borderRadius.topRight,
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    splashRadius: 20,
                  ),
                ],
              ),
            ),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: content,
                ),
              ),
            ),
            
            // Actions if any
            if (actions != null && actions!.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: backgroundColor.withOpacity(0.9),
                  borderRadius: BorderRadius.only(
                    bottomLeft: borderRadius.bottomLeft,
                    bottomRight: borderRadius.bottomRight,
                  ),
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Static method to show the popup easily
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
    double? width,
    double? height,
    Color backgroundColor = const Color(0xFF3c3c3e),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(16)),
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => CustomPopup(
        title: title,
        content: content,
        actions: actions,
        width: width,
        height: height,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
      ),
    );
  }
} 