import 'package:flutter/material.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.memberType, // e.g., 'Doctor', 'Patient', etc.
    this.greetingText = "Hi, Welcome Back,",
    this.greetingFontSize = 16,
    this.nameFontSize = 18,
    this.greetingColor = const Color(0xFF858585),
    this.nameColor = Colors.black,
    this.nameFontWeight = FontWeight.w600,
    this.maxLines = 2,
  });

  final String firstName;
  final String lastName;
  final String memberType;

  final String greetingText;
  final double greetingFontSize;
  final double nameFontSize;
  final Color greetingColor;
  final Color nameColor;
  final FontWeight nameFontWeight;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final String displayName = (memberType == 'Doctor')
        ? "Dr. $firstName $lastName"
        : "$firstName $lastName";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greetingText,
          style: TextStyle(
            fontSize: greetingFontSize,
            color: greetingColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          displayName,
          style: TextStyle(
            fontSize: nameFontSize,
            fontWeight: nameFontWeight,
            color: nameColor,
          ),
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis, // Handles long names gracefully
        ),
      ],
    );
  }
}